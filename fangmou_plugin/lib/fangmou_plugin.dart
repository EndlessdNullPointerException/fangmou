
import 'fangmou_plugin_platform_interface.dart';

class FangmouPlugin {
  Future<String?> getPlatformVersion() {
    return FangmouPluginPlatform.instance.getPlatformVersion();
  }
}
