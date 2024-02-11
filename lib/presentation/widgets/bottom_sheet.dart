import 'dart:ui' show ImageFilter;
import 'package:flowdo/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FaIcon, FontAwesomeIcons;

/// Method to show custom glass bottom sheet
///
/// The **`customChild`** component acts as a full replacement, taking control over:
///
/// - **`buildSheet`**
/// - **`sheetTitle`**
/// - **`maxHeight` and `minHeight`**
/// - **`customPadding`**
Future<T?> showGlassBottomSheet<T>(
  BuildContext context, {
  double? maxHeight,
  double? minHeight,
  String? sheetTitle,
  List<Widget>? buildSheet,
  bool isDismissible = true,
  EdgeInsetsGeometry? customPadding,
  Widget? customChild,
}) async {
  double defaultHeight = getScreenHeight(context) * 0.5;
  return await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(26),
        topRight: Radius.circular(26),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: getBottomInsets(context)),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 50.0,
              sigmaY: 50.0,
              tileMode: TileMode.clamp,
            ),
            child: SafeArea(
              child: customChild ??
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight ?? defaultHeight,
                      minHeight: minHeight ?? 0,
                    ),
                    width: getScreenWidth(context),
                    color: getSurfaceColor(context),
                    child: SingleChildScrollView(
                      padding: customPadding ?? const EdgeInsets.symmetric(vertical: 25).copyWith(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (sheetTitle != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ).copyWith(right: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      sheetTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          ...buildSheet ?? [],
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ),
      );
    },
  );
}