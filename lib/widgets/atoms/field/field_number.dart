import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class FieldNumber extends StatefulWidget {
  final TextEditingController? controller;
  final Function? onChange;
  final Function? onSubmitted;
  final bool? autoFocus;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final String? placeHolder;
  final bool border;
  final Widget? suffix;
  const FieldNumber({
    Key? key,
    this.controller,
    this.onChange,
    this.onSubmitted,
    this.autoFocus,
    this.padding,
    this.height = 40,
    this.width,
    this.placeHolder,
    this.border = true,
    this.suffix,
  }) : super(key: key);

  @override
  State<FieldNumber> createState() => _FieldNumberState();
}

class _FieldNumberState extends State<FieldNumber> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    (widget.controller ?? textEditingController).addListener(() {
      final text = PriceFormatter.instance.decimal(
        double.tryParse(PriceFormatter.instance.cleanPrice((widget.controller ?? textEditingController).text)) ?? 0.0,
        decimalDigits: 0,
      );
      if (text.isNotEmpty) {
        (widget.controller ?? textEditingController).value = (widget.controller ?? textEditingController).value
            .copyWith(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: ThemeApp.color.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      height: widget.height,
      width: widget.width,
      constraints: const BoxConstraints(minHeight: 10),
      child: TextField(
        controller: widget.controller ?? textEditingController,
        focusNode: _focusNode,
        autofocus: widget.autoFocus ?? true,
        cursorColor: ThemeApp.color.primary,
        onChanged: ((value) => widget.onChange != null ? widget.onChange!(value) : {}),
        onSubmitted: ((value) =>
            widget.onSubmitted != null ? {widget.onSubmitted!(value), _focusNode.requestFocus()} : {}),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        style: ThemeApp.font.medium.copyWith(fontSize: 14),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          suffix: widget.suffix,
          hintText: widget.placeHolder ?? '',
          hintStyle: ThemeApp.font.regular.copyWith(fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          filled: true,
          fillColor: ThemeApp.color.grey,
        ),
      ),
    );
  }
}
