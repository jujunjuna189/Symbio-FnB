import 'package:pos_simple_v2/databases/product/model/model_product.dart';

class ModelCart {
  final int? id;
  final int productId;
  final double price;
  final double quantity;
  final double subTotal;
  final String? createdAt;
  final String? updatedAt;
  ModelProduct? modelProduct;

  ModelCart({
    this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.subTotal,
    this.createdAt,
    this.updatedAt,
    this.modelProduct,
  });

  factory ModelCart.fromMap(Map<String, dynamic> map) {
    return ModelCart(
      id: map['id'],
      productId: map['product_id'],
      price: map['price'] ?? 0,
      quantity: map['quantity'],
      subTotal: map['sub_total'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      modelProduct: map['model_product'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'sub_total': subTotal,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'model_product': modelProduct,
    };
  }
}
