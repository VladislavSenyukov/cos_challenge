import 'package:auto_route/auto_route.dart';
import 'package:cos_challenge/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final bool shouldSkipLogin;
  AppRouter({required this.shouldSkipLogin});

  @override
  List<AutoRoute> get routes => [
    if (shouldSkipLogin)
      RedirectRoute(path: '/', redirectTo: '/${VinSearchRoute.name}'),
    AutoRoute(page: LoginRoute.page, path: '/'),
    AutoRoute(page: VinSearchRoute.page, path: '/${VinSearchRoute.name}'),
  ];
}
