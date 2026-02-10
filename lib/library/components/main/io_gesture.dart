import 'package:flutter/material.dart';

class IOGesture extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const IOGesture({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<IOGesture> createState() => _IOButtonOpacityWidgetState();
}

class _IOButtonOpacityWidgetState extends State<IOGesture> {
  bool focused = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: focused ? 0.6 : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onTapDown: widget.onTap == null
            ? null
            : (_) {
                setState(() {
                  focused = true;
                });
              },
        onTapUp: widget.onTap == null
            ? null
            : (_) {
                setState(() {
                  focused = false;
                });
              },
        onTapCancel: widget.onTap == null
            ? null
            : () {
                setState(() {
                  focused = false;
                });
              },
        child: widget.child,
      ),
    );
  }
}
