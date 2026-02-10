import 'package:flutter/material.dart';

class IOSliverHeader extends StatelessWidget {
  final Widget child;
  final double min;
  final double max;
  final bool pinned;
  final bool floating;
  const IOSliverHeader({
    super.key,
    required this.child,
    required this.min,
    required this.max,
    this.pinned = false,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: IOSliverAppBarDelegate(
        child: child,
        min: min,
        max: max,
      ),
    );
  }
}

class IOSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double min;
  final double max;

  IOSliverAppBarDelegate({
    required this.child,
    required this.min,
    required this.max,
  });

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(IOSliverAppBarDelegate oldDelegate) {
    return false;
  }
}
