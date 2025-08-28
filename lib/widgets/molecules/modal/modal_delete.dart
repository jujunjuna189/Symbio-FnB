import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class ModalDelete {
  ModalDelete._privateConstructor();
  static final ModalDelete instance = ModalDelete._privateConstructor();

  void show(BuildContext context, {required String title, required String description, required Function onSubmit}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModalDeleteContent(title: title, description: description, onSubmit: onSubmit),
    );
  }
}

class ModalDeleteContent extends StatelessWidget {
  final String title;
  final String description;
  final Function onSubmit;
  const ModalDeleteContent({super.key, required this.title, required this.description, required this.onSubmit});

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
                  Text(title, style: ThemeApp.font.bold.copyWith(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(description, style: ThemeApp.font.regular),
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
                        onTap: () {
                          onSubmit();
                          Navigator.of(context).pop();
                        },
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
                              Text("Hapus", style: ThemeApp.font.semiBold.copyWith(fontSize: 13)),
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
