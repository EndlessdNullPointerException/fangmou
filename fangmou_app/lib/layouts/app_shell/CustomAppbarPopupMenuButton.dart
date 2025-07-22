import 'package:flutter/material.dart';

import 'CustomAppbarStyle.dart';

class CustomAppbarPopupMenuButton extends StatelessWidget {
  final PopupMenuItemSelected onSelected;
  final PopupMenuItemBuilder<String> itemBuilder;
  final Icon icon;

  const CustomAppbarPopupMenuButton({super.key, required this.itemBuilder, required this.onSelected, required this.icon});

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
