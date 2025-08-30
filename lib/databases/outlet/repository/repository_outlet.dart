import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/databases/outlet/migration/migration_outlet.dart';
import 'package:pos_simple_v2/databases/outlet/model/model_outlet.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryOutlet {
  RepositoryOutlet._privateConstructor();
  static final RepositoryOutlet instance = RepositoryOutlet._privateConstructor();

  Future<List> get({columns, where, limit, offset, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var product = await db.query(
      MigrationOutlet.tbl,
      columns: columns,
      where: where,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
    return product;
  }

  Future<int> add(ModelOutlet values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.insert(MigrationOutlet.tbl, {
      MigrationOutlet.id: null,
      MigrationOutlet.name: values.name,
      MigrationOutlet.phone: values.phone,
      MigrationOutlet.address: values.address,
      MigrationOutlet.createdAt: values.createdAt ?? DateFormatter.instance.dateNowFormatter(),
      MigrationOutlet.updatedAt: values.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
    });
  }

  Future<int> update(ModelOutlet values) async {
    final Database db = await DatabaseInitial.instance.getDatabase;

    // Buat map kosong untuk menampung data yang akan diupdate
    final Map<String, dynamic> updateData = {};

    updateData[MigrationOutlet.name] = values.name;
    updateData[MigrationOutlet.phone] = values.phone;
    updateData[MigrationOutlet.address] = values.address;

    // Updated at akan selalu diperbarui walaupun kolom lain null
    updateData[MigrationOutlet.updatedAt] = values.updatedAt ?? DateFormatter.instance.dateNowFormatter();

    // Jika tidak ada data yang diupdate, hentikan proses
    if (updateData.isEmpty) return 0;

    return await db.update(MigrationOutlet.tbl, updateData, where: "${MigrationOutlet.id} = ?", whereArgs: [values.id]);
  }

  Future<int> delete({where}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationOutlet.tbl, where: where);
  }
}
