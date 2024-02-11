import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:jovial_svg/jovial_svg.dart';

class FLPositionedWidget extends StatefulWidget {
  const FLPositionedWidget({
    super.key,
    required this.assetPath,
    this.customTop,
    this.customLeft,
    this.customRight,
    this.customBottom,
    this.rotate,
  });
  final String assetPath;
  final double? customTop;
  final double? customLeft;
  final double? customRight;
  final double? customBottom;
  final double? rotate;
  @override
  State<FLPositionedWidget> createState() => _RandomPositionedWidgetState();
}

class _RandomPositionedWidgetState extends State<FLPositionedWidget> {
  ScalableImage? scalableImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Not so random position widget anymore
      // For now, postitons are static
      // top = (random.nextDouble() * (getScreenHeight(context) - 400).clamp(0, double.infinity)).abs();
      // left = (random.nextDouble() * (getScreenWidth(context) - 400).clamp(0, double.infinity)).abs();
      setScalableImage();
    });
  }

  setScalableImage() async {
    scalableImage = await ScalableImage.fromSvgAsset(
      rootBundle,
      widget.assetPath,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (scalableImage != null) {
      return Positioned(
          top: widget.customTop,
          left: widget.customLeft,
          bottom: widget.customBottom,
          right: widget.customRight,
          child: SizedBox(
            width: 370,
            height: 370,
            child: Transform.rotate(
              angle: widget.rotate ?? 0,
              child: ScalableImageWidget(
                si: scalableImage!,
              ),
            ),
          )
          //! Removed animation for now, need a better way
          // .animate(
          //   onPlay: (controller) => controller.reverse().then(
          //         (value) => controller.repeat(),
          //       ),
          // )
          // // .fade(duration: 10.seconds)
          // .rotate(duration: 40.seconds),
          );
    } else {
      return const SizedBox();
    }
  }
}