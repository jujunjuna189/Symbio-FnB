import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pos_simple_v2/databases/cart/model/model_cart.dart';
import 'package:pos_simple_v2/databases/cart/repository/repository_cart.dart';
import 'package:pos_simple_v2/databases/product/model/model_product.dart';
import 'package:pos_simple_v2/databases/product/repository/repository_product.dart';
import 'package:pos_simple_v2/pages/product/state/state_product.dart';

class BlocProduct extends Cubit<StateProduct> {
  BlocProduct() : super(ProductInitial());

  void initialPage() {
    emit(ProductLoaded());
    onGetProduct().then((res) {
      onGetCart();
    });
  }

  Future<void> onGetProduct({where, int page = 1}) async {
    final currentState = state as ProductLoaded;
    final List<ModelProduct> products = [];

    await RepositoryProduct.instance
        .get(where: where)
        .then((res) async {
          products.addAll(res.map((res) => ModelProduct.fromMap(res)).toList());

          emit(currentState.copyWith(products: products));
        })
        .catchError((res) {
          print(res);
        });
  }

  Future<void> onAddProduct({required ModelProduct product}) async {
    await RepositoryProduct.instance.add(product).then((res) {
      onGetProduct();
    });
  }

  Future<void> onUpdateProduct({required ModelProduct product}) async {
    await RepositoryProduct.instance.update(product).then((res) {
      onGetProduct();
    });
  }

  void onGetCart({where, int page = 1}) async {
    final currentState = state as ProductLoaded;
    final List<ModelCart> carts = [];

    await RepositoryCart.instance
        .get(where: where)
        .then((res) async {
          carts.addAll(res.map((res) => ModelCart.fromMap(res)).toList());

          emit(currentState.copyWith(carts: carts));
        })
        .catchError((res) {
          print(res);
        });
  }

  Future<void> onAddCart({required ModelCart cart}) async {
    await RepositoryCart.instance.add(cart).then((res) {
      onGetCart();
    });
  }

  Future<void> onDeleteProduct({required int id}) async {
    EasyLoading.show();
    await RepositoryProduct.instance.delete(where: "id = $id").then((res) async {
      await RepositoryCart.instance.delete(where: "product_id = $id").then((res) {
        EasyLoading.dismiss();
        onGetProduct().then((res) {
          onGetCart();
        });
      });
    });
  }

  @override
  void onChange(Change<StateProduct> change) {
    super.onChange(change);
  }
}
