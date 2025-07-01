import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fangmou_plugin_method_channel.dart';

abstract class FangmouPluginPlatform extends PlatformInterface {
  /// Constructs a FangmouPluginPlatform.
  FangmouPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FangmouPluginPlatform _instance = MethodChannelFangmouPlugin();

  /// The default instance of [FangmouPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFangmouPlugin].
  static FangmouPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FangmouPluginPlatform] when
  /// they register themselves.
  static set instance(FangmouPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
