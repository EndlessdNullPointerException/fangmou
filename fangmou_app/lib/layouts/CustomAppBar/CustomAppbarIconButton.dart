import 'package:flutter/material.dart';

import 'CustomAppbarStyle.dart';

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
