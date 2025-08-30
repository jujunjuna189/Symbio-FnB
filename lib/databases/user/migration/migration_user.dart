class MigrationUser {
  // Schema product
  static const String tbl = "user";
  static const String id = "id";
  static const String name = "name";
  static const String email = "email";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static String get init =>
      '''
      CREATE TABLE $tbl(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $name TEXT,
        $email TEXT,
        $createdAt TEXT,
        $updatedAt TEXT
      )
    ''';
}
