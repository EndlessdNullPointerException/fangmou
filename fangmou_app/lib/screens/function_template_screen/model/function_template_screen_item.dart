import 'package:fangmou_app/screens/function_template_screen/model/tabs.dart';

class FunctionTemplateScreenItem {
  final TemplateRoutes route;
  final TemplateTypes templateType;
  DateTime last;
  int times;
  bool visible;

  FunctionTemplateScreenItem({
    required this.route,
    required this.templateType,
    required this.last,
    required this.times,
    this.visible = false,
  });
}
