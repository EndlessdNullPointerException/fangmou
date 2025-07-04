import 'package:fangmou_app/routes/route_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static final List<RouteItem> routeItemList = [
    RouteItem(name: '主页', path: '/home', hintMessage: '', icon: Icon(Icons.home), needRouter: true, screen: HomeScreen()),
    RouteItem(
      name: '笔记',
      path: '',
      hintMessage: '',
      icon: Icon(Icons.note),
   needRouter: false,
      subMenu: [
        RouteItem(name: '', path: '', hintMessage: '',needRouter: false, icon: Icon(Icons.note)),
        RouteItem(name: '', path: '', hintMessage: '',needRouter: false, icon: Icon(Icons.note)),
      ],
    ),
    RouteItem(
      name: '待办事项',
      path: '',
      hintMessage: '',
      icon: Icon(Icons.schedule),needRouter: false,
      subMenu: [
        RouteItem(name: '', path: '', hintMessage: '', needRouter: false,icon: Icon(Icons.note)),
        RouteItem(name: '', path: '', hintMessage: '', needRouter: false,icon: Icon(Icons.note)),
      ],
    ),
    RouteItem(
      name: '爬虫',
      path: '/function_spider',
      hintMessage: '',
      icon: Icon(IconData(0xf53f, fontFamily: 'CustomIcon'),size: 16.0,),
      screen: FunctionSpiderScreen(),needRouter: true,
    ),
    RouteItem(name: '解压', path: '/function_decompress', hintMessage: '', icon: Icon(Icons.unarchive),needRouter: true, screen: FunctionDecompressScreen()),
    RouteItem(name: '路径', path: '/function_directory', hintMessage: '', icon: Icon(Icons.folder),needRouter: true, screen: FunctionDirectoryScreen()),
    RouteItem(name: '计算器', path: '/function_calculator', hintMessage: '', icon: Icon(Icons.calculate),needRouter: false,),
    RouteItem(
      name: '其他',
      path: '',
      hintMessage: '',
      icon: Icon(Icons.more_vert),needRouter: false,
      subMenu: [
        RouteItem(name: '设置', path: '/setting', hintMessage: '', icon: Icon(Icons.settings), screen: SettingScreen(),needRouter: true,),
        RouteItem(name: '帮助', path: '/help', hintMessage: '', icon: Icon(Icons.help),needRouter: true,),
      ],
    ),
  ];

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
          // Home 标签页及其子路由
          GoRoute(path: '/', pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen())),

          for (RouteItem item in routeItemList)
            if (item.needRouter)
              GoRoute(path: item.path, pageBuilder: (context, state) => NoTransitionPage(child: item.screen))
            else if (item.subMenu.isNotEmpty)
              for (RouteItem subItem in item.subMenu)
                if (subItem.needRouter)
                  GoRoute(path: subItem.path, pageBuilder: (context, state) => NoTransitionPage(child: subItem.screen)),
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
