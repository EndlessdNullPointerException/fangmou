import 'package:fangmou_app/routes/route_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../layouts/app_shell.dart';
import '../screens/function_decompress_screen/function_decompress_screen.dart';
import '../screens/function_directory_screen/function_directory_screen.dart';
import '../screens/function_spider_screen/function_spider_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/setting_screen/setting_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get context => rootNavigatorKey.currentContext as BuildContext;

  static final List<RouteItem> routeItemList = [];

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
          // Home 标签页及其子路由
          GoRoute(path: '/', pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen())),
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
            // routes: [
            //   GoRoute(
            //     path: 'details/:id',
            //     builder: (context, state) => DetailsScreen(id: state.params['id']!),
            //   ),
            // ],
          ),
          // Setting 标签页及其子路由
          GoRoute(path: '/setting', pageBuilder: (context, state) => const NoTransitionPage(child: SettingScreen())),
          GoRoute(path: '/function_directory', pageBuilder: (context, state) =>const NoTransitionPage(child: FunctionDirectoryScreen())),
          GoRoute(path: '/function_decompress', pageBuilder: (context, state) =>const NoTransitionPage(child: FunctionDecompressScreen())),
          GoRoute(path: '/function_spider', pageBuilder: (context, state) =>const NoTransitionPage(child: FunctionSpiderScreen())),
          // GoRoute(path: '/calculator_function', pageBuilder: (context, state) => NoTransitionPage(child: CalculatorFunctionScreen())),
          // GoRoute(path: '/spider_function', pageBuilder: (context, state) => NoTransitionPage(child: SpiderFunctionScreen())),
          // 独立于 ShellRoute 的路由（如登录页）
          // GoRoute(
          //   path: '/login',
          //   builder: (context, state) => const LoginScreen(),
          // ),
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
