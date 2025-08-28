import 'package:pos_simple_v2/databases/order/model/model_order.dart';

abstract class StateOrder {}

class OrderInitial extends StateOrder {}

class OrderLoading extends StateOrder {}

class OrderLoaded extends StateOrder {
  final List<ModelOrder> orders;

  OrderLoaded({this.orders = const []});

  OrderLoaded copyWith({List<ModelOrder>? orders}) {
    return OrderLoaded(orders: orders ?? this.orders);
  }
}

class OrderAdded extends StateOrder {
  final ModelOrder newOrder;

  OrderAdded(this.newOrder);
}

class OrderError extends StateOrder {
  final String message;

  OrderError(this.message);
}
