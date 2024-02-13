import 'package:flowdo/common/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class FLButton extends StatelessWidget {
  const FLButton({
    super.key,
    required this.onTap,
    required this.content,
    this.bgColor,
    this.borderColor,
    this.verticalPadding = 8,
    this.horizontalPadding = 25,
    this.tooltip,
    this.tooltipTriggerMode,
    this.shapeBorder,
    this.durationInSeconds,
  });
  final VoidCallback? onTap;
  final Widget content;
  final Color? bgColor;
  final Color? borderColor;
  final double verticalPadding;
  final double horizontalPadding;
  final String? tooltip;
  final TooltipTriggerMode? tooltipTriggerMode;
  final ShapeBorder? shapeBorder;
  final int? durationInSeconds;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      triggerMode: tooltipTriggerMode,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      showDuration: Duration(seconds: durationInSeconds ?? 1),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: shapeBorder ??
              StadiumBorder(
                side: BorderSide(color: borderColor ?? getBorderColor(context)),
              ),
          color: bgColor ?? Colors.white.withOpacity(0.1),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          customBorder: shapeBorder ??
              StadiumBorder(
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