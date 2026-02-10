import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IORefresher extends StatelessWidget {
  final RefreshController controller;
  final Widget child;
  final bool enablePullUp;
  final bool enablePullDown;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;

  const IORefresher({
    super.key,
    required this.controller,
    required this.child,
    this.enablePullDown = false,
    this.enablePullUp = false,
    this.onRefresh,
    this.onLoading,
  });
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: const MaterialClassicHeader(
        color: IOColors.brand500,
      ),
      // header: CustomHeader(
      //   builder: (context, mode) {
      //     return Container(
      //       width: 50,
      //       height: 50,
      //       padding: const EdgeInsets.all(10),
      //       decoration: BoxDecoration(
      //         color: IOColors.backgroundPrimary,
      //         shape: BoxShape.circle,
      //       ),
      //       child: Image.asset(
      //         'assets/images/loading.gif',
      //         color: IOColors.brand400,
      //       ),
      //     );
      //   },
      // ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body = const SizedBox.shrink();
          if (mode == LoadStatus.loading) {
            body = const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox(
            height: 40.0,
            child: Center(child: body),
          );
        },
      ),
      child: child,
    );
  }
  // IORefresher({
  //   super.key,
  //   required super.controller,
  //   super.enablePullDown,
  //   super.enablePullUp,
  //   super.enableTwoLevel,
  //   super.onRefresh,
  //   super.onLoading,
  //   super.onTwoLevel,
  //   super.child,
  // });
}
