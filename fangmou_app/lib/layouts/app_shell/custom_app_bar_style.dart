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

class CustomAppbarIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const CustomAppbarIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: CustomAppbarStyle.iconColor,
      iconSize: CustomAppbarStyle.iconSize,
      padding: CustomAppbarStyle.iconPadding,
    );
  }
}

class CustomAppbarPopupMenuButton extends StatelessWidget {
  final PopupMenuItemSelected onSelected;
  final PopupMenuItemBuilder<String> itemBuilder;
  final Icon icon;

  const CustomAppbarPopupMenuButton({
    super.key,
    required this.itemBuilder,
    required this.onSelected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: icon,
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      iconColor: CustomAppbarStyle.iconColor,
      offset: CustomAppbarStyle.popupMenuButtonOffset,
      iconSize: CustomAppbarStyle.iconSize, // 缩小图标大小（默认 24）
      padding: CustomAppbarStyle.iconPadding,
    );
  }
}
