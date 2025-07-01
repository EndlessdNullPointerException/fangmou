#include "include/fangmou_plugin/fangmou_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fangmou_plugin.h"

void FangmouPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fangmou_plugin::FangmouPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
