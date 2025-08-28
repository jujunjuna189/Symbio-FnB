import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/databases/order/migration/migration_order.dart';
import 'package:pos_simple_v2/databases/order/model/model_order.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryOrder {
  RepositoryOrder._privateConstructor();
  static final RepositoryOrder instance = RepositoryOrder._privateConstructor();

  Future<List> get({columns, where, orderBy, limit, groupBy}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var order = await db.query(
      MigrationOrder.tbl,
      columns: columns,
      where: where,
      orderBy: orderBy,
      limit: limit,
      groupBy: groupBy,
    );
    return order;
  }

  // for summary
  Future<List> getToday() async {
    Database db = await DatabaseInitial.instance.getDatabase;
    var order = await db.query(
      MigrationOrder.tbl,
      where: "${MigrationOrder.createdAt} > '${DateFormatter.instance.dateNowV2Formatter()} 00:00:00'",
    );
    return order;
  }

  Future<int> add(ModelOrder values) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.insert(MigrationOrder.tbl, {
      MigrationOrder.id: null,
      MigrationOrder.userId: values.userId,
      MigrationOrder.number: values.number,
      MigrationOrder.subTotal: values.subTotal,
      MigrationOrder.total: values.total,
      MigrationOrder.paid: values.paid,
      MigrationOrder.change: values.change,
      MigrationOrder.status: values.status,
      MigrationOrder.createdAt: values.createdAt ?? DateFormatter.instance.dateNowFormatter(),
      MigrationOrder.updatedAt: values.updatedAt ?? DateFormatter.instance.dateNowFormatter(),
    });
  }

  Future<int> delete({where}) async {
    Database db = await DatabaseInitial.instance.getDatabase;
    return await db.delete(MigrationOrder.tbl, where: where);
  }
}
