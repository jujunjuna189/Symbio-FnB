class ModelOrderProduct {
  final int? id;
  final int orderId;
  final int productId;
  final String sku;
  final String? image;
  final String name;
  final double price;
  final String unit;
  final String? description;
  final String? expired;
  final double quantity;
  final double subTotal;
  final String? createdAt;
  final String? updatedAt;

  ModelOrderProduct({
    this.id,
    required this.orderId,
    required this.productId,
    required this.sku,
    this.image,
    required this.name,
    required this.price,
    required this.unit,
    this.description,
    this.expired,
    required this.quantity,
    required this.subTotal,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelOrderProduct.fromMap(Map<String, dynamic> map) {
    return ModelOrderProduct(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      sku: map['sku'],
      image: map['image'],
      name: map['name'],
      price: map['price'],
      unit: map['unit'] ?? '',
      description: map['description'],
      expired: map['expired'],
      quantity: map['quantity'],
      subTotal: map['sub_total'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'sku': sku,
      'image': image,
      'name': name,
      'price': price,
      'unit': unit,
      'description': description,
      'expired': expired,
      'quantity': quantity,
      'sub_total': subTotal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
