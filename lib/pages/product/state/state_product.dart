import 'package:pos_simple_v2/databases/cart/model/model_cart.dart';
import 'package:pos_simple_v2/databases/outlet/model/model_outlet.dart';
import 'package:pos_simple_v2/databases/product/model/model_product.dart';

abstract class StateProduct {}

class ProductInitial extends StateProduct {}

class ProductLoading extends StateProduct {}

class ProductLoaded extends StateProduct {
  final ModelOutlet? outlet;
  final List<ModelCart> carts;
  final List<ModelProduct> products;
  final ModelProduct? product;

  ProductLoaded({this.outlet, this.carts = const [], this.products = const [], this.product});

  ProductLoaded copyWith({
    ModelOutlet? outlet,
    List<ModelCart>? carts,
    List<ModelProduct>? products,
    final ModelProduct? product,
  }) {
    return ProductLoaded(
      outlet: outlet ?? this.outlet,
      carts: carts ?? this.carts,
      products: products ?? this.products,
      product: product ?? this.product,
    );
  }
}

class ProductAdded extends StateProduct {
  final ModelProduct newProduct;

  ProductAdded(this.newProduct);
}

class ProductError extends StateProduct {
  final String message;

  ProductError(this.message);
}
