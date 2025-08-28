import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/databases/order/migration/migration_order_product.dart';
import 'package:pos_simple_v2/databases/order/model/model_order_product.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryOrderProduct {
  RepositoryOrderProduct._privateConstructor();
  static final RepositoryOrderProduct instance = RepositoryOrderProduct._privateConstructor();

  Future<List> get({columns, where, limit, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var orderProduct = await db.query(
      MigrationOrderProduct.tbl,
      columns: columns,
      where: where,
      limit: limit,
      groupBy: groupBy,
    );
    return orderProduct;
  }

  Future<int> add(ModelOrderProduct values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.insert(MigrationOrderProduct.tbl, {
      MigrationOrderProduct.id: null,
      MigrationOrderProduct.orderId: values.orderId,
      MigrationOrderProduct.productId: values.productId,
      MigrationOrderProduct.sku: values.sku,
      MigrationOrderProduct.image: values.image,
      MigrationOrderProduct.name: values.name,
      MigrationOrderProduct.price: values.price,
      MigrationOrderProduct.unit: values.unit,
      MigrationOrderProduct.description: values.description,
      MigrationOrderProduct.expired: values.expired,
      MigrationOrderProduct.quantity: values.quantity,
      MigrationOrderProduct.subTotal: values.subTotal,
      MigrationOrderProduct.createdAt: values.createdAt ?? DateFormatter.instance.dateNowFormatter(),
      MigrationOrderProduct.updatedAt: values.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
    });
  }

  Future<int> delete({where}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationOrderProduct.tbl, where: where);
  }
}
