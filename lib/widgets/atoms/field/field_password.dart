import 'package:flutter/material.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class FieldPassword extends StatefulWidget {
  final TextEditingController? controller;
  final Function? onChange;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final String? placeHolder;
  final bool border;

  const FieldPassword({
    Key? key,
    this.controller,
    this.onChange,
    this.padding,
    this.height = 43,
    this.width,
    this.placeHolder,
    this.border = true,
  }) : super(key: key);

  @override
  State<FieldPassword> createState() => _FieldPasswordState();
}

class _FieldPasswordState extends State<FieldPassword> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        border: widget.border ? Border.all(width: 1, color: ThemeApp.color.primary.withOpacity(0.5)) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      height: widget.height,
      width: widget.width,
      constraints: const BoxConstraints(minHeight: 10),
      child: TextField(
        controller: widget.controller,
        cursorColor: ThemeApp.color.primary,
        onChanged: ((value) => widget.onChange != null ? widget.onChange!(value) : {}),
        keyboardType: TextInputType.visiblePassword,
        obscureText: _isObscure,
        enableSuggestions: false,
        autocorrect: false,
        style: ThemeApp.font.medium.copyWith(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.placeHolder ?? '',
          hintStyle: ThemeApp.font.regular.copyWith(fontSize: 12, color: ThemeApp.color.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          filled: true,
          fillColor: ThemeApp.color.grey,
          suffixIcon: GestureDetector(
            onTap: (() {
              setState(() {
                _isObscure = _isObscure ? false : true;
              });
            }),
            child: _isObscure
                ? Icon(Icons.visibility_off, size: 20, color: ThemeApp.color.primary)
                : Icon(Icons.visibility, size: 20, color: ThemeApp.color.primary),
          ),
        ),
      ),
    );
  }
}
