#ifndef FLUTTER_PLUGIN_FANGMOU_PLUGIN_H_
#define FLUTTER_PLUGIN_FANGMOU_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fangmou_plugin {

class FangmouPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FangmouPlugin();

  virtual ~FangmouPlugin();

  // Disallow copy and assign.
  FangmouPlugin(const FangmouPlugin&) = delete;
  FangmouPlugin& operator=(const FangmouPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fangmou_plugin

#endif  // FLUTTER_PLUGIN_FANGMOU_PLUGIN_H_
