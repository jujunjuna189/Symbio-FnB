import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/databases/product/migration/migration_product.dart';
import 'package:pos_simple_v2/databases/product/model/model_product.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryProduct {
  RepositoryProduct._privateConstructor();
  static final RepositoryProduct instance = RepositoryProduct._privateConstructor();

  Future<List> get({columns, where, limit, offset, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var product = await db.query(
      MigrationProduct.tbl,
      columns: columns,
      where: where,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
    return product;
  }

  Future<int> totalPages({int pageSize = 10, where, limit, offset, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var product = await db.rawQuery('SELECT COUNT(*) as count FROM ${MigrationProduct.tbl}');
    return ((product.first['count'] as int) / pageSize).ceil();
  }

  Future<int> add(ModelProduct values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.insert(MigrationProduct.tbl, {
      MigrationProduct.id: null,
      MigrationProduct.sku: values.sku,
      MigrationProduct.image: values.image,
      MigrationProduct.name: values.name,
      MigrationProduct.unit: values.unit,
      MigrationProduct.price: values.price,
      MigrationProduct.description: values.description,
      MigrationProduct.createdAt: values.createdAt ?? DateFormatter.instance.dateNowFormatter(),
      MigrationProduct.updatedAt: values.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
    });
  }

  Future<int> update(ModelProduct values) async {
    final Database db = await DatabaseInitial.instance.getDatabase;

    // Buat map kosong untuk menampung data yang akan diupdate
    final Map<String, dynamic> updateData = {};

    if (values.sku != null) updateData[MigrationProduct.sku] = values.sku;
    if (values.image != null) updateData[MigrationProduct.image] = values.image;
    updateData[MigrationProduct.name] = values.name;
    updateData[MigrationProduct.unit] = values.unit;
    updateData[MigrationProduct.price] = values.price;
    if (values.description != null) {
      updateData[MigrationProduct.description] = values.description;
    }

    // Updated at akan selalu diperbarui walaupun kolom lain null
    updateData[MigrationProduct.updatedAt] = values.updatedAt ?? DateFormatter.instance.dateNowFormatter();

    // Jika tidak ada data yang diupdate, hentikan proses
    if (updateData.isEmpty) return 0;

    return await db.update(
      MigrationProduct.tbl,
      updateData,
      where: "${MigrationProduct.id} = ?",
      whereArgs: [values.id],
    );
  }

  Future<int> delete({where}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationProduct.tbl, where: where);
  }
}
