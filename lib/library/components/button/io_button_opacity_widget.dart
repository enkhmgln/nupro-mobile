import 'package:flutter/material.dart';

class IOButtonOpacityWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const IOButtonOpacityWidget({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<IOButtonOpacityWidget> createState() => _IOButtonOpacityWidgetState();
}

class _IOButtonOpacityWidgetState extends State<IOButtonOpacityWidget> {
  bool focused = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: focused ? 0.6 : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onTapDown: (_) {
          setState(() {
            focused = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            focused = false;
          });
        },
        onTapCancel: () {
          setState(() {
            focused = false;
          });
        },
        child: widget.child,
      ),
    );
  }
}
