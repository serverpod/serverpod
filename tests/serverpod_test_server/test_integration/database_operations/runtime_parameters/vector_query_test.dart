import 'dart:math' as math;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

const totalVectors = 5000;
const vectorDimension = 512;

/// The number of vectors each query asks for.
const resultLimit = 30;

/// An efSearch below [resultLimit]. Without an iterative scan, the HNSW scan
/// cannot return more rows than the size of its dynamic candidate list, so this
/// caps the query below the requested [resultLimit].
const smallEfSearch = 10;

/// An efSearch well above [resultLimit], leaving the scan free to return the
/// full [resultLimit] and to explore a superset of the candidates visited with
/// [smallEfSearch].
const largeEfSearch = 500;

void main() {
  withServerpod(
    'Given a large number of vectors with very similar distances',
    (sessionBuilder, _) {
      final session = sessionBuilder.build();
      final queryVector = Vector(
        [0.5, 0.5] + List.filled(vectorDimension - 2, 0.0),
      );

      setUpAll(() async {
        final random = math.Random(42);
        final zeroFilledVector = Vector(List.filled(vectorDimension, 0.0));

        // Create 5000 vectors with very similar distances around the query
        // point [0.5, 0.5, ...]. This creates many borderline cases where a low
        // efSearch misses vectors that a high efSearch finds.
        final testVectors = [
          for (int i = 0; i < totalVectors; i++)
            ObjectWithVector(
              vector: zeroFilledVector,
              vectorIndexedHnsw: generateTestVector(i, random: random),
              vectorIndexedHnswWithParams: zeroFilledVector,
              vectorIndexedIvfflat: zeroFilledVector,
              vectorIndexedIvfflatWithParams: zeroFilledVector,
            ),
        ];

        await ObjectWithVector.db.insert(session, testVectors);
      });

      group(
        'when the same nearest neighbor query runs with different HNSW index query parameters,',
        () {
          late List<ObjectWithVector> smallEfSearchResults;
          late List<ObjectWithVector> largeEfSearchResults;
          late List<ObjectWithVector> relaxedIterativeScanResults;
          late List<ObjectWithVector> strictIterativeScanResults;

          /// Runs a vector query with the given efSearch and iterativeScan
          /// parameters. Sequential scan is disabled to ensure that the queries
          /// only use the HNSW index and are affected by the efSearch parameter.
          Future<List<ObjectWithVector>> runVectorQuery({
            required int efSearch,
            required IterativeScan iterativeScan,
          }) async {
            return session.db.transaction((transaction) async {
              await transaction.setRuntimeParameters(
                (params) => [
                  params.vectorIndexQuery(enableSeqScan: false),
                  params.hnswIndexQuery(
                    efSearch: efSearch,
                    iterativeScan: iterativeScan,
                  ),
                ],
              );

              return ObjectWithVector.db.find(
                session,
                orderBy: (t) => t.vectorIndexedHnsw.distanceL2(queryVector),
                limit: resultLimit,
                transaction: transaction,
              );
            });
          }

          setUpAll(() async {
            smallEfSearchResults = await runVectorQuery(
              efSearch: smallEfSearch,
              iterativeScan: IterativeScan.off,
            );

            largeEfSearchResults = await runVectorQuery(
              efSearch: largeEfSearch,
              iterativeScan: IterativeScan.off,
            );

            relaxedIterativeScanResults = await runVectorQuery(
              efSearch: smallEfSearch,
              iterativeScan: IterativeScan.relaxed,
            );

            strictIterativeScanResults = await runVectorQuery(
              efSearch: smallEfSearch,
              iterativeScan: IterativeScan.strict,
            );
          });

          test(
            'then a small efSearch returns no more vectors than its candidate list size.',
            () {
              expect(smallEfSearchResults, hasLength(smallEfSearch));
            },
          );

          test(
            'then a large efSearch returns as many vectors as the query limit.',
            () {
              expect(largeEfSearchResults, hasLength(resultLimit));
            },
          );

          test(
            'then a relaxed iterative scan lifts the small efSearch cap on returned vectors.',
            () {
              expect(relaxedIterativeScanResults, hasLength(resultLimit));
            },
          );

          test(
            'then a strict iterative scan lifts the small efSearch cap on returned vectors.',
            () {
              expect(strictIterativeScanResults, hasLength(resultLimit));
            },
          );

          test(
            'then a small efSearch and a large efSearch find mostly different vectors.',
            () {
              var smallEfSearchIds = smallEfSearchResults
                  .map((v) => v.id)
                  .toSet();
              var largeEfSearchIds = largeEfSearchResults
                  .map((v) => v.id)
                  .toSet();

              var intersection = smallEfSearchIds.intersection(
                largeEfSearchIds,
              );
              var unionSize = smallEfSearchIds.union(largeEfSearchIds).length;
              var intersectionRatio = intersection.length / unionSize;

              printOnFailure('Small efSearch IDs: $smallEfSearchIds');
              printOnFailure('Large efSearch IDs: $largeEfSearchIds');
              printOnFailure('Intersection ratio: $intersectionRatio');

              // The small efSearch scan returns at most [smallEfSearch] rows,
              // so it can never overlap more than that fraction of the
              // [resultLimit] rows the large efSearch scan returns.
              expect(
                intersectionRatio,
                lessThanOrEqualTo(smallEfSearch / resultLimit),
              );
            },
          );

          test(
            'then a large efSearch finds vectors at least as close to the query vector at every rank.',
            () {
              // A larger dynamic candidate list visits a superset of the nodes
              // visited by a smaller one, so its result at any given rank can
              // never be farther away from the query vector.
              var smallEfSearchDistances = smallEfSearchResults
                  .map((v) => l2(v.vectorIndexedHnsw, queryVector))
                  .toList();
              var largeEfSearchDistances = largeEfSearchResults
                  .map((v) => l2(v.vectorIndexedHnsw, queryVector))
                  .toList();

              printOnFailure(
                'Small efSearch distances: $smallEfSearchDistances',
              );
              printOnFailure(
                'Large efSearch distances: $largeEfSearchDistances',
              );

              for (var rank = 0; rank < smallEfSearchDistances.length; rank++) {
                expect(
                  largeEfSearchDistances[rank],
                  lessThanOrEqualTo(smallEfSearchDistances[rank]),
                  reason: 'Rank $rank should not be farther from the query.',
                );
              }
            },
          );
        },
      );
    },
  );
}

/// Helper function to generate test vectors with very similar distances.
Vector generateTestVector(int i, {required math.Random random}) {
  var baseVector = List<double>.filled(vectorDimension, 0.0);

  // Create vectors clustered around distance 0.5 from query point with very
  // small random variations to create borderline cases.
  var angle = (i * 2 * math.pi) / totalVectors;
  var radiusVariation = 0.01 * nextGaussian(random);
  var baseRadius = 0.5 + radiusVariation;

  // Place vectors in a spiral pattern with small random noise.
  baseVector[0] =
      0.5 + baseRadius * math.cos(angle) + 0.005 * nextGaussian(random);
  baseVector[1] =
      0.5 + baseRadius * math.sin(angle) + 0.005 * nextGaussian(random);

  // Add noise to other dimensions to increase complexity.
  for (int j = 2; j < (vectorDimension ~/ 10 - 1); j++) {
    baseVector[j] = 0.002 * nextGaussian(random);
  }

  return Vector(baseVector);
}

/// Helper for normal (Gaussian) distributed random numbers.
double nextGaussian(math.Random rng) {
  double u1 = rng.nextDouble();
  double u2 = rng.nextDouble();
  return math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
}

/// Calculates the L2 distance between two vectors.
double l2(Vector a, Vector b) {
  final aList = a.toList();
  final bList = b.toList();
  double sum = 0.0;
  for (int i = 0; i < aList.length; i++) {
    final d = aList[i] - bList[i];
    sum += d * d;
  }
  return math.sqrt(sum);
}
