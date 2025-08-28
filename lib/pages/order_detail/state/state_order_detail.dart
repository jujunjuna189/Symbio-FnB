import 'package:pos_simple_v2/databases/order/model/model_order.dart';
import 'package:pos_simple_v2/databases/order/model/model_order_product.dart';

abstract class StateOrderDetail {}

class OrderDetailInitial extends StateOrderDetail {}

class OrderDetailLoading extends StateOrderDetail {}

class OrderDetailLoaded extends StateOrderDetail {
  final int? orderId;
  final ModelOrder? order;
  final List<ModelOrderProduct>? products;

  OrderDetailLoaded({this.orderId, this.order, this.products});

  OrderDetailLoaded copyWith({int? orderId, ModelOrder? order, List<ModelOrderProduct>? products}) {
    return OrderDetailLoaded(
      orderId: orderId ?? this.orderId,
      order: order ?? this.order,
      products: products ?? this.products,
    );
  }
}

class OrderDetailAdded extends StateOrderDetail {
  final ModelOrder newOrder;

  OrderDetailAdded(this.newOrder);
}

class OrderDetailError extends StateOrderDetail {
  final String message;

  OrderDetailError(this.message);
}
