import 'package:fangmou_app/utils/extensions/go_router_extension.dart';

class FunctionTemplateScreenItem {
  final FangMouGoRoute route;
  final String tab;
  final DateTime last;
  final int times;
  bool visible;

  FunctionTemplateScreenItem({
    required this.route,
    required this.tab,
    required this.last,
    required this.times,
    this.visible = false,
  });
}
