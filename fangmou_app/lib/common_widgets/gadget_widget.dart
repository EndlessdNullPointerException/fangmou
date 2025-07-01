import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

void showSnackBar(String message) {
  if (AppRouter.context != null) {
    ScaffoldMessenger.of(AppRouter.context!).showSnackBar(SnackBar(content: Text(message)));
  }
}

void showMaterialBanner(String message, Color color) {
  if (AppRouter.context != null) {
    ScaffoldMessenger.of(AppRouter.context!).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        backgroundColor: color, // 背景色
        leading: Icon(Icons.warning, color: Colors.red), // 左侧图标
        actions: [
          TextButton(
            child: Icon(Icons.done, size: 20),
            onPressed: () => ScaffoldMessenger.of(AppRouter.context!).hideCurrentMaterialBanner(), // 关闭横幅
          ),
        ],
      ),
    );
  }
}
