import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pos_simple_v2/databases/order/model/model_order.dart';
import 'package:pos_simple_v2/databases/order/repository/repository_order.dart';
import 'package:pos_simple_v2/databases/order/repository/repository_order_product.dart';
import 'package:pos_simple_v2/pages/order/state/state_order.dart';

class BlocOrder extends Cubit<StateOrder> {
  BlocOrder() : super(OrderInitial());

  void initialPage() {
    emit(OrderLoaded());
    onGetOrder();
  }

  void onGetOrder() async {
    final currentState = state as OrderLoaded;
    final List<ModelOrder> orders = [];

    await RepositoryOrder.instance
        .get(orderBy: "id desc")
        .then((res) async {
          orders.addAll(res.map((res) => ModelOrder.fromMap(res)).toList());

          emit(currentState.copyWith(orders: orders));
        })
        .catchError((res) {
          print(res);
        });
  }

  Future<void> onDeleteOrder({required int id}) async {
    EasyLoading.show();
    await RepositoryOrder.instance.delete(where: "id = $id").then((res) async {
      await RepositoryOrderProduct.instance.delete(where: "order_id = $id").then((res) {
        EasyLoading.dismiss();
        onGetOrder();
      });
    });
  }

  @override
  void onChange(Change<StateOrder> change) {
    super.onChange(change);
  }
}
