import 'package:pos_simple_v2/databases/cart/model/model_cart.dart';

abstract class StateCart {}

class CartInitial extends StateCart {}

class CartLoading extends StateCart {}

class CartLoaded extends StateCart {
  final List<ModelCart> carts;
  final String orderNumber;
  final String? status;
  final Map<String, dynamic> summary;

  CartLoaded({this.carts = const [], this.orderNumber = "", this.status, this.summary = const {}});

  CartLoaded copyWith({List<ModelCart>? carts, String? orderNumber, String? status, Map<String, dynamic>? summary}) {
    return CartLoaded(
      carts: carts ?? this.carts,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      summary: summary ?? this.summary,
    );
  }

  CartLoaded reset({List<ModelCart>? carts, String? orderNumber, String? status, Map<String, dynamic>? summary}) {
    return CartLoaded(carts: carts ?? [], orderNumber: orderNumber ?? "", status: status ?? "", summary: summary ?? {});
  }
}

class CartAdded extends StateCart {
  final ModelCart newCart;

  CartAdded(this.newCart);
}

class CartError extends StateCart {
  final String message;

  CartError(this.message);
}
