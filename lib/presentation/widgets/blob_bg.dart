import 'package:flowdo/common/constants/asset_constants.dart';
import 'package:flowdo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BlobBackground extends StatelessWidget {
  const BlobBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        RandomPositionedWidget(
          assetPath: AssetConstants.blob0,
        ),
        RandomPositionedWidget(
          assetPath: AssetConstants.blob1,
        ),
      ],
    );
  }
}