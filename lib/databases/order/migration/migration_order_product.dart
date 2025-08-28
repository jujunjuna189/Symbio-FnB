class MigrationOrderProduct {
  // Schema order product
  static const String tbl = "order_product";
  static const String id = "id";
  static const String orderId = "order_id";
  static const String productId = "product_id";
  static const String sku = "sku";
  static const String image = "image";
  static const String name = "name";
  static const String unit = "unit";
  static const String price = "price";
  static const String description = "description";
  static const String expired = "expired";
  static const String quantity = "quantity";
  static const String subTotal = "sub_total";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static String get init =>
      '''
      CREATE TABLE $tbl(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $orderId INTEGER,
        $productId INTEGER,
        $sku TEXT,
        $image TEXT,
        $name TEXT,
        $unit TEXT,
        $price DOUBLE,
        $description TEXT,
        $expired TEXT,
        $quantity DOUBLE,
        $subTotal DOUBLE,
        $createdAt TEXT,
        $updatedAt TEXT
      )
    ''';
}
