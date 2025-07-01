import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fangmou_plugin_platform_interface.dart';

/// An implementation of [FangmouPluginPlatform] that uses method channels.
class MethodChannelFangmouPlugin extends FangmouPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fangmou_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
