import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flowdo/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FLToast {
  late FToast fToast;
  FLToast() {
    fToast = FToast();
  }

  void showToast(
    BuildContext context, {
    required String message,
    ToastType toastType = ToastType.success,
    bool withTitle = false,
    bool withIcon = true,
    int toastDurationInS = 2,
  }) {
    Widget toast = SafeArea(
      top: false,
      bottom: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 500,
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: getToastUI(toastType).$2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (withIcon) ...[
                  Icon(
                    getToastUI(toastType).$1,
                    size: (message.trim().isNotEmpty && !withTitle) ? 20 : 24,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (withTitle)
                        Text(
                          getToastUI(toastType).$3,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      if (message.trim().isNotEmpty) ...[
                        if (withTitle || withIcon) ...[
                          Text(
                            message,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 14),
                          ),
                        ] else ...[
                          Text(
                            message,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ]
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    fToast.init(context);
    fToast.removeCustomToast();
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: toastDurationInS),
      isDismissable: true,
    );
  }

  (IconData, Color, String) getToastUI(ToastType toastType) {
    switch (toastType) {
      case ToastType.success:
        return (
          Icons.check_circle_outline_rounded,
          Colors.green.withOpacity(0.5),
          Strings.success,
        );
      case ToastType.warning:
        return (
          Icons.warning_amber_rounded,
          Colors.amber.withOpacity(0.6),
          Strings.warning,
        );
      case ToastType.error:
        return (
          Icons.error_outline_rounded,
          Colors.redAccent.withOpacity(0.5),
          Strings.error,
        );
      case ToastType.info:
        return (
          Icons.help_outline_rounded,
          Colors.blueAccent.withOpacity(0.5),
          Strings.info,
        );
    }
  }
}

/// Method to show success toast messages
///
/// Pass custom message to `message` param
showSuccessToast(BuildContext context, String message) {
  FLToast().showToast(
    context,
    message: message,
  );
}

/// Method to show error toast message
showErrorToast(BuildContext context) {
  FLToast().showToast(
    context,
    message: Strings.somethingWentWrong,
    toastType: ToastType.error,
  );
}

/// Method to show FirebaseAuthException toast messages
///
/// Pass exception of type [FirebaseAuthException] to `ex` param
///
/// By default shown for 5 seconds, modify by passing a duration in seconds to `duration` param
showFbAuthExceptionToast(BuildContext context, FirebaseAuthException ex, {int duration = 5}) {
  FLToast().showToast(
    context,
    message: ex.message.toString(),
    toastType: ToastType.error,
    toastDurationInS: duration,
  );
}