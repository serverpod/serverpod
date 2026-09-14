import 'package:postgres/postgres.dart' as pg;

/// Opens [endpoint], runs `SELECT 1` and closes again. Returns the value, so
/// a test can assert on `1` to prove the endpoint authenticates and serves.
Future<int> selectOne(pg.Endpoint endpoint) async {
  var conn = await pg.Connection.open(
    endpoint,
    settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
  );
  try {
    var rs = await conn.execute('SELECT 1');
    return rs.first.first as int;
  } finally {
    await conn.close();
  }
}
