import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pos_simple_v2/databases/cart/model/model_cart.dart';
import 'package:pos_simple_v2/databases/cart/repository/repository_cart.dart';
import 'package:pos_simple_v2/databases/order/model/model_order.dart';
import 'package:pos_simple_v2/databases/order/model/model_order_product.dart';
import 'package:pos_simple_v2/databases/order/repository/repository_order.dart';
import 'package:pos_simple_v2/databases/order/repository/repository_order_product.dart';
import 'package:pos_simple_v2/databases/product/migration/migration_product.dart';
import 'package:pos_simple_v2/databases/product/model/model_product.dart';
import 'package:pos_simple_v2/databases/product/repository/repository_product.dart';
import 'package:pos_simple_v2/helpers/code/order_code.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:pos_simple_v2/helpers/invoice/invoice_pdf_order.dart';
import 'package:pos_simple_v2/pages/cart/state/state_cart.dart';
import 'package:pos_simple_v2/routes/route_name.dart';

class BlocCart extends Cubit<StateCart> {
  BlocCart() : super(CartInitial());

  void initialPage() {
    emit(CartLoaded(status: "Belum Lunas"));
    onGetCart();
  }

  // general function
  Future<String> getNumberOrder() async {
    String number = "";
    await RepositoryOrder.instance.get(orderBy: "id DESC", limit: 1).then((res) {
      if (res.isNotEmpty &&
          DateFormatter.instance.dateV2(res.first["created_at"]) ==
              DateFormatter.instance.dateV2(DateFormatter.instance.dateNowV2Formatter())) {
        number = OrderCode.instance.generate(
          (int.tryParse(OrderCode.instance.getLastCharacters(input: res.first["number"], lastDigit: 4)) ?? 1) + 1,
        );
      } else {
        number = OrderCode.instance.generate(1);
      }
    });

    return number;
  }

  void onGetCart({where, int page = 1}) async {
    final currentState = state as CartLoaded;
    final List<ModelCart> carts = [];

    await RepositoryCart.instance
        .get(where: where)
        .then((res) async {
          carts.addAll(res.map((res) => ModelCart.fromMap(res)).toList());

          // get product
          for (var item in carts) {
            await getProduct(where: "${MigrationProduct.id}=${item.productId}").then((res) {
              item.modelProduct = res != null && res.isNotEmpty ? ModelProduct.fromMap(res.first.toMap()) : null;
            });
          }

          String orderNumber = await getNumberOrder();
          Map<String, dynamic> summary = onGetSummary(carts: carts);
          emit(currentState.copyWith(carts: carts, orderNumber: orderNumber, summary: summary));
        })
        .catchError((res) {
          print(res);
        });
  }

  Future<List<ModelProduct>?> getProduct({where, limit}) async {
    final List<ModelProduct> products = [];
    await RepositoryProduct.instance
        .get(where: where, limit: limit)
        .then((res) async {
          products.addAll(res.map((res) => ModelProduct.fromMap(res)).toList());
        })
        .catchError((res) {
          print("product $res");
        });

    return products.isNotEmpty ? products : null;
  }

  void manageCart({datas}) async {
    await RepositoryCart.instance
        .deletes()
        .then((res) async {
          if (datas.length > 0) await RepositoryCart.instance.adds(datas);
        })
        .catchError((error) {
          print(error);
        });
  }

  void deleteCart({id}) async {
    final currentState = state as CartLoaded;
    await RepositoryCart.instance.delete(where: "id = $id").then((res) {
      currentState.carts.removeAt(currentState.carts.indexWhere((x) => x.id == id));

      Map<String, dynamic> summary = onGetSummary(carts: currentState.carts);
      emit(currentState.copyWith(carts: currentState.carts, summary: summary));
    });
  }

  void onPlusQuantity(index) {
    final currentState = state as CartLoaded;

    double quantity = double.parse((currentState.carts[index].quantity + 0.1).toStringAsFixed(1));

    ModelCart modelCart = ModelCart(
      id: currentState.carts[index].id,
      productId: currentState.carts[index].modelProduct?.id ?? 0,
      modelProduct: currentState.carts[index].modelProduct,
      price: currentState.carts[index].price,
      quantity: quantity,
      subTotal: currentState.carts[index].price * quantity,
      createdAt: currentState.carts[index].createdAt,
      updatedAt: currentState.carts[index].updatedAt,
    );
    currentState.carts[index] = modelCart;
    manageCart(datas: currentState.carts);
    Map<String, dynamic> summary = onGetSummary(carts: currentState.carts);
    emit(currentState.copyWith(carts: currentState.carts, summary: summary));
  }

  void onMinQuantity(index) {
    final currentState = state as CartLoaded;

    double quantity = double.parse((currentState.carts[index].quantity - 0.1).toStringAsFixed(1));

    if (quantity <= 0.0) {
      deleteCart(id: currentState.carts[index].id);
      return;
    }

    ModelCart modelCart = ModelCart(
      id: currentState.carts[index].id,
      productId: currentState.carts[index].modelProduct?.id ?? 0,
      modelProduct: currentState.carts[index].modelProduct,
      price: currentState.carts[index].price,
      quantity: quantity,
      subTotal: currentState.carts[index].price * quantity,
      createdAt: currentState.carts[index].createdAt,
      updatedAt: currentState.carts[index].updatedAt,
    );
    currentState.carts[index] = modelCart;
    manageCart(datas: currentState.carts);
    Map<String, dynamic> summary = onGetSummary(carts: currentState.carts);
    emit(currentState.copyWith(carts: currentState.carts, summary: summary));
  }

  // Summary
  Map<String, dynamic> onGetSummary({List<ModelCart>? carts}) {
    if (carts == null) return {};
    Map<String, dynamic> summary = {};
    for (ModelCart item in carts) {
      summary = {
        ...summary,
        "sub_total": (summary["sub_total"] ?? 0) + item.subTotal,
        "total": (summary["total"] ?? 0) + item.subTotal,
      };
    }

    return summary;
  }

  void onUpdateSumary({double amount = 0}) {
    final currentState = state as CartLoaded;

    String status = amount >= (currentState.summary['total'] ?? 0) ? "Lunas" : "Belum Lunas";

    double cashBack = (currentState.summary['total'] ?? 0) - amount;
    cashBack = cashBack < 0 ? cashBack : 0;

    Map<String, dynamic> summary = {
      ...onGetSummary(carts: currentState.carts),
      "payment": amount,
      "cash_back": cashBack.abs(),
    };

    emit(currentState.copyWith(status: status, summary: summary));
  }

  void onPay(BuildContext context) async {
    final currentState = state as CartLoaded;
    await RepositoryOrder.instance
        .add(
          ModelOrder(
            userId: 0,
            number: currentState.orderNumber,
            subTotal: currentState.summary["sub_total"],
            total: currentState.summary["total"],
            paid: currentState.summary["payment"],
            change: currentState.summary["cash_back"],
            status: currentState.status ?? 'Belum Lunas',
          ),
        )
        .then((res) async {
          for (var item in currentState.carts) {
            await RepositoryOrderProduct.instance.add(
              ModelOrderProduct(
                orderId: res,
                productId: item.productId,
                sku: item.modelProduct?.sku ?? '',
                image: item.modelProduct?.image ?? '',
                name: item.modelProduct?.name ?? '',
                expired: "",
                unit: item.modelProduct?.unit ?? '',
                description: item.modelProduct?.description ?? '',
                price: item.price,
                quantity: item.quantity,
                subTotal: item.subTotal,
              ),
            );
          }

          if (context.mounted) Navigator.of(context).pop(true);
        });
  }

  void printStruct(BuildContext context) async {
    EasyLoading.show();
    final currentState = state as CartLoaded;

    final List<ModelOrder> orders = [];

    await RepositoryOrder.instance
        .get(where: "number='${currentState.orderNumber}'")
        .then((res) async {
          orders.addAll(res.map((res) => ModelOrder.fromMap(res)).toList());
          final List<ModelOrderProduct> products = [];

          await RepositoryOrderProduct.instance.get(where: "order_id=${orders.first.id}").then((res) async {
            products.addAll(res.map((res) => ModelOrderProduct.fromMap(res)).toList());
            if (context.mounted) {
              InvoicePdfOrder.instance.generate(context, order: orders.first, products: products).then((res) {
                Future.delayed(const Duration(seconds: 2), () {
                  EasyLoading.dismiss();
                  if (context.mounted) {
                    manageCart(datas: []);
                    emit(currentState.reset());
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pushNamed(RouteName.PDF_VIEWER, arguments: jsonEncode({"path": res}));
                  }
                });
              });
            }
          });
        })
        .catchError((res) {
          print(res);
        });
  }

  void onReset(BuildContext context) async {
    final currentState = state as CartLoaded;
    manageCart(datas: []);
    emit(currentState.reset());
    Navigator.of(context).pop();
  }

  @override
  void onChange(Change<StateCart> change) {
    super.onChange(change);
  }
}
