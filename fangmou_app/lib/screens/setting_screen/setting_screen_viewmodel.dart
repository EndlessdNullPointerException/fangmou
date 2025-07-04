import 'dart:convert';
import 'dart:io';

import 'package:fangmou_app/screens/setting_screen/setting_screen_state.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/constants/constants.dart';

part 'setting_screen_viewmodel.g.dart';

@riverpod
class SettingScreenViewmodel extends _$SettingScreenViewmodel {
  // 在 ViewModel 中获取当前状态，提供默认值
  SettingScreenState getCurrentState() {
    return switch (state) {
      AsyncData(value: final value) => value,
      AsyncError() => throw Exception("FunctionDecompressScreenViewModel 获取异步状态出现错误"),
      _ => SettingScreenState(enableExplorerContextMenuIntegration: false),
    };
  }

  @override
  Future<SettingScreenState> build() async {
    return SettingScreenState(enableExplorerContextMenuIntegration: false);
  }

  bool checkExplorerContextMenuIntegration() {
    final current = getCurrentState();
    return !current.enableExplorerContextMenuIntegration;
  }

  void setExplorerContextMenuIntegration(bool? value) {
    var current = getCurrentState();
    if (current.enableExplorerContextMenuIntegration) {
      logger.d("清除注册表");
      _unregisterContextMenu();
      state = AsyncValue.data(SettingScreenState(enableExplorerContextMenuIntegration: checkExplorerContextMenuIntegration()));
    } else{
      logger.d("添加到注册表");
      _registerContextMenu();
      state = AsyncValue.data(SettingScreenState(enableExplorerContextMenuIntegration: checkExplorerContextMenuIntegration()));
    }
  }

  // 注册右键菜单
  void _registerContextMenu() async {
    final appPath = Platform.resolvedExecutable;
    final appName = path.basenameWithoutExtension(appPath);

    logger.d("appPath:$appPath");
    logger.d("appName:$appName");

    // 创建注册表脚本内容
    final regScript = '''
Windows Registry Editor Version 5.00

; 文件右键菜单
[HKEY_CLASSES_ROOT\\*\\shell\\$appName]
@="用$appName处理"

[HKEY_CLASSES_ROOT\\*\\shell\\$appName\\command]
@="\\"$appPath\\" --process-file \\"%1\\""

; 文件夹右键菜单
[HKEY_CLASSES_ROOT\\Directory\\shell\\$appName]
@="用$appName处理"

[HKEY_CLASSES_ROOT\\Directory\\shell\\$appName\\command]
@="\\"$appPath\\" --process-folder \\"%1\\""
''';
    
    logger.d(regScript);

    // 创建临时注册表文件
    // final tempDir = Directory.systemTemp;
    // final regFile = File('${tempDir.path}\\$appName.reg');
    // await regFile.writeAsString(regScript,
    //   encoding: utf8, // 明确指定 UTF-8 编码
    //   mode: FileMode.write,);
    //
    // // 执行注册命令
    // await Process.run('regedit.exe', ['/s', regFile.path]);
    //
    // // 清理临时文件（可选）
    // regFile.delete();
  }

// 卸载右键菜单
  void _unregisterContextMenu() async {
    final appPath = Platform.resolvedExecutable;
    final appName = path.basenameWithoutExtension(appPath);
    logger.d("appPath:$appPath");
    logger.d("appName:$appName");
    // 创建卸载脚本
    final unregScript = '''
Windows Registry Editor Version 5.00

; 删除文件右键菜单
[-HKEY_CLASSES_ROOT\\*\\shell\\$appName]

; 删除文件夹右键菜单
[-HKEY_CLASSES_ROOT\\Directory\\shell\\$appName]
''';
    
    logger.d(unregScript);

    // 创建临时文件并执行
    // final tempDir = Directory.systemTemp;
    // final regFile = File('${tempDir.path}\\uninstall_$appName.reg');
    // await regFile.writeAsString(unregScript,
    //   encoding: utf8, // 明确指定 UTF-8 编码
    //   mode: FileMode.write,);
    // await Process.run('regedit.exe', ['/s', regFile.path]);
    // regFile.delete();
  }
}
