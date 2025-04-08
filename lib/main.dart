import 'package:cos_challenge/router.dart';
import 'package:cos_challenge/core/preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  final storedUserId = await PreferencesManager.getUserId();
  final shouldSkipLogin = storedUserId != null && storedUserId.isNotEmpty;
  final appRouter = AppRouter(shouldSkipLogin: shouldSkipLogin);
  runApp(MainApp(appRouter: appRouter));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) => OverlaySupport(
    child: MaterialApp.router(routerConfig: appRouter.config()),
  );
}
