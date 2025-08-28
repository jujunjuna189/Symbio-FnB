import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/pages/cart/bloc/bloc_cart.dart';
import 'package:pos_simple_v2/pages/cart/state/state_cart.dart';
import 'package:pos_simple_v2/pages/cart/widget/modal/modal_complete.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_number.dart';

class ModalPay {
  ModalPay._privateConstructor();
  static final ModalPay instance = ModalPay._privateConstructor();

  void show(BuildContext context, BlocCart blocCart) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModalPayContent(blocCart: blocCart),
    ).then((res) {
      if (res == true) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) ModalComplete.instance.show(context, blocCart: blocCart);
        });
      }
    });
  }
}

class ModalPayContent extends StatefulWidget {
  final BlocCart blocCart;
  const ModalPayContent({super.key, required this.blocCart});

  @override
  State<ModalPayContent> createState() => _ModalPayContentState();
}

class _ModalPayContentState extends State<ModalPayContent> {
  TextEditingController controllerPay = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerPay.addListener(() {
      double amount = double.tryParse(controllerPay.text.replaceAll(".", "")) ?? 0.0;
      widget.blocCart.onUpdateSumary(amount: amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: ThemeApp.color.grey),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  children: [
                    Row(
                      children: [
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pembayaran!", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                              Text(
                                "Halaman terakhir transaksi",
                                style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                                child: Text("Nomor Invoice"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: BlocBuilder<BlocCart, StateCart>(
                                  bloc: widget.blocCart,
                                  builder: (context, state) {
                                    final currentState = state as CartLoaded;
                                    return Text(": ${currentState.orderNumber}");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: Text("Tanggal Transaksi"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: Text(": ${DateFormatter.instance.dateNowV3Formatter()}"),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: Text("Pembayaran"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: BlocBuilder<BlocCart, StateCart>(
                                  bloc: widget.blocCart,
                                  builder: (context, state) {
                                    final currentState = state as CartLoaded;
                                    return RichText(
                                      text: TextSpan(
                                        style: ThemeApp.font.regular.copyWith(color: ThemeApp.color.black),
                                        children: [
                                          TextSpan(text: ": "),
                                          WidgetSpan(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 13),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: currentState.status == "Lunas"
                                                    ? ThemeApp.color.success.withOpacity(0.7)
                                                    : ThemeApp.color.danger.withOpacity(0.7),
                                              ),
                                              child: Text(
                                                currentState.status ?? '-',
                                                style: ThemeApp.font.semiBold.copyWith(
                                                  color: currentState.status == "Lunas"
                                                      ? ThemeApp.color.black
                                                      : ThemeApp.color.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                bloc: widget.blocCart,
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
                      child: BlocBuilder<BlocCart, StateCart>(
                        bloc: widget.blocCart,
                        builder: (context, state) {
                          final currentState = state as CartLoaded;
                          return Table(
                            columnWidths: const {0: FixedColumnWidth(140), 1: FlexColumnWidth()},
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    child: Text("Bayar"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    child: Text(
                                      PriceFormatter.instance.decimal(
                                        (currentState.summary['payment'] ?? 0),
                                        decimalDigits: 0,
                                      ),
                                      textAlign: TextAlign.end,
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
                                    child: Text(
                                      PriceFormatter.instance.decimal(
                                        (currentState.summary['cash_back'] ?? 0),
                                        decimalDigits: 0,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: ThemeApp.color.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Masukan Nominal!", style: ThemeApp.font.bold),
                    SizedBox(height: 5),
                    FieldNumber(autoFocus: true, controller: controllerPay),
                    SizedBox(height: 20),
                    Button(
                      onPress: () => widget.blocCart.onPay(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payments, size: 20),
                          SizedBox(width: 5),
                          Text("Tunai", style: ThemeApp.font.medium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
