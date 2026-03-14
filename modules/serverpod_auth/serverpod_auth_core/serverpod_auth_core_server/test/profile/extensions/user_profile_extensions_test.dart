import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/profile/extensions/user_profile_extensions.dart';
import 'package:test/test.dart';

const uuid = Uuid();

void main() {
  group('UserProfileMerge', () {
    test(
      'given a target profile with null fields, when merging with a source profile having values, then the fields are populated.',
      () {
        final target = UserProfile(
          authUserId: uuid.v4obj(),
          // All other fields null
        );

        final source = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'source_user',
          fullName: 'Source Name',
          email: 'source@example.com',
          imageId: uuid.v4obj(),
        );

        final result = target.merge(source);

        expect(result.userName, 'source_user');
        expect(result.fullName, 'Source Name');
        expect(result.email, 'source@example.com');
        expect(result.imageId, source.imageId);
      },
    );

    test(
      'given a target profile with empty string fields, when merging with a source profile having values, then the fields are populated.',
      () {
        final target = UserProfile(
          authUserId: uuid.v4obj(),
          userName: '',
          fullName: '',
          email: '',
        );

        final source = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'source_user',
          fullName: 'Source Name',
          email: 'source@example.com',
        );

        final result = target.merge(source);

        expect(result.userName, 'source_user');
        expect(result.fullName, 'Source Name');
        expect(result.email, 'source@example.com');
      },
    );

    test(
      'given a target profile with populated fields, when merging with a source profile, then the target fields are preserved.',
      () {
        final imageId = uuid.v4obj();
        final target = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'target_user',
          fullName: 'Target Name',
          email: 'target@example.com',
          imageId: imageId,
        );

        final source = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'source_user',
          fullName: 'Source Name',
          email: 'source@example.com',
          imageId: uuid.v4obj(),
        );

        final result = target.merge(source);

        expect(result.userName, 'target_user');
        expect(result.fullName, 'Target Name');
        expect(result.email, 'target@example.com');
        expect(result.imageId, imageId);
      },
    );

    test(
      'given a target profile with some fields populated and others null/empty, when merging, then only missing fields are filled.',
      () {
        final target = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'target_user',
          fullName: '', // Empty -> should fill
          email: null, // Null -> should fill
          imageId: null, // Null -> should fill
        );

        final sourceImageId = uuid.v4obj();
        final source = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'source_user',
          fullName: 'Source Name',
          email: 'source@example.com',
          imageId: sourceImageId,
        );

        final result = target.merge(source);

        expect(result.userName, 'target_user'); // Preserved
        expect(result.fullName, 'Source Name'); // Filled
        expect(result.email, 'source@example.com'); // Filled
        expect(result.imageId, sourceImageId); // Filled
      },
    );

    test(
      'given a source profile with null/empty fields, when merging, then target fields are not overwritten with null/empty.',
      () {
        final imageId = uuid.v4obj();
        final target = UserProfile(
          authUserId: uuid.v4obj(),
          userName: 'target_user',
          fullName: 'Target Name',
          email: 'target@example.com',
          imageId: imageId,
        );

        final source = UserProfile(
          authUserId: uuid.v4obj(),
          userName: '',
          fullName: null,
          email: '',
          imageId: null,
        );

        final result = target.merge(source);

        expect(result.userName, 'target_user');
        expect(result.fullName, 'Target Name');
        expect(result.email, 'target@example.com');
        expect(result.imageId, imageId);
      },
    );
  });
}
