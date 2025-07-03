import 'package:fangmou_app/screens/splash_screen/model/startup_status.dart';
import 'package:fangmou_app/screens/splash_screen/splash_screen_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/local/ArchiveFilePasswordList.dart';
import '../../routes/app_router.dart';
import '../../utils/constants/constants.dart';
import '../../utils/platform/windows/AdminPrivilegeUtils.dart';
import '../../utils/platform/windows/file_utils.dart';

part 'splash_screen_viewmodel.g.dart';

@riverpod
class SlashScreenViewmodel extends _$SlashScreenViewmodel {
  @override
  SlashScreenState build() {
    return SlashScreenState(StartupStatus.start);
  }

  Future<void> initial() async {
    try {
      await Future.delayed(Duration(milliseconds: 1));
      state = SlashScreenState(StartupStatus.initializeSevenZip);

      // TODO 获取window平台管理员权限
      // 检查程序是否持有windows管理员权限
      PlatformUtils.isWindowsAdmin();

      // 初始化 Hive
      await Hive.initFlutter();
      // 注册适配器（需先运行生成命令）
      Hive.registerAdapter(ArchiveFilePasswordListAdapter());
      // 打开 Box
      await Hive.openBox('settings');
      await Hive.openBox<ArchiveFilePasswordList>('ArchiveFilePasswordList');

      // 初始化 7zip
      await FileUtils.initialize7z();

      // 压缩功能测试
      await Future.delayed(Duration(milliseconds:1));
      state = SlashScreenState(StartupStatus.testSevenZip);
      await FileUtils.test7zFunctionality();

      // 使用路由跳转到主页面
      await Future.delayed(Duration(milliseconds: 1));
      state = SlashScreenState(StartupStatus.success);
      AppRouter.context!.go('/home');
    } catch (e) {
      logger.e(e);
      state = SlashScreenState(StartupStatus.failure);
    }
  }
}
