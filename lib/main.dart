import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getAppTheme(context, brightness: Brightness.light),
      darkTheme: getAppTheme(context, brightness: Brightness.dark),
      home: const HomeView(),
    );
  }
}
