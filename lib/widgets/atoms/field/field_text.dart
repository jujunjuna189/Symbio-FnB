import 'package:flutter/material.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class FieldText extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onChange;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final String? placeHolder;
  final bool border;
  final Map? style;
  final Widget? suffix;
  const FieldText({
    Key? key,
    this.controller,
    this.onChange,
    this.padding,
    this.height = 40,
    this.width,
    this.placeHolder,
    this.border = true,
    this.style,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: border ? Border.all(width: 1, color: ThemeApp.color.black.withOpacity(0.2)) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      height: height,
      width: width,
      constraints: const BoxConstraints(minHeight: 10),
      child: TextField(
        controller: controller,
        cursorColor: ThemeApp.color.primary,
        onChanged: ((value) => onChange != null ? onChange!(value) : {}),
        keyboardType: TextInputType.text,
        style: ThemeApp.font.medium.copyWith(fontSize: 14),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          suffix: suffix,
          hintText: placeHolder ?? '',
          hintStyle: ThemeApp.font.regular.copyWith(fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          filled: true,
          fillColor: style?['background'] ?? ThemeApp.color.grey,
        ),
      ),
    );
  }
}
