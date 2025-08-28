import 'package:flutter/material.dart';
import 'package:pos_simple_v2/pages/product/widget/form/form_product_add.dart';
import 'package:pos_simple_v2/routes/route_name.dart';

class NavigationFloating {
  NavigationFloating._privateConstructor();
  static final NavigationFloating instance = NavigationFloating._privateConstructor();

  void showFloatingMenu(BuildContext context, dynamic bloc) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    final animationDuration = const Duration(milliseconds: 200);
    final opacityNotifier = ValueNotifier<double>(0.0);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<double>(
          valueListenable: opacityNotifier,
          builder: (context, opacity, _) {
            return Stack(
              children: [
                // klik luar untuk menutup
                GestureDetector(
                  onTap: () {
                    opacityNotifier.value = 0.0;
                    Future.delayed(animationDuration, () {
                      overlayEntry.remove();
                    });
                  },
                  child: Container(color: Colors.transparent),
                ),

                // posisi menu
                Positioned(
                  right: 20 + 56,
                  bottom: 18,
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: animationDuration,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          RotatingMiniButton(
                            icon: Icons.add,
                            onTap: () {
                              FormProductAdd.instance.show(context, bloc);
                              overlayEntry.remove();
                            },
                            isRotating: false, // diam
                          ),

                          const SizedBox(width: 10),

                          RotatingMiniButton(
                            icon: Icons.history,
                            onTap: () {
                              Navigator.of(context).pushNamed(RouteName.ORDER);
                              overlayEntry.remove();
                            },
                            isRotating: false, // diam
                          ),

                          const SizedBox(width: 10),

                          RotatingMiniButton(
                            icon: Icons.sync,
                            onTap: () {
                              Navigator.of(context).pushNamed(RouteName.ORDER);
                              overlayEntry.remove();
                            },
                            color: Colors.blueAccent,
                            isRotating: true, // muter terus
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);

    // mulai animasi fade-in
    Future.delayed(const Duration(milliseconds: 10), () {
      opacityNotifier.value = 1.0;
    });
  }
}

class RotatingMiniButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool isRotating;

  const RotatingMiniButton({required this.icon, required this.onTap, this.color, this.isRotating = false, super.key});

  @override
  State<RotatingMiniButton> createState() => _RotatingMiniButtonState();
}

class _RotatingMiniButtonState extends State<RotatingMiniButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    if (widget.isRotating) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = IconButton(
      icon: Icon(widget.icon, color: widget.color),
      onPressed: widget.onTap,
    );

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.1), blurRadius: 6)],
      ),
      child: widget.isRotating
          ? RotationTransition(turns: _controller.drive(Tween(begin: 1.0, end: 0.0)), child: child)
          : child,
    );
  }
}
