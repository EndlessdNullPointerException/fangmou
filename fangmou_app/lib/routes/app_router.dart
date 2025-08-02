import 'package:fangmou_app/routes/fangmou_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../layouts/app_shell/app_shell.dart';

import '../screens/function_note_screen/function_note_detail_screen/function_note_detail_screen.dart';
import '../screens/function_schedule_screen/function_schedule_detail_screen/function_schedule_detail_screen.dart';
import '../screens/function_template_screen/model/tabs.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => rootNavigatorKey.currentContext as BuildContext;

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash', // 初始路径
    routes: [
      // 加载页
      GoRoute(path: '/splash', pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen())),
      // ShellRoute 包裹 AppShell
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          // Home 标签页
          ...FangMouRoutes.routes,
          ...TemplateRoutes.routes,
        ],
      ),
    ],
    redirect: (context, state) {
      return null;
      // final isLoggedIn = context.read(authProvider).isAuthenticated;
      // return isLoggedIn ? null : '/login';  // 路由守卫示例
    },
  );
}
