import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_auth_services.dart';
import 'package:flowdo/domain/data/services/theme_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/firebase_options.dart';
import 'package:flowdo/presentation/views/auth_view.dart';
import 'package:flowdo/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeServices(),
        )
      ],
      child: Consumer<ThemeServices>(
        builder: (context, value, child) {
          return MaterialApp(
            title: AppInfo.appName,
            theme: getAppTheme(context, brightness: Brightness.light),
            darkTheme: getAppTheme(context, brightness: Brightness.dark),
            home: const AuthWrapper(),
            debugShowCheckedModeBanner: false,
            themeMode: value.currentTheme,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const HomeView();
    }
    return const AuthView();
  }
}