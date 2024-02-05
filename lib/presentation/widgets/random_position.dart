import 'dart:math' as math;
import 'package:flowdo/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jovial_svg/jovial_svg.dart';

class RandomPositionedWidget extends StatefulWidget {
  const RandomPositionedWidget({super.key, required this.assetPath});
  final String assetPath;

  @override
  State<RandomPositionedWidget> createState() => _RandomPositionedWidgetState();
}

class _RandomPositionedWidgetState extends State<RandomPositionedWidget> {
  math.Random random = math.Random();
  double top = 0.0;
  double left = 0.0;
  ScalableImage? scalableImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      top = (random.nextDouble() * (getScreenHeight(context) - 400).clamp(0, double.infinity)).abs();
      left = (random.nextDouble() * (getScreenWidth(context) - 400).clamp(0, double.infinity)).abs();
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
        top: top,
        left: left,
        child: SizedBox(
          width: 450,
          height: 450,
          child: ScalableImageWidget(
            si: scalableImage!,
          ),
        )
            .animate(
              onPlay: (controller) => controller.reverse().then(
                    (value) => controller.repeat(),
                  ),
            )
            // .fade(duration: 10.seconds)
            .rotate(duration: 40.seconds),
      );
    } else {
      return const SizedBox();
    }
  }
}
