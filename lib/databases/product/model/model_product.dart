class ModelProduct {
  final int? id;
  final String? sku;
  final String? image;
  final String name;
  final String unit;
  final double price;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  ModelProduct({
    this.id,
    this.sku,
    this.image,
    required this.name,
    required this.unit,
    required this.price,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelProduct.fromMap(Map<String, dynamic> map) {
    return ModelProduct(
      id: map['id'],
      sku: map['sku'],
      image: map['image'],
      name: map['name'],
      unit: map['unit'],
      price: map['price'],
      description: map['description'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'image': image,
      'name': name,
      'unit': unit,
      'price': price,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
