import 'package:flutter_test/flutter_test.dart';
import 'package:fangmou_plugin/fangmou_plugin.dart';
import 'package:fangmou_plugin/fangmou_plugin_platform_interface.dart';
import 'package:fangmou_plugin/fangmou_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFangmouPluginPlatform
    with MockPlatformInterfaceMixin
    implements FangmouPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FangmouPluginPlatform initialPlatform = FangmouPluginPlatform.instance;

  test('$MethodChannelFangmouPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFangmouPlugin>());
  });

  test('getPlatformVersion', () async {
    FangmouPlugin fangmouPlugin = FangmouPlugin();
    MockFangmouPluginPlatform fakePlatform = MockFangmouPluginPlatform();
    FangmouPluginPlatform.instance = fakePlatform;

    expect(await fangmouPlugin.getPlatformVersion(), '42');
  });
}
