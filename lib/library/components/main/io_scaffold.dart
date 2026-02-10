import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class IOScaffold extends Scaffold {
  const IOScaffold({
    Color? backgroundColor,
    super.key,
    super.resizeToAvoidBottomInset,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.drawer,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.extendBodyBehindAppBar,
    super.appBar,
    super.body,
  }) : super(
          backgroundColor: backgroundColor ?? IOColors.backgroundSecondary,
        );
}

// class IOScaffold extends StatelessWidget {
//   final Color? backgroundColor;

//   final PreferredSizeWidget? appBar;
//   final Widget? drawer;
//   final Widget? child;
//   final Widget? body;
//   final bool extendBodyBehindAppBar;
//   final bool? resizeToAvoidBottomInset;
//   final Widget? floatingActionButton;
//   final FloatingActionButtonLocation? floatingActionButtonLocation;
//   final Widget? bottomNavigationBar;
//   final Widget? bottomSheet;
//   const IOScaffold({
//     super.key,
//     this.appBar,
//     this.drawer,
//     this.child,
//     this.body,
//     this.backgroundColor,
//     this.extendBodyBehindAppBar = false,
//     this.resizeToAvoidBottomInset,
//     this.floatingActionButton,
//     this.floatingActionButtonLocation,
//     this.bottomNavigationBar,
//     this.bottomSheet,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           stops: [0.3, 0.3],
//           colors: [
//             IOColors.brand500,
//             IOColors.backgroundSecondary,
//           ],
//         ),
//       ),
//       child: Scaffold(
//         drawer: drawer,
//         appBar: appBar,
//         extendBodyBehindAppBar: extendBodyBehindAppBar,
//         resizeToAvoidBottomInset: resizeToAvoidBottomInset,
//         backgroundColor: Colors.transparent,
//         body: body ??
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: const BoxDecoration(
//                 color: IOColors.backgroundSecondary,
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//                 child: child,
//               ),
//             ),
//         floatingActionButtonLocation: floatingActionButtonLocation,
//         floatingActionButton: floatingActionButton,
//         bottomNavigationBar: bottomNavigationBar,
//         bottomSheet: bottomSheet,
//       ),
//     );
//   }
// }
