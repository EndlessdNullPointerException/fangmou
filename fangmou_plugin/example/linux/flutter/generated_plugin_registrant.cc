//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fangmou_plugin/fangmou_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fangmou_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FangmouPlugin");
  fangmou_plugin_register_with_registrar(fangmou_plugin_registrar);
}
