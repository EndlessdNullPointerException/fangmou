import 'package:fangmou_app/screens/setting_screen/setting_screen_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      state = AsyncValue.data(SettingScreenState(enableExplorerContextMenuIntegration: checkExplorerContextMenuIntegration()));
    } else {
      state = AsyncValue.data(SettingScreenState(enableExplorerContextMenuIntegration: checkExplorerContextMenuIntegration()));
    }
  }
}
