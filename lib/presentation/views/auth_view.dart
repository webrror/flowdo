import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_auth_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/presentation/widgets/buttons/stadium_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: getScreenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              AppInfo.appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 40,
            ),
            StadiumButton(
              onTap: () {
                context.read<FirebaseAuthMethods>().signInWithGoogle(context);
              },
              content: const Text(Strings.signInWithGoogle),
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
            StadiumButton(
              onTap: () {
                context.read<FirebaseAuthMethods>().signInAsAGuest(context);
              },
              content: const Text(Strings.signInAsGuest),
            )
          ],
        ),
      ),
    );
  }
}