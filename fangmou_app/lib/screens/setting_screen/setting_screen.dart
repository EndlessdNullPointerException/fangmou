import 'package:fangmou_app/common_widgets/simple_content_card.dart';
import 'package:fangmou_app/screens/setting_screen/setting_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(settingScreenViewmodelProvider);
    var screenViewmodel = ref.watch(settingScreenViewmodelProvider.notifier);

    return switch (screenState) {
      // 数据加载成功
      AsyncData(value: final state) => staticWidget(screenViewmodel, {
        "checkbox_enableExplorerContextMenuIntegration": Checkbox(
          onChanged: screenViewmodel.setExplorerContextMenuIntegration,
          value: state.enableExplorerContextMenuIntegration,
        ),
        "checkbox_enableAdminPermission": Checkbox(onChanged: null, value: state.enableAdminPermission),
      }),
      _ => staticWidget(screenViewmodel, {
        "checkbox_enableExplorerContextMenuIntegration": Checkbox(onChanged: screenViewmodel.setExplorerContextMenuIntegration, value: false),
        "checkbox_enableAdminPermission": Checkbox(onChanged: screenViewmodel.setExplorerContextMenuIntegration, value: false),
      }),
    };
  }

  Widget staticWidget(SettingScreenViewmodel viewmodel, Map<String, Widget> widgets) {
    return SimpleContentCard(content: Center(
      child: Column(
        children: [
          Row(children: [widgets['checkbox_enableAdminPermission']!, Text("获得管理员权限")]),
          Row(children: [widgets['checkbox_enableExplorerContextMenuIntegration']!, Text("集成到资源管理器右键功能菜单")]),
        ],
      ),
    ));
  }
}
