import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_simple_v2/pages/cart/bloc/bloc_cart.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class ModalCancel {
  ModalCancel._privateConstructor();
  static final ModalCancel instance = ModalCancel._privateConstructor();

  void show(BuildContext context, {required BlocCart blocCart}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModalCancelContent(blocCart: blocCart),
    );
  }
}

class ModalCancelContent extends StatelessWidget {
  final BlocCart blocCart;
  const ModalCancelContent({super.key, required this.blocCart});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Material(
            color: ThemeApp.color.transparent,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Apakah yakin ingin membatalkan transaksi ini?",
                    style: ThemeApp.font.bold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Jika transaksi dibatalkan, keranjang akan dikosongkan dan akan memulai dari awal?",
                    style: ThemeApp.font.regular,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.only(right: 15, left: 5, top: 7, bottom: 7),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: ThemeApp.color.danger.withOpacity(0.05),
                            border: Border.all(width: 1, color: ThemeApp.color.danger.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close, size: 20, color: ThemeApp.color.danger),
                              const SizedBox(width: 5),
                              Text(
                                "Kembali",
                                style: ThemeApp.font.semiBold.copyWith(fontSize: 13, color: ThemeApp.color.danger),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {blocCart.onReset(context), Navigator.of(context).pop()},
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
                              const Icon(Icons.check, size: 20),
                              const SizedBox(width: 5),
                              Text("Yakin", style: ThemeApp.font.semiBold.copyWith(fontSize: 13)),
                            ],
                          ),
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
