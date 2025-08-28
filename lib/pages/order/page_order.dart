import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/helpers/formatter/date_formatter.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/pages/order/bloc/bloc_order.dart';
import 'package:pos_simple_v2/pages/order/state/state_order.dart';
import 'package:pos_simple_v2/pages/order/widget/menus/menus.dart';
import 'package:pos_simple_v2/routes/route_name.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class PageOrder extends StatelessWidget {
  const PageOrder({super.key});

  @override
  Widget build(BuildContext context) {
    BlocOrder blocOrder = context.read<BlocOrder>();
    return Scaffold(
      backgroundColor: ThemeApp.color.grey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
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
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Daftar Riwayat Pembayaran!", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Halaman daftar riwayat pembayaran atau transaksi",
                          style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<BlocOrder, StateOrder>(
                bloc: blocOrder,
                builder: (context, state) {
                  final currentState = state as OrderLoaded;
                  return ListView(
                    padding: EdgeInsets.all(10),
                    children: currentState.orders.asMap().entries.map((item) {
                      return GestureDetector(
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(RouteName.ORDER_DETAIL, arguments: jsonEncode({"order_id": item.value.id})),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ThemeApp.color.white,
                            border: Border.all(width: 1, color: ThemeApp.color.secondary.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.value.number, style: ThemeApp.font.semiBold),
                                    Text(
                                      DateFormatter.instance.dateV1(item.value.createdAt.toString()),
                                      style: ThemeApp.font.regular,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    PriceFormatter.instance.decimal(item.value.paid, decimalDigits: 0),
                                    style: ThemeApp.font.semiBold,
                                  ),
                                  Text(item.value.status, style: ThemeApp.font.regular.copyWith(fontSize: 12)),
                                ],
                              ),
                              SizedBox(width: 10),
                              Menus(id: item.value.id ?? 0),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
