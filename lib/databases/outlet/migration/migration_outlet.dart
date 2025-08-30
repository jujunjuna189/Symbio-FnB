class MigrationOutlet {
  // Schema product
  static const String tbl = "outlet";
  static const String id = "id";
  static const String name = "name";
  static const String phone = "phone";
  static const String address = "address";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static String get init =>
      '''
      CREATE TABLE $tbl(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $name TEXT,
        $phone TEXT,
        $address TEXT,
        $createdAt TEXT,
        $updatedAt TEXT
      )
    ''';
}
