import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class FangMouGoRoute extends GoRoute {
   FangMouGoRoute( {
    required super.path,
    super.name,
    super.builder,
    super.pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.caseSensitive,
    List<FangMouGoRoute>? descendantRoutes,
    Icon? icon,
    String? hintMessage,
  }) : _icon = icon,
       _hintMessage = hintMessage,
       _descendantRoutes = descendantRoutes,
       super(routes: descendantRoutes ?? const <RouteBase>[]);

  // region <- Values:为 GoRoute 对象附加图标属性，用于导航栏 ->
  final Icon? _icon;
  Icon? get icon => _icon;
  // endregion <- Values:图标 ->

  // region <- Values:为 GoRoute 对象附加 hintMessage 属性，用于导航栏选线提示文字 ->
  final String? _hintMessage;
  String? get hintMessage => _hintMessage;
  // endregion <- Values:图标 ->

  // region <- Values:保留原始的多级routes->
  final List<FangMouGoRoute>? _descendantRoutes;
  List<FangMouGoRoute>? get descendantRoutes => _descendantRoutes;
  // endregion <- Values:保留原始的多级routes ->
}
