import 'package:flutter/material.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class FieldArea extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onChange;
  final Color? color;
  final EdgeInsets? padding;
  final String? placeHolder;
  final bool border;
  final Color? borderColor;
  final int maxLines;
  const FieldArea({
    Key? key,
    this.controller,
    this.onChange,
    this.color,
    this.padding,
    this.placeHolder,
    this.border = true,
    this.borderColor,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? ThemeApp.color.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(width: 1, color: borderColor ?? ThemeApp.color.black.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        onChanged: ((value) => onChange != null ? onChange!(value) : {}),
        maxLines: maxLines,
        keyboardType: TextInputType.text,
        style: ThemeApp.font.medium.copyWith(fontSize: 14),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: placeHolder ?? '',
          hintStyle: ThemeApp.font.regular.copyWith(fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
