import 'package:pos_simple_v2/databases/cart/migration/migration_cart.dart';
import 'package:pos_simple_v2/databases/cart/model/model_cart.dart';
import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryCart {
  RepositoryCart._privateConstructor();
  static final RepositoryCart instance = RepositoryCart._privateConstructor();

  Future<List> get({columns, where, limit, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var product = await db.query(MigrationCart.tbl, columns: columns, where: where, limit: limit, groupBy: groupBy);
    return product;
  }

  Future<int> add(ModelCart values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.insert(MigrationCart.tbl, {
      MigrationCart.id: null,
      MigrationCart.productId: values.productId,
      MigrationCart.price: values.price,
      MigrationCart.quantity: values.quantity,
      MigrationCart.subTotal: values.subTotal,
      MigrationCart.createdAt: values.createdAt ?? DateFormatter.instance.dateNowFormatter(),
      MigrationCart.updatedAt: values.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
    });
  }

  Future<int> delete({where}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationCart.tbl, where: where);
  }

  // for all
  Future<void> adds(List<ModelCart> values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    Batch batch = db.batch();

    for (var item in values) {
      batch.insert(MigrationCart.tbl, {
        MigrationCart.id: item.id,
        MigrationCart.productId: item.productId,
        MigrationCart.price: item.price,
        MigrationCart.quantity: item.quantity,
        MigrationCart.subTotal: item.subTotal,
        MigrationCart.createdAt: item.createdAt ?? DateFormatter.instance.dateNowFormatter(),
        MigrationCart.updatedAt: item.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
      });
    }
    // commit
    await batch.commit(noResult: true);
  }

  Future<int> deletes() async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationCart.tbl);
  }
}
