import 'dart:ui';

import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController _settingsIconAnimationController;

  @override
  void initState() {
    _settingsIconAnimationController = AnimationController(
      vsync: this,
      duration: 500.ms,
    );
    super.initState();
  }

  @override
  void dispose() {
    _settingsIconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: const Text(
          "Flowdo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        // actions: [
        //   InkWell(
        //     customBorder: const CircleBorder(),
        //     onTap: () {
        //       _settingsIconAnimationController.forward(from: 0);
        //     },
        //     onLongPress: () {
        //       _settingsIconAnimationController.forward(from: 0);
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(7.0),
        //       child: const FaIcon(
        //         FontAwesomeIcons.gear,
        //         size: 20,
        //       )
        //           .animate(
        //             controller: _settingsIconAnimationController,
        //             onPlay: (controller) => controller.stop(),
        //           )
        //           .rotate(duration: 500.ms),
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 10,
        //   ),
        // ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BlobBackground(),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0, tileMode: TileMode.clamp),
              child: SizedBox(
                height: getScreenHeight(context),
                width: getScreenWidth(context),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        onPressed: () {},
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0, tileMode: TileMode.clamp),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  size: 18,
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
