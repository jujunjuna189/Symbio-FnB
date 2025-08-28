class ModelOrder {
  final int? id;
  final int? userId;
  final String number;
  final double subTotal;
  final double total;
  final double paid;
  final double change;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  ModelOrder({
    this.id,
    this.userId,
    required this.number,
    required this.subTotal,
    required this.total,
    required this.paid,
    required this.change,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelOrder.fromMap(Map<String, dynamic> map) {
    return ModelOrder(
      id: map['id'],
      userId: map['user_id'],
      number: map['number'],
      subTotal: map['sub_total'],
      total: map['total'],
      paid: map['paid'],
      change: map['change'],
      status: map['status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'number': number,
      'sub_total': subTotal,
      'total': total,
      'paid': paid,
      'change': change,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
