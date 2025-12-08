import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'share_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    MethodChannel('com.example.app/share').setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "sharedData":
        navigatorKey.currentState?.pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (_, _, _) => ShareScreen(
              sharedText: call.arguments['text'],
              sharedImage: call.arguments['image'],
              sharedUrl: call.arguments['url'],
            ),
          ),
          (route) => false,
        );
        return;
      default:
        throw Exception('not implemented ${call.method}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: CupertinoThemeData(),
      home: const HomeScreen(),
    );
  }
}
