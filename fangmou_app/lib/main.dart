import 'package:fangmou_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/DomainUserCaseDI.dart';
import 'di/locator.dart';

Future<void> main(List<String> arguments) async {
  // 进行依赖注入
  setupLocator();
  setupDomainUserCase();

  runApp(
    ProviderScope(
      // RiverPod 状态管理的作用域
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: AppRouter.router,
        // 消除点击布局空白处时产生的 Windows 系统错误提示音
        builder: (context, child) => Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: child,
        ),
        debugShowCheckedModeBanner: false, // 关闭调试横幅
      ),
    ),
  );
}
