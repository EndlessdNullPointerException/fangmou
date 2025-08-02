import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_screen.dart';
import 'package:go_router/go_router.dart';

import '../function_template_flutter/base_screen_template/base_screen_template_screen.dart';
import '../function_template_sql/table_create_template/table_create_template_screen.dart';

enum TemplateTypes {
  flutter(title: 'Flutter'),
  java(title: 'Java'),
  python(title: 'python'),
  sql(title: 'SQL'),
  vue(title: 'Vue');

  const TemplateTypes({required this.title});
  final String title;
}

enum TemplateRoutes {
  templateGenerateTemplate(
    id: "1",
    title: '模板生成模板',
    name: "templateGenerateTemplate",
    path: "/templateGenerateTemplate",
    templateType: TemplateTypes.flutter,
  ),
  baseScreenTemplate(id: "2", title: '基本页面模板', name: "baseScreenTemplate", path: "/baseScreenTemplate", templateType: TemplateTypes.flutter),
  tableCreateTemplate(id: "3", title: '数据表模板', name: "tableCreateTemplate", path: "/tableCreateTemplate", templateType: TemplateTypes.sql);

  const TemplateRoutes({
    required this.id,
    required this.title,
    required this.name,
    required this.path,
    required this.templateType,
  });
  final String id;
  final String title;
  final String name;
  final String path;
  final TemplateTypes templateType;

  GoRouterPageBuilder get pageBuilder {
    switch (this) {
      case TemplateRoutes.templateGenerateTemplate:
        return (context, state) => NoTransitionPage(child: TemplateGenerateTemplateScreen(id: state.extra as String));
      case TemplateRoutes.baseScreenTemplate:
        return (context, state) => NoTransitionPage(child: BaseScreenTemplateScreen(id: state.extra as String));
      case TemplateRoutes.tableCreateTemplate:
        return (context, state) => NoTransitionPage(child: TableCreateTemplateScreen(id: state.extra as String));
    }
  }

  static List<GoRoute> get routes {
    List<GoRoute> list = [];
    for (TemplateRoutes templateRoute in TemplateRoutes.values) {
      list.add(GoRoute(path: templateRoute.path, name: templateRoute.name, pageBuilder: templateRoute.pageBuilder));
    }
    return list;
  }
}
