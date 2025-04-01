import 'package:flutter/material.dart';

import 'dialog_windows.dart';

Offset getCenterOffset(BuildContext context, double width, double height) {
  double maxWidth = MediaQuery.of(context).size.width - width;
  double maxHeight = MediaQuery.of(context).size.height - height;
  return Offset(maxWidth / 2, maxHeight / 4 );
}

Future<void> showCustomDialog(BuildContext context,
    {required String title,
    required double width,
    required double height,
    required Widget child,
    bool barrierDismissible = false,
    required void Function() onClose}) async {
  await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .1),
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return DialogWindows(
            position: getCenterOffset(context, width, height),
            width: width,
            height: height,
            onClose: onClose,
            title: title,
            child: child);
      });
}
