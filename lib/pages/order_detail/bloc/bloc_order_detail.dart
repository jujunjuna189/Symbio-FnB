import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pos_simple_v2/databases/order/model/model_order.dart';
import 'package:pos_simple_v2/databases/order/model/model_order_product.dart';
import 'package:pos_simple_v2/databases/order/repository/repository_order.dart';
import 'package:pos_simple_v2/databases/order/repository/repository_order_product.dart';
import 'package:pos_simple_v2/helpers/invoice/invoice_pdf_order.dart';
import 'package:pos_simple_v2/pages/order_detail/state/state_order_detail.dart';
import 'package:pos_simple_v2/routes/route_name.dart';

class BlocOrderDetail extends Cubit<StateOrderDetail> {
  BlocOrderDetail({this.arguments}) : super(OrderDetailInitial());

  final String? arguments;

  void initialPage() {
    emit(OrderDetailLoaded(orderId: (jsonDecode(arguments ?? ''))['order_id']));
    onGetOrder().then((res) {
      onGetProductsOrder();
    });
  }

  Future onGetOrder() async {
    final currentState = state as OrderDetailLoaded;
    final List<ModelOrder> orders = [];

    await RepositoryOrder.instance
        .get(where: "id=${currentState.orderId}")
        .then((res) async {
          orders.addAll(res.map((res) => ModelOrder.fromMap(res)).toList());

          emit(currentState.copyWith(order: orders.first));
        })
        .catchError((res) {
          print(res);
        });
  }

  void onGetProductsOrder() async {
    final currentState = state as OrderDetailLoaded;
    final List<ModelOrderProduct> products = [];

    await RepositoryOrderProduct.instance.get(where: "order_id=${currentState.orderId}").then((res) async {
      products.addAll(res.map((res) => ModelOrderProduct.fromMap(res)).toList());

      emit(currentState.copyWith(products: products));
    });
  }

  void printStruct(BuildContext context) async {
    EasyLoading.show();
    final currentState = state as OrderDetailLoaded;
    InvoicePdfOrder.instance.generate(context, order: currentState.order, products: currentState.products).then((res) {
      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
        if (context.mounted) {
          Navigator.of(context).pushNamed(RouteName.PDF_VIEWER, arguments: jsonEncode({"path": res}));
        }
      });
    });
  }

  @override
  void onChange(Change<StateOrderDetail> change) {
    super.onChange(change);
  }
}
