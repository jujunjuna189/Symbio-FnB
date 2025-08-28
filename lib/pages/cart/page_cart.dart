import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/pages/cart/bloc/bloc_cart.dart';
import 'package:pos_simple_v2/pages/cart/state/state_cart.dart';
import 'package:pos_simple_v2/pages/cart/widget/modal/modal_cancel.dart';
import 'package:pos_simple_v2/pages/cart/widget/modal/modal_pay.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/molecules/image/get_image.dart';

class PageCart extends StatelessWidget {
  const PageCart({super.key});

  @override
  Widget build(BuildContext context) {
    BlocCart blocCart = context.read<BlocCart>();
    return Scaffold(
      backgroundColor: ThemeApp.color.grey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.of(context).pop(),
                    child: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: ThemeApp.color.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(Icons.chevron_left, color: ThemeApp.color.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Text("Klik kembali untuk tambah barang", style: ThemeApp.font.regular.copyWith(fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.color.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10), child: Text("No Invoice")),
                            SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                color: ThemeApp.color.primary.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: BlocBuilder<BlocCart, StateCart>(
                                bloc: blocCart,
                                builder: (context, state) {
                                  final currentState = state as CartLoaded;
                                  return Text(
                                    currentState.orderNumber,
                                    style: ThemeApp.font.semiBold.copyWith(color: ThemeApp.color.black),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<BlocCart, StateCart>(
                    bloc: blocCart,
                    builder: (context, state) {
                      if (state is CartLoaded && state.carts.isNotEmpty) {
                        return Column(
                          children: state.carts.asMap().entries.map((item) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ThemeApp.color.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: ThemeApp.color.primary.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: item.value.modelProduct?.image != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: GetImage(path: item.value.modelProduct?.image ?? ''),
                                          )
                                        : Container(),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.value.modelProduct?.name ?? '',
                                          style: ThemeApp.font.semiBold.copyWith(fontSize: 14),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${PriceFormatter.instance.decimal(double.parse((item.value.modelProduct?.price ?? '0').toString()), decimalDigits: 0)}/${item.value.modelProduct?.unit}",
                                                  style: ThemeApp.font.regular.copyWith(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  PriceFormatter.instance.decimal(
                                                    double.parse(item.value.price.toString()),
                                                    decimalDigits: 0,
                                                  ),
                                                  style: ThemeApp.font.bold.copyWith(color: Colors.blueGrey),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Subtotal",
                                                  style: ThemeApp.font.regular.copyWith(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  PriceFormatter.instance.decimal(
                                                    double.parse((item.value.price * item.value.quantity).toString()),
                                                    decimalDigits: 0,
                                                  ),
                                                  style: ThemeApp.font.bold.copyWith(color: Colors.blueGrey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () => blocCart.onMinQuantity(item.key),
                                              child: Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: ThemeApp.color.secondary),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Icon(Icons.remove, color: ThemeApp.color.secondary, size: 16),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              width: 60,
                                              padding: const EdgeInsets.symmetric(vertical: 2),
                                              decoration: BoxDecoration(
                                                color: ThemeApp.color.grey,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(item.value.quantity.toString(), style: ThemeApp.font.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () => blocCart.onPlusQuantity(item.key),
                                              child: Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: ThemeApp.color.primary,
                                                  border: Border.all(width: 1, color: ThemeApp.color.primary),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  Icons.add_rounded,
                                                  color: ThemeApp.color.secondary,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: ThemeApp.color.white),
                    child: Table(
                      columnWidths: const {0: FixedColumnWidth(140), 1: FlexColumnWidth()},
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Text("Total Pembayaran"),
                            ),
                            BlocBuilder<BlocCart, StateCart>(
                              bloc: blocCart,
                              builder: (context, state) {
                                final currentState = state as CartLoaded;
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      style: ThemeApp.font.regular.copyWith(color: ThemeApp.color.black),
                                      children: [
                                        TextSpan(
                                          text: PriceFormatter.instance.decimal(
                                            (currentState.summary['total'] ?? 0),
                                            decimalDigits: 0,
                                          ),
                                          style: ThemeApp.font.bold.copyWith(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: ThemeApp.color.white),
                    child: Table(
                      columnWidths: const {0: FixedColumnWidth(140), 1: FlexColumnWidth()},
                      children: [
                        TableRow(
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5), child: Text("Bayar")),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: BlocBuilder<BlocCart, StateCart>(
                                bloc: blocCart,
                                builder: (context, state) {
                                  final currentState = state as CartLoaded;
                                  return Text(
                                    PriceFormatter.instance.decimal(
                                      (currentState.summary['payment'] ?? 0),
                                      decimalDigits: 0,
                                    ),
                                    textAlign: TextAlign.end,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Text("Kembalian"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: BlocBuilder<BlocCart, StateCart>(
                                bloc: blocCart,
                                builder: (context, state) {
                                  final currentState = state as CartLoaded;
                                  return Text(
                                    PriceFormatter.instance.decimal(
                                      (currentState.summary['cash_back'] ?? 0),
                                      decimalDigits: 0,
                                    ),
                                    textAlign: TextAlign.end,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            BlocBuilder<BlocCart, StateCart>(
              bloc: blocCart,
              builder: (context, state) {
                final currentState = state as CartLoaded;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        onPress: currentState.carts.isNotEmpty
                            ? () => ModalCancel.instance.show(context, blocCart: blocCart)
                            : null,
                        color: ThemeApp.color.danger,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, size: 20, color: ThemeApp.color.white),
                            SizedBox(width: 5),
                            Text("Batalkan", style: ThemeApp.font.medium.copyWith(color: ThemeApp.color.white)),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Button(
                          onPress: currentState.carts.isNotEmpty
                              ? () => ModalPay.instance.show(context, blocCart)
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payments, size: 20),
                              SizedBox(width: 5),
                              Text("Bayar", style: ThemeApp.font.medium),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
