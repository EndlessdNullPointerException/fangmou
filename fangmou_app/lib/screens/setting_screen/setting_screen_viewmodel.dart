import 'dart:io';
import 'package:charset/charset.dart';
import 'package:fangmou_app/screens/setting_screen/setting_screen_state.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/constants/constants.dart';

part 'setting_screen_viewmodel.g.dart';

@riverpod
class SettingScreenViewmodel extends _$SettingScreenViewmodel {
  static const addSubmenu = '''Windows Registry Editor Version 5.00

; ============================================================================
;  脚本功能: 为右键菜单添加一个包含三个子选项的主菜单
;  使用方法: 以 UTF-16 LE 编码保存为 .reg 文件, 然后双击导入
; ============================================================================

; --- 第 1 步: 在 CommandStore 中定义每个子命令的具体行为 ---
; 这些是所有子菜单项的“后台”定义

; -- 用于文件和文件夹的子命令 (参数 %1) --

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action1]
@="选项一"
"Icon"="{{appPath}}"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action1\\command]
@="\\"{{appPath}}\\" --action1 \\"%1\\""

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action2]
@="选项二"
"Icon"="{{appPath}}"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action2\\command]
@="\\"{{appPath}}\\" --action2 \\"%1\\""

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action3]
@="选项三"
"Icon"="{{appPath}}"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action3\\command]
@="\\"{{appPath}}\\" --action3 \\"%1\\""


; -- 用于文件夹背景的子命令 (参数 %V) --

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action1.Bg]
@="选项一"
"Icon"="{{appPath}}"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action1.Bg\\command]
@="\\"{{appPath}}\\" --action1 \\"%V\\""

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action2.Bg]
@="选项二"
"Icon"="{{appPath}}"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action2.Bg\\command]
@="\\"{{appPath}}\\" --action2 \\"%V\\""

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action3.Bg]
@="选项三"
"Icon"="{{appPath}}"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action3.Bg\\command]
@="\\"{{appPath}}\\" --action3 \\"%V\\""


; --- 第 2 步: 创建主菜单项，并把它链接到上面的子命令 ---

; 为文件创建主菜单
[HKEY_CLASSES_ROOT\\*\\shell\\FangmouAppParent]
"MUIVerb"="用 {{appName}} 处理"
"Icon"="{{appPath}}"
"SubCommands"="Fangmou.Action1;Fangmou.Action2;Fangmou.Action3"

; 为文件夹创建主菜单
[HKEY_CLASSES_ROOT\\Directory\\shell\\FangmouAppParent]
"MUIVerb"="用 {{appName}} 处理"
"Icon"="{{appPath}}"
"SubCommands"="Fangmou.Action1;Fangmou.Action2;Fangmou.Action3"

; 为文件夹背景创建主菜单
[HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\FangmouAppParent]
"MUIVerb"="用 {{appName}} 处理"
"Icon"="{{appPath}}"
"SubCommands"="Fangmou.Action1.Bg;Fangmou.Action2.Bg;Fangmou.Action3.Bg"''';

  static const removeSubmenu = '''Windows Registry Editor Version 5.00

; ============================================================================
;  脚本功能: 移除由 add_submenu.reg 添加的所有右键菜单和子菜单项
;  使用方法: 以 UTF-16 LE 编码保存为 .reg 文件, 然后双击导入
; ============================================================================

; --- 第 1 步: 移除主菜单项 ---
[-HKEY_CLASSES_ROOT\\*\\shell\\FangmouAppParent]
[-HKEY_CLASSES_ROOT\\Directory\\shell\\FangmouAppParent]
[-HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\FangmouAppParent]

; --- 第 2 步: 移除在 CommandStore 中定义的所有子命令 ---
[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action1]
[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action2]
[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action3]
[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action1.Bg]
[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action2.Bg]
[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\Fangmou.Action3.Bg]''';

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

  //
  // void setExplorerContextMenuIntegration(bool? value) async {
  //   logger.d(value);
  //   state = AsyncValue.data(SettingScreenState(enableExplorerContextMenuIntegration: value!));
  // }
  //
  void setExplorerContextMenuIntegration(bool? value) async {
    var current = getCurrentState();

    var script = "";
    try {
      final appPath = Platform.resolvedExecutable.replaceAll('\\', '\\\\');
      final appName = path.basenameWithoutExtension(appPath);

      // 选择脚本
      if (value!) {
        script = addSubmenu.replaceAll('{{appName}}', appName).replaceAll('{{appPath}}', appPath);
      } else {
        script = removeSubmenu;
      }

      List<int> encodedBytes = Utf16Encoder().encodeUtf16Le(script, false);

      // 手动添加 BOM (FF FE)
      // charset 的编码器默认不添加 BOM，但多数系统需要它来正确识别文件
      final bom = [0xFF, 0xFE];
      encodedBytes = [...bom, ...encodedBytes];

      // 将字节写入文件
      final tempDir = Directory.systemTemp;
      final tempRegFile = File('${tempDir.path}\\$appName.reg');
      logger.d('${tempDir.path}\\$appName.reg');
      await tempRegFile.writeAsBytes(encodedBytes);

      // 执行注册
      await Process.run('regedit.exe', ['/s', tempRegFile.path]);

      // 删除临时文件
      await tempRegFile.delete();
    } catch (e) {
      logger.e(e);
    }

    state = AsyncValue.data(SettingScreenState(enableExplorerContextMenuIntegration: value!));
  }
}
