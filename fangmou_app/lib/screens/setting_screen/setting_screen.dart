import 'package:fangmou_app/screens/setting_screen/setting_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(settingScreenViewmodelProvider);
    var screenViewmodel = ref.watch(settingScreenViewmodelProvider.notifier);

    return
      switch (screenState) {
      // 数据加载成功
        AsyncData(value: final state) => staticWidget(screenViewmodel, [
          Checkbox(onChanged: screenViewmodel.setExplorerContextMenuIntegration, value: state.enableExplorerContextMenuIntegration,),
        ]),
        _ => staticWidget(screenViewmodel, [
          Checkbox(onChanged: screenViewmodel.setExplorerContextMenuIntegration, value: false,),
        ]),
      };

  }

  Widget staticWidget(SettingScreenViewmodel viewmodel,List<Widget> widgets){
    return Center(child: Column(
      children: [
        Row(children: [widgets[0], Text("集成到资源管理器右键功能菜单")]),
      ],
    ));
  }

}
