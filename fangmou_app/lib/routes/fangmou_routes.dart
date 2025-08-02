import 'package:fangmou_app/screens/function_schedule_screen/function_schedule_detail_screen/function_schedule_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/demo_screen/conde_test_field/code_text_field.dart';
import '../screens/function_calculator_screen/function_calculator_screen.dart';
import '../screens/function_decompress_screen/function_decompress_screen.dart';
import '../screens/function_directory_screen/function_directory_screen.dart';
import '../screens/function_note_screen/function_note_detail_screen/function_note_detail_screen.dart';
import '../screens/function_note_screen/function_note_list_screen/function_note_list_screen.dart';
import '../screens/function_schedule_screen/function_schedule_list_screen/function_schedule_list_screen.dart';
import '../screens/function_spider_screen/function_spider_screen.dart';
import '../screens/function_template_screen/function_template_screen.dart';
import '../screens/function_value_screen/function_value_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/setting_screen/setting_screen.dart';
import '../utils/constants/constants.dart';

enum FangMouRoutes {

  // region 枚举项

  // region <- Values:root 和 home ->
  root(name: "root", title: '根页面', path: '/', top: true, routeDescendents: [], navigatorDescendents: []),
  home(
    name: "home",
    title: '主页',
    path: '/home',
    icon: Icon(Icons.home),
    top: true,
    routeDescendents: [],
    navigatorDescendents: [],
  ),
  // endregion <- Values:root 和 home ->

  // region <- Values: note ->
  functionNote(
    name: "function_note",
    title: '笔记列表',
    path: '/function_note',
    icon: Icon(IconData(0xe62c, fontFamily: 'CustomIcon'), size: 16.0),
    top: true,
    routeDescendents: [functionNoteDetail],
    navigatorDescendents: [],
  ),
  functionNoteDetail(
    name: "function_note_detail",
    title: '笔记详情',
    path: ':id',
    top: false,
    routeDescendents: [],
    navigatorDescendents: [],
  ),
  // endregion <- Values: note ->

  // region <- Values: schedule ->
  functionSchedule(
    name: "function_schedule",
    title: '待办列表',
    path: '/function_schedule',
    icon: Icon(Icons.schedule),
    top: true,
    routeDescendents: [functionScheduleDetail],
    navigatorDescendents: [],
  ),
  functionScheduleDetail(
    name: "function_schedule_detail",
    title: '浏览待办',
    path: ':id',
    top: false,
    routeDescendents: [],
    navigatorDescendents: [],
  ),
  // endregion <- Values: schedule ->

  // region <- Values: function ->
  functionTemplate(
    name: "function_template",
    title: '模板生成',
    path: '/function_template',
    icon: Icon(IconData(0xe608, fontFamily: 'CustomIcon')),
    top: true,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  functionSpider(
    name: "function_spider",
    title: '爬虫',
    path: '/function_spider',
    icon: Icon(IconData(0xf53f, fontFamily: 'CustomIcon'), size: 16.0),
    top: true,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  functionDecompress(
    name: "function_decompress",
    title: '解压',
    path: '/function_decompress',
    icon: Icon(Icons.unarchive),
    top: true,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  functionDirectory(
    name: "function_directory",
    title: '路径',
    path: '/function_directory',
    icon: Icon(Icons.folder),
    top: true,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  functionCalculator(
    name: "function_calculator",
    title: '计算器',
    path: '/function_calculator',
    icon: Icon(Icons.calculate),
    top: true,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  functionValue(
    name: "function_value",
    title: '值生成',
    path: '/function_value',
    icon: Icon(Icons.onetwothree),
    top: true,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  // endregion <- Values: function ->

  // region <- Values: others ->
  others(
    name: "other",
    title: '其他',
    path: '/',
    icon: Icon(Icons.more_vert),
    top: true,

    routeDescendents: [setting, help],
    navigatorDescendents: [setting, help],
  ),
  setting(
    name: "setting",
    title: '设置',
    path: '/setting',
    icon: Icon(Icons.settings),
    top: false,

    routeDescendents: [],
    navigatorDescendents: [],
  ),
  help(
    name: "help",
    title: '帮助',
    path: '/help',
    icon: Icon(Icons.help),
    top: false,
    routeDescendents: [],
    navigatorDescendents: [],
  ),
  test(
    name: "test",
    title: '测试',
    path: '/function_test',
    icon: Icon(Icons.pan_tool),
    top: true,
    routeDescendents: [],
    navigatorDescendents: [],
  )
  // endregion <- Values: others ->
  ;
  // endregion 枚举项

  const FangMouRoutes({
    required this.title,
    required this.name,
    required this.path,
    this.icon,
    required this.top,
    required this.routeDescendents,
    required this.navigatorDescendents,
  });

  final String title;
  final String name;
  final String path;
  final Icon? icon;
  final bool top;
  final List<FangMouRoutes> routeDescendents;
  final List<FangMouRoutes> navigatorDescendents;

  GoRouterPageBuilder get pageBuilder {
    switch (this) {
      // region home 和 root
      case FangMouRoutes.root:
        return (context, state) => NoTransitionPage(child: HomeScreen());
      case FangMouRoutes.home:
        return (context, state) => NoTransitionPage(child: HomeScreen());
      // endregion

      // region note
      case FangMouRoutes.functionNote:
        return (context, state) => NoTransitionPage(child: FunctionNoteListScreen());
      case FangMouRoutes.functionNoteDetail:
        return (context, state) => NoTransitionPage(child: FunctionNoteDetailScreen(id: state.pathParameters['id']!));
      // endregion

      // region schedule
      case FangMouRoutes.functionSchedule:
        return (context, state) => NoTransitionPage(child: FunctionScheduleListScreen());

      case FangMouRoutes.functionScheduleDetail:
        return (context, state) => NoTransitionPage(child: FunctionScheduleDetailScreen(id: state.pathParameters['id']!));
      // endregion

      case FangMouRoutes.functionTemplate:
        return (context, state) => const NoTransitionPage(child: FunctionTemplateScreen());
      case FangMouRoutes.functionSpider:
        return (context, state) => NoTransitionPage(child: FunctionSpiderScreen());
      case FangMouRoutes.functionDecompress:
        return (context, state) => NoTransitionPage(child: FunctionDecompressScreen());
      case FangMouRoutes.functionDirectory:
        return (context, state) => NoTransitionPage(child: FunctionDirectoryScreen());
      case FangMouRoutes.functionCalculator:
        return (context, state) => NoTransitionPage(child: FunctionCalculatorScreen());
      case FangMouRoutes.functionValue:
        return (context, state) => NoTransitionPage(child: FunctionValueScreen());

      // region other
      case FangMouRoutes.others:
        return (context, state) => const NoTransitionPage(child: HomeScreen());
      case FangMouRoutes.setting:
        return (context, state) => NoTransitionPage(child: SettingScreen());
      case FangMouRoutes.help:
        return (context, state) => const NoTransitionPage(child: HomeScreen());
      case FangMouRoutes.test:
        return (context, state) => NoTransitionPage(child: CodeEditorPage());
      // endregion
    }
  }

  // region 构建用于创建 go_router 对象的 routes
  static List<GoRoute> get routes {
    List<GoRoute> result = [];
    for (FangMouRoutes fangMouRoute in FangMouRoutes.values) {
      if (fangMouRoute.top) {
        result.add(routeGenerator(fangMouRoute));
      }
    }
    return result;
  }

  static GoRoute routeGenerator(FangMouRoutes fangMouRoute) {
    List<RouteBase> routes = [];
    if (fangMouRoute.routeDescendents.isNotEmpty) {
      for (FangMouRoutes descendentRoute in fangMouRoute.routeDescendents) {
        routes.add(routeGenerator(descendentRoute));
      }
    }
    logger.d('┏━━━━━━━━━━━━━━━━routeGenerator━━━━━━━━━━━━━━━━┓');
    logger.d(fangMouRoute);
    logger.d('┗━━━━━━━━━━━━━━━━routeGenerator━━━━━━━━━━━━━━━━┛');
    return GoRoute(
      path: fangMouRoute.path,
      name: fangMouRoute.name,
      pageBuilder: fangMouRoute.pageBuilder,
      routes: routes,
    );
  }
  // endregion

  // 获取用于创建导航栏的路由
  static List<FangMouRoutes> get navigatorRoutes {
    return FangMouRoutes.values.where((item) => item.top && item.icon != null).toList();
  }
}
