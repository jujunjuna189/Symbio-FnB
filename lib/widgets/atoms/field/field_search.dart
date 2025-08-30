import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class FieldSearch extends StatefulWidget {
  final TextEditingController? controller;
  final Function? onChange;
  final Function? onSubmitted;
  final double? padding;
  final String? placeHolder;
  final double? height;
  final bool border;
  const FieldSearch({
    Key? key,
    this.controller,
    this.onChange,
    this.onSubmitted,
    this.padding,
    this.placeHolder,
    this.height = 45,
    this.border = true,
  }) : super(key: key);

  @override
  State<FieldSearch> createState() => _FieldSearchState();
}

class _FieldSearchState extends State<FieldSearch> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeField = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _focusNode.requestFocus();
  //   _focusNodeField.requestFocus();
  // }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
          event.logicalKey == LogicalKeyboardKey.controlRight ||
          event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        return; // Abaikan event ini untuk menghindari error
      }
      // Check if the Enter key was pressed
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        widget.onSubmitted!(textEditingController.text);
        Future.delayed(const Duration(milliseconds: 500), () {
          textEditingController.text = "";
          _focusNode.requestFocus();
          _focusNodeField.requestFocus();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        widget.onSubmitted!(textEditingController.text);
        Future.delayed(const Duration(milliseconds: 500), () {
          textEditingController.text = "";
          _focusNode.requestFocus();
          _focusNodeField.requestFocus();
        });
      } else {
        // Print other key presses if needed
        print("Key pressed: ${event.logicalKey.debugName}");
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
          event.logicalKey == LogicalKeyboardKey.controlRight ||
          event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        return; // Abaikan event ini untuk menghindari error
      }
      // Check if the Enter key was pressed
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        Future.delayed(const Duration(milliseconds: 500), () {
          textEditingController.text = "";
          _focusNode.requestFocus();
          _focusNodeField.requestFocus();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        Future.delayed(const Duration(milliseconds: 500), () {
          textEditingController.text = "";
          _focusNode.requestFocus();
          _focusNodeField.requestFocus();
        });
      } else {
        // Print other key presses if needed
        print("Key pressed: ${event.logicalKey.debugName}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: ThemeApp.color.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      height: widget.height,
      constraints: const BoxConstraints(minHeight: 10),
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: TextField(
          controller: widget.controller ?? textEditingController,
          focusNode: _focusNodeField,
          textInputAction: TextInputAction.none,
          onChanged: ((value) => widget.onChange != null ? widget.onChange!(value) : {}),
          keyboardType: TextInputType.text,
          style: ThemeApp.font.regular.copyWith(fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.placeHolder ?? '',
            hintStyle: ThemeApp.font.regular.copyWith(color: ThemeApp.color.black.withOpacity(0.5)),
            isDense: true,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
            prefix: const Padding(padding: EdgeInsets.all(0)),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
