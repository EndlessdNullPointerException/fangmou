import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_screen.dart';
import 'package:fangmou_app/screens/function_template_screen/model/function_template_screen_item.dart';

import '../../../utils/extensions/go_router_extension.dart';

import 'package:go_router/go_router.dart';

import '../function_template_flutter/base_screen_template/base_screen_template_screen.dart';
import '../function_template_sql/table_create_template/table_create_template_screen.dart';

List<FunctionTemplateScreenItem> allTemplates = Tabs.items;

enum Tabs {
  flutter(title: 'Flutter'),
  java(title: 'Java'),
  python(title: 'python'),
  sql(title: 'SQL'),
  vue(title: 'Vue');

  const Tabs({required this.title});
  final String title;

  List<FangMouGoRoute> get routes {
    switch (this) {
      case Tabs.flutter:
        return functionTemplateFlutterRoute;
      case Tabs.java:
        return functionTemplateJavaRoute;
      case Tabs.python:
        return functionTemplatePythonRoute;
      case Tabs.sql:
        return functionTemplateSqlRoute;
      case Tabs.vue:
        return functionTemplateVueRoute;
    }
  }

  static List<FunctionTemplateScreenItem> get items {
    List<FunctionTemplateScreenItem> items = [];
    for (Tabs tab in Tabs.values) {
      for (FangMouGoRoute route in tab.routes) {
        items.add(FunctionTemplateScreenItem(tab: tab.title, route: route, last: DateTime.now(), times: 100));
      }
    }
    return items;
  }
}

final List<FangMouGoRoute> functionTemplateFlutterRoute = [
  // FangMouGoRoute(
  //   id: "11",
  //   name: '模板生成模板实例',
  //   path: '/base_page_template',
  //   pageBuilder: (context, state) {
  //     String id = state.extra as String;
  //     return NoTransitionPage(child: TestScreen(id: id));
  //   },
  // ),
  FangMouGoRoute(
    id: "12",
    name: '模板生成模板',
    path: '/template_generate_template',
    pageBuilder: (context, state) {
      return NoTransitionPage(child: TemplateGenerateTemplateScreen(id: state.extra as String));
    },
  ),
  FangMouGoRoute(
    id: "13",
    name: '基础页面模板',
    path: '/base_screen_template',
    pageBuilder: (context, state) {
      return NoTransitionPage(child: BaseScreenTemplateScreen(id: state.extra as String));
    },
  ),
];
final List<FangMouGoRoute> functionTemplateJavaRoute = [];

final List<FangMouGoRoute> functionTemplatePythonRoute = [];

final List<FangMouGoRoute> functionTemplateSqlRoute = [
  FangMouGoRoute(
    id: "14",
    name: '数据表创建模板',
    path: '/table_create_template',
    pageBuilder: (context, state) {
      return NoTransitionPage(child: TableCreateTemplateScreen(id: state.extra as String));
    },
  ),
];
final List<FangMouGoRoute> functionTemplateVueRoute = [];
