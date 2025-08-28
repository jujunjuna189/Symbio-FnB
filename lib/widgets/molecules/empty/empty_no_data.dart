import 'package:flutter/material.dart';
import 'package:pos_simple_v2/utils/asset/asset.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class EmptyNoData extends StatelessWidget {
  const EmptyNoData({super.key, this.title = "Tidak ada data", this.description = "Tidak ada data yang ditampilkan"});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(opacity: 0.5, child: Image.asset(Asset.icNoData, width: 140)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(title, textAlign: TextAlign.center, style: ThemeApp.font.semiBold.copyWith(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(description, textAlign: TextAlign.center, style: ThemeApp.font.regular.copyWith(fontSize: 14)),
        ),
      ],
    );
  }
}
