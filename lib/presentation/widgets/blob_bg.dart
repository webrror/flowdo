import 'package:flowdo/common/constants/asset_constants.dart';
import 'package:flowdo/common/utils/size_utils.dart';
import 'package:flowdo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlobBackground extends StatelessWidget {
  const BlobBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          const FLPositionedWidget(
            assetPath: AssetConstants.blob2,
            customTop: -200, // Halfway above the screen
          ),
          FLPositionedWidget(
            assetPath: AssetConstants.blob2,
            customTop: (getScreenHeight(context) * 0.3),
            customLeft: -220,
            rotate: -math.pi / 2,
          ),
          const FLPositionedWidget(
            assetPath: AssetConstants.blob2,
            customBottom: -130,
            customRight: -220,
          ),
          if ((constraints.constrainWidth() > 1024)) ...[
            FLPositionedWidget(
              assetPath: AssetConstants.blob0,
              customTop: (getScreenHeight(context) * 0.6),
              customLeft: 200,
              rotate: -math.pi / 2,
            ),
            FLPositionedWidget(
              assetPath: AssetConstants.blob1,
              customTop: (getScreenHeight(context) * 0.4),
              customRight: 200,
              rotate: -math.pi / 2,
            ),
          ]
        ],
      );
    });
  }
}