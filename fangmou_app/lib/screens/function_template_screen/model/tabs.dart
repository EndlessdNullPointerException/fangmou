import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template.dart';

import '../../../utils/extensions/go_router_extension.dart';
import '../function_template_flutter/base_page_template.dart';

import 'package:go_router/go_router.dart';

import '../function_template_sql/table_create_template.dart';
import '../function_template_sql/table_update_template.dart';

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
}

final List<FangMouGoRoute> functionTemplateFlutterRoute = [
  FangMouGoRoute(name: '基础页面模板', path: '/base_page_template', pageBuilder: (context, state) => NoTransitionPage(child: BasePageTemplate())),
  FangMouGoRoute(name: '模板生成模板', path: '/template_generate_template', pageBuilder: (context, state) => NoTransitionPage(child: TemplateGenerateTemplate())),

];
final List<FangMouGoRoute> functionTemplateJavaRoute = [];

final List<FangMouGoRoute> functionTemplatePythonRoute = [];

final List<FangMouGoRoute> functionTemplateSqlRoute = [
  FangMouGoRoute(name: '数据表创建模板', path: '/table_create_template', pageBuilder: (context, state) => NoTransitionPage(child: TableCreateTemplate())),
  FangMouGoRoute(name: '数据表更新模板', path: '/table_update_template', pageBuilder: (context, state) => NoTransitionPage(child: TableUpdateTemplate())),
];
final List<FangMouGoRoute> functionTemplateVueRoute = [];
