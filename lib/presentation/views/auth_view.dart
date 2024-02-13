import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_auth_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/presentation/widgets/buttons/stadium_button.dart';
import 'package:flowdo/presentation/widgets/svg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:provider/provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        actions: [
          FLButton(
            horizontalPadding: 10,
            onTap: null,
            content: const FaIcon(
              FontAwesomeIcons.info,
              size: 14,
            ),
            shapeBorder: CircleBorder(
              side: BorderSide(color: getBorderColor(context)),
            ),
            tooltip: Strings.warningForGuest,
            tooltipTriggerMode: kIsWeb ? null : TooltipTriggerMode.tap,
            durationInSeconds: kIsWeb ? null : 8,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: getScreenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetConstants.appIcon,
              height: 60,
              filterQuality: FilterQuality.medium,
              isAntiAlias: true,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              AppInfo.appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 40,
            ),
            FLButton(
              tooltip: Strings.signInWithGoogle,
              horizontalPadding: 17,
              onTap: () {
                context.read<FirebaseAuthMethods>().signInWithGoogle(context);
              },
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 18,
                    width: 18,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ScalableImageWidget.fromSISource(
                        si: ScalableImageSource.fromSvg(
                          SVGAssetLoader(imagePath: AssetConstants.googleIcon),
                          'google-icon',
                          compact: true,
                        ),
                        onError: (p0) {
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(Strings.signInWithGoogle),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(Strings.or),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            FLButton(
              onTap: () {
                context.read<FirebaseAuthMethods>().signInAsAGuest(context);
              },
              content: const Text(Strings.signInAsGuest),
              horizontalPadding: 17,
              tooltip: Strings.signInAsGuest,
            )
          ],
        ),
      ),
    );
  }
}