class MigrationOrder {
  // Schema order to orders for handle conflic name
  static const String tbl = "orders";
  static const String id = "id";
  static const String userId = "user_id";
  static const String number = "number";
  static const String subTotal = "sub_total";
  static const String total = "total";
  static const String paid = "paid";
  static const String change = "change";
  static const String status = "status";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static String get init =>
      '''
      CREATE TABLE $tbl(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $userId INTEGER,
        $number TEXT,
        $subTotal DOUBLE,
        $total DOUBLE,
        $paid DOUBLE,
        $change DOUBLE,
        $status TEXT,
        $createdAt TEXT,
        $updatedAt TEXT
      )
    ''';
}
