class MigrationCart {
  // Schema product
  static const String tbl = "cart";
  static const String id = "id";
  static const String productId = "product_id";
  static const String price = "price";
  static const String quantity = "quantity";
  static const String subTotal = "sub_total";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static String get init =>
      '''
      CREATE TABLE $tbl(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $productId INTEGER,
        $price DOUBLE,
        $quantity DOUBLE,
        $subTotal DOUBLE,
        $createdAt TEXT,
        $updatedAt TEXT
      )
    ''';
}
