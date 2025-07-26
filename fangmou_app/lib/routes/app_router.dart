import 'package:fangmou_app/utils/extensions/go_router_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../layouts/app_shell/app_shell.dart';
import '../screens/demo_screen/template/template.dart';
import '../screens/function_calculator_screen/function_calculator_screen.dart';
import '../screens/function_decompress_screen/function_decompress_screen.dart';
import '../screens/function_directory_screen/function_directory_screen.dart';
import '../screens/function_note_screen/function_note_detail_screen/function_note_detail_screen.dart';
import '../screens/function_note_screen/function_note_list_screen/function_note_list_screen.dart';
import '../screens/function_schedule_screen/function_schedule_detail_screen/function_schedule_detail_screen.dart';
import '../screens/function_schedule_screen/function_schedule_list_screen/function_schedule_list_screen.dart';
import '../screens/function_spider_screen/function_spider_screen.dart';
import '../screens/function_template_screen/function_template_screen.dart';
import '../screens/function_template_screen/model/tabs.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/setting_screen/setting_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

  static final List<FangMouGoRoute> goRouteItemList = [
    FangMouGoRoute(
      name: '主页',
      path: '/home',
      icon: Icon(Icons.home),
      pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
    ),
    FangMouGoRoute(
      name: '笔记',
      path: '/function_note_list',
      icon: Icon(IconData(0xe62c, fontFamily: 'CustomIcon'), size: 16.0),
      pageBuilder: (context, state) => NoTransitionPage(child: FunctionNoteListScreen()),
    ),
    FangMouGoRoute(
      name: '待办事项',
      path: '/',
      pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
      icon: Icon(Icons.schedule),
      descendantRoutes: [
        FangMouGoRoute(
          name: '浏览待办',
          path: '/function_schedule_list',
          icon: Icon(Icons.view_list),
          pageBuilder: (context, state) => NoTransitionPage(child: FunctionScheduleListScreen()),
        ),
      ],
    ),
    FangMouGoRoute(
      name: '模板生成',
      path: '/function_template',
      pageBuilder: (context, state) => const NoTransitionPage(child: FunctionTemplateScreen()),
      icon: Icon(IconData(0xe608, fontFamily: 'CustomIcon')),
    ),
    FangMouGoRoute(
      name: '爬虫',
      path: '/function_spider',
      icon: Icon(IconData(0xf53f, fontFamily: 'CustomIcon'), size: 16.0),
      pageBuilder: (context, state) => NoTransitionPage(child: FunctionSpiderScreen()),
    ),
    FangMouGoRoute(
      name: '解压',
      path: '/function_decompress',
      icon: Icon(Icons.unarchive),
      pageBuilder: (context, state) => NoTransitionPage(child: FunctionDecompressScreen()),
    ),
    FangMouGoRoute(
      name: '路径',
      path: '/function_directory',
      icon: Icon(Icons.folder),
      pageBuilder: (context, state) => NoTransitionPage(child: FunctionDirectoryScreen()),
    ),
    FangMouGoRoute(
      name: '计算器',
      path: '/function_calculator',
      icon: Icon(Icons.calculate),
      pageBuilder: (context, state) => NoTransitionPage(child: FunctionCalculatorScreen()),
    ),
    FangMouGoRoute(
      name: '其他',
      path: '/',
      pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
      icon: Icon(Icons.more_vert),
      descendantRoutes: [
        FangMouGoRoute(
          name: '设置',
          path: '/setting',
          icon: Icon(Icons.settings),
          pageBuilder: (context, state) => NoTransitionPage(child: SettingScreen()),
        ),
        FangMouGoRoute(
          name: '帮助',
          path: '/help',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          icon: Icon(Icons.help),
        ),
      ],
    ),
    FangMouGoRoute(
      name: 'Test',
      path: '/function_test',
      icon: Icon(Icons.pan_tool),
      pageBuilder:
          (context, state) => NoTransitionPage(
            child: AbcScreen(
              route: FangMouGoRoute(
                path: "path",
                name: "TEST",
                pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
              ),
            ),
          ),
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
          // Home 标签页
          GoRoute(path: '/', pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen())),
          ...goRouteItemList,

          // region 动态路由
          GoRoute(
            path: '/function_schedule_detail/:id',
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(child: FunctionScheduleDetailScreen(id: state.pathParameters['id']!)),
          ),
          GoRoute(
            path: '/function_note_detail/:id',
            pageBuilder:
                (context, state) => NoTransitionPage(child: FunctionNoteDetailScreen(id: state.pathParameters['id']!)),
          ),
          // endregion

          // region 模板路由
          // 由于模板数量众多，所以需要通过每个类型单独的模板路由管理
          ...functionTemplateFlutterRoute,
          ...functionTemplateJavaRoute,
          ...functionTemplatePythonRoute,
          ...functionTemplateVueRoute,
          ...functionTemplateSqlRoute,
          // endregion
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
