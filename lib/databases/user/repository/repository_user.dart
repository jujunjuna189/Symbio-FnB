import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/databases/user/migration/migration_user.dart';
import 'package:pos_simple_v2/databases/user/model/model_user.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryUser {
  RepositoryUser._privateConstructor();
  static final RepositoryUser instance = RepositoryUser._privateConstructor();

  Future<List> get({columns, where, limit, offset, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var product = await db.query(
      MigrationUser.tbl,
      columns: columns,
      where: where,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
    return product;
  }

  Future<int> add(ModelUser values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.insert(MigrationUser.tbl, {
      MigrationUser.id: null,
      MigrationUser.name: values.name,
      MigrationUser.email: values.email,
      MigrationUser.createdAt: values.createdAt ?? DateFormatter.instance.dateNowFormatter(),
      MigrationUser.updatedAt: values.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
    });
  }

  Future<int> update(ModelUser values) async {
    final Database db = await DatabaseInitial.instance.getDatabase;

    // Buat map kosong untuk menampung data yang akan diupdate
    final Map<String, dynamic> updateData = {};

    updateData[MigrationUser.name] = values.name;
    updateData[MigrationUser.email] = values.email;

    // Updated at akan selalu diperbarui walaupun kolom lain null
    updateData[MigrationUser.updatedAt] = values.updatedAt ?? DateFormatter.instance.dateNowFormatter();

    // Jika tidak ada data yang diupdate, hentikan proses
    if (updateData.isEmpty) return 0;

    return await db.update(MigrationUser.tbl, updateData, where: "${MigrationUser.id} = ?", whereArgs: [values.id]);
  }

  Future<int> delete({where}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationUser.tbl, where: where);
  }
}
