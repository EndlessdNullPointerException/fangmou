import 'package:flutter/widgets.dart';

class RouteItem {
  final String name;
  final String path;
  final String hintMessage;
  final Icon icon;
  final Widget screen;
  final bool needRouter;
  final List<RouteItem> subMenu;
  const RouteItem( {
    required this.name,
    required this.path,
    required this.hintMessage,
    required this.icon,
    required this.needRouter,
    this.screen = const SizedBox.shrink(),
    this.subMenu = const [],
  });
}
