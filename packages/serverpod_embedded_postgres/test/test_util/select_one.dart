import 'package:postgres/postgres.dart' as pg;

/// The result of `SELECT 1` over a fresh connection to [endpoint].
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
