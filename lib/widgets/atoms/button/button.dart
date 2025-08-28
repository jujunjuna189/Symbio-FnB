import 'package:flutter/material.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.child, this.color, this.onPress});

  final Widget child;
  final Color? color;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: onPress == null ? Colors.grey.shade400 : color ?? ThemeApp.color.primary,
          gradient: onPress == null || color != null
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ThemeApp.color.yellow, ThemeApp.color.primary],
                ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Opacity(opacity: onPress == null ? 0.5 : 1, child: child),
      ),
    );
  }
}
