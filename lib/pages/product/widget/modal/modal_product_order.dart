import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_simple_v2/databases/cart/model/model_cart.dart';
import 'package:pos_simple_v2/databases/product/model/model_product.dart';
import 'package:pos_simple_v2/pages/product/bloc/bloc_product.dart';
import 'package:pos_simple_v2/routes/route_name.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_numeric.dart';

class ModalProductOrder {
  ModalProductOrder._privateConstructor();
  static final ModalProductOrder instance = ModalProductOrder._privateConstructor();

  void show(BuildContext context, {required BlocProduct blocProduct, required ModelProduct product}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModalProductOrderContent(blocProduct: blocProduct, product: product),
    );
  }
}

class ModalProductOrderContent extends StatefulWidget {
  final BlocProduct blocProduct;
  final ModelProduct product;
  const ModalProductOrderContent({super.key, required this.blocProduct, required this.product});

  @override
  State<ModalProductOrderContent> createState() => _ModalProductOrderContentState();
}

class _ModalProductOrderContentState extends State<ModalProductOrderContent> {
  TextEditingController controllerQuantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Material(
            color: ThemeApp.color.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Pemesanan!", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                  Text(
                    "Masukan jumlah kuantitas sesuai pemesanan, jika ada perubahan harga silakan ubah harga ",
                    style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text("Masukan Kuantitas!", style: ThemeApp.font.regular),
                  FieldNumeric(suffix: Text(widget.product.unit), controller: controllerQuantity),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          onPress: () {
                            double quantity = double.parse(controllerQuantity.text.replaceAll(",", "."));
                            widget.blocProduct
                                .onAddCart(
                                  cart: ModelCart(
                                    productId: widget.product.id ?? 0,
                                    price: widget.product.price,
                                    quantity: quantity,
                                    subTotal: widget.product.price * quantity,
                                  ),
                                )
                                .then((res) {
                                  if (context.mounted) Navigator.of(context).pop();
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart, size: 20),
                              SizedBox(width: 5),
                              Text("Tambah & Pesan", style: ThemeApp.font.medium),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Button(
                        color: ThemeApp.color.black.withOpacity(0.1),
                        onPress: () {
                          double quantity = double.parse(controllerQuantity.text.replaceAll(",", "."));
                          widget.blocProduct
                              .onAddCart(
                                cart: ModelCart(
                                  productId: widget.product.id ?? 0,
                                  price: widget.product.price,
                                  quantity: quantity,
                                  subTotal: widget.product.price * quantity,
                                ),
                              )
                              .then((res) {
                                if (context.mounted) {
                                  Navigator.of(context)
                                    ..pop()
                                    ..pushNamed(RouteName.CART).then((res) {
                                      widget.blocProduct.onGetCart();
                                    });
                                }
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout_rounded, size: 20),
                            SizedBox(width: 5),
                            Text("Tambah", style: ThemeApp.font.medium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
