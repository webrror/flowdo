import 'package:flowdo/common/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    super.key,
    required this.onTap,
    required this.content,
    this.bgColor,
    this.borderColor,
    this.verticalPadding = 8,
    this.horizontalPadding = 25,
    this.tooltip,
  });
  final VoidCallback? onTap;
  final Widget content;
  final Color? bgColor;
  final Color? borderColor;
  final double verticalPadding;
  final double horizontalPadding;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(color: borderColor ?? getBorderColor(context)),
          ),
          color: bgColor ?? Colors.white.withOpacity(0.1),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          customBorder: StadiumBorder(
            side: BorderSide(color: borderColor ?? getBorderColor(context)),
          ),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}