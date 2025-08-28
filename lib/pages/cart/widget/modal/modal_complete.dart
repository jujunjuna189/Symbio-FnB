import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_simple_v2/pages/cart/bloc/bloc_cart.dart';
import 'package:pos_simple_v2/routes/route_name.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class ModalComplete {
  ModalComplete._privateConstructor();
  static final ModalComplete instance = ModalComplete._privateConstructor();

  void show(BuildContext context, {required BlocCart blocCart}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ModalCompleteContent(blocCart: blocCart),
    );
  }
}

class ModalCompleteContent extends StatelessWidget {
  final BlocCart blocCart;
  const ModalCompleteContent({super.key, required this.blocCart});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Material(
            color: ThemeApp.color.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: ThemeApp.color.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ThemeApp.color.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: ThemeApp.color.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(Icons.check, size: 45, color: ThemeApp.color.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Transaksi Berhasil!", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                  Text(
                    "Telah ditambahkan ke riwayat transaksi",
                    style: ThemeApp.font.regular,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => {Navigator.of(context).pop(), blocCart.onReset(context)},
                    child: Container(
                      padding: const EdgeInsets.only(right: 15, left: 5, top: 7, bottom: 7),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: ThemeApp.color.primary.withOpacity(0.2),
                        border: Border.all(width: 1, color: ThemeApp.color.primary),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, size: 20),
                          const SizedBox(width: 5),
                          Text("Transaksi Baru", style: ThemeApp.font.semiBold.copyWith(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => blocCart.printStruct(context),
                    child: Container(
                      padding: const EdgeInsets.only(right: 15, left: 5, top: 7, bottom: 7),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: ThemeApp.color.primary.withOpacity(0.05),
                        border: Border.all(width: 1, color: ThemeApp.color.primary.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.print, size: 20),
                          const SizedBox(width: 5),
                          Text("Cetak Struk", style: ThemeApp.font.semiBold.copyWith(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {
                      blocCart.onReset(context),
                      Navigator.of(context)
                        ..pop()
                        ..pushNamed(RouteName.ORDER),
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 15, left: 5, top: 7, bottom: 7),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: ThemeApp.color.primary.withOpacity(0.05),
                        border: Border.all(width: 1, color: ThemeApp.color.primary.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history, size: 20),
                          const SizedBox(width: 5),
                          Text("Lihat Riwayat", style: ThemeApp.font.semiBold.copyWith(fontSize: 13)),
                        ],
                      ),
                    ),
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
