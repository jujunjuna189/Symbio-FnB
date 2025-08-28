import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/pages/order_detail/bloc/bloc_order_detail.dart';
import 'package:pos_simple_v2/pages/order_detail/state/state_order_detail.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/molecules/image/get_image.dart';

class PageOrderDetail extends StatelessWidget {
  const PageOrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    BlocOrderDetail blocOrderDetail = context.read<BlocOrderDetail>();
    return Scaffold(
      backgroundColor: ThemeApp.color.grey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
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
                        Text("Riwayat Pembayaran!", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                        Text(
                          "Halaman detail riwayat pembayaran atau transaksi",
                          style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  SizedBox(height: 10),
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
                              child: BlocBuilder<BlocOrderDetail, StateOrderDetail>(
                                bloc: blocOrderDetail,
                                builder: (context, state) {
                                  final currentState = state as OrderDetailLoaded;
                                  return Text(": ${currentState.order?.number ?? ''}");
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
                              child: BlocBuilder<BlocOrderDetail, StateOrderDetail>(
                                bloc: blocOrderDetail,
                                builder: (context, state) {
                                  final currentState = state as OrderDetailLoaded;
                                  return Text(
                                    ": ${DateFormatter.instance.dateV1(currentState.order?.createdAt ?? DateFormatter.instance.dateNowV2Formatter())}",
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
                              child: Text("Pembayaran"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: BlocBuilder<BlocOrderDetail, StateOrderDetail>(
                                bloc: blocOrderDetail,
                                builder: (context, state) {
                                  final currentState = state as OrderDetailLoaded;
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
                                              color: (currentState.order?.status ?? '') == "Lunas"
                                                  ? ThemeApp.color.success.withOpacity(0.7)
                                                  : ThemeApp.color.danger.withOpacity(0.7),
                                            ),
                                            child: Text(
                                              currentState.order?.status ?? '-',
                                              style: ThemeApp.font.semiBold.copyWith(
                                                color: (currentState.order?.status ?? '') == "Lunas"
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
                  BlocBuilder<BlocOrderDetail, StateOrderDetail>(
                    bloc: blocOrderDetail,
                    builder: (context, state) {
                      final currentState = state as OrderDetailLoaded;
                      return Column(
                        children: (currentState.products ?? []).asMap().entries.map((item) {
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
                                  child: item.value.image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: GetImage(path: item.value.image ?? ''),
                                        )
                                      : Container(),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.value.name, style: ThemeApp.font.semiBold.copyWith(fontSize: 14)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${PriceFormatter.instance.decimal(item.value.price, decimalDigits: 0)}/${item.value.unit}",
                                                style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    PriceFormatter.instance.decimal(
                                                      double.parse(item.value.price.toString()),
                                                      decimalDigits: 0,
                                                    ),
                                                    style: ThemeApp.font.bold.copyWith(color: Colors.blueGrey),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("x", style: ThemeApp.font.bold),
                                                  SizedBox(width: 5),
                                                  Text("${item.value.quantity}", style: ThemeApp.font.bold),
                                                  SizedBox(width: 1),
                                                  Text(
                                                    item.value.unit,
                                                    style: ThemeApp.font.regular.copyWith(
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Subtotal",
                                                style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
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
                            BlocBuilder<BlocOrderDetail, StateOrderDetail>(
                              bloc: blocOrderDetail,
                              builder: (context, state) {
                                final currentState = state as OrderDetailLoaded;
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      style: ThemeApp.font.regular.copyWith(color: ThemeApp.color.black),
                                      children: [
                                        TextSpan(
                                          text: PriceFormatter.instance.decimal(
                                            (currentState.order?.total ?? 0),
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
                    child: BlocBuilder<BlocOrderDetail, StateOrderDetail>(
                      bloc: blocOrderDetail,
                      builder: (context, state) {
                        final currentState = state as OrderDetailLoaded;
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
                                    PriceFormatter.instance.decimal((currentState.order?.paid ?? 0), decimalDigits: 0),
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
                                      (currentState.order?.change ?? 0),
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
                  Button(
                    onPress: () => blocOrderDetail.printStruct(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print, size: 20),
                        SizedBox(width: 5),
                        Text("Cetak Struk", style: ThemeApp.font.medium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
