class MigrationProduct {
  // Schema product
  static const String tbl = "product";
  static const String id = "id";
  static const String sku = "sku";
  static const String image = "image";
  static const String name = "name";
  static const String unit = "unit";
  static const String price = "price";
  static const String description = "description";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static String get init =>
      '''
      CREATE TABLE $tbl(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $sku TEXT,
        $image TEXT,
        $name TEXT,
        $unit TEXT,
        $price DOUBLE,
        $description TEXT,
        $createdAt TEXT,
        $updatedAt TEXT
      )
    ''';
}
