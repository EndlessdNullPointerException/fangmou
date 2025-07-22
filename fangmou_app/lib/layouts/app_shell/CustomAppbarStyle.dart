import 'package:flutter/material.dart';

class CustomAppbarStyle {
  // region <- Values:IconButton 和 PopupMenuButton 的图标样式 ->
  static const double iconSize = 20;
  static const EdgeInsets iconPadding = EdgeInsets.zero;
  static const Color iconColor = Colors.white;
  // endregion <- Values: ->

  // region <- Values:PopupMenuButton 的样式 ->
  static const Offset popupMenuButtonOffset = Offset(0, 44);
  // endregion <- Values:PopupMenuButtonStyle ->

  // region <- Values:Appbar 整体样式 ->
  static const double appbarHeight = 45;
  static const double appbarPinHeight = 8;
  // endregion <- Values:PopupMenuButtonStyle ->
}
