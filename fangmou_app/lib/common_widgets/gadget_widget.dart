import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../../routes/app_router.dart';
import 'loading_status_widget.dart';

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

void showCustomDialog(String message) {
  showDialog(
    context: AppRouter.context!,
    builder:
        (ctx) => AlertDialog(
          title: Text(message),
          actions: [TextButton(onPressed: () => Navigator.pop(AppRouter.context!), child: Text('确定'))],
        ),
  );
}

void showCustomToast(String message){
  showToast(
    message,
    position: ToastPosition.top,
    backgroundColor: Colors.black.withValues(alpha: 0.7),
    radius: 10.0,
    textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
  );
}


void showLoadingDialog(Stream<LoadingStatusData> currentStatus) {
  showDialog(
    context: AppRouter.context!,
    barrierDismissible: false,
    builder: (ctx) => LoadingStatusWidget(currentStatus: currentStatus),
  );
}
