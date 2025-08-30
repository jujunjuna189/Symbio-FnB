import 'package:pos_simple_v2/databases/cart/migration/migration_cart.dart';
import 'package:pos_simple_v2/databases/order/migration/migration_order.dart';
import 'package:pos_simple_v2/databases/order/migration/migration_order_product.dart';
import 'package:pos_simple_v2/databases/outlet/migration/migration_outlet.dart';
import 'package:pos_simple_v2/databases/product/migration/migration_product.dart';
import 'package:pos_simple_v2/databases/user/migration/migration_user.dart';
import 'package:pos_simple_v2/helpers/path/app_path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInitial {
  DatabaseInitial._privateConstructor();
  static final DatabaseInitial instance = DatabaseInitial._privateConstructor();

  static const String dbName = "simbio_fnb.db";
  static const int dbVersion = 1;

  static Database? database;
  Future<Database> get getDatabase async => database ??= await initialDatabase();

  Future<Database> initialDatabase() async {
    final path = await AppPath.instance.mainDirectoryDb(dbName);
    return openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    Batch batch = db.batch();

    // Create table user
    batch.execute(MigrationUser.init);

    // Create table outlet
    batch.execute(MigrationOutlet.init);

    // Create table product
    batch.execute(MigrationProduct.init);

    // Create table cart
    batch.execute(MigrationCart.init);

    // Create table order
    batch.execute(MigrationOrder.init);

    // Create table order product
    batch.execute(MigrationOrderProduct.init);

    await batch.commit();
  }
}
