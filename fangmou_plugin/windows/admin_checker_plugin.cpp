#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <windows.h>
#include <sddl.h>

namespace {

class AdminCheckerPlugin : public flutter::Plugin {
public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

    AdminCheckerPlugin();

    virtual ~AdminCheckerPlugin();

private:
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

    // 检测管理员权限的核心函数
    bool IsWindowsAdmin();
};

// 静态注册方法
void AdminCheckerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "admin_checker",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<AdminCheckerPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
}

AdminCheckerPlugin::AdminCheckerPlugin() {}

AdminCheckerPlugin::~AdminCheckerPlugin() {}

// 检测管理员权限的实现
bool AdminCheckerPlugin::IsWindowsAdmin() {
    BOOL isElevated = FALSE;
    HANDLE hToken = NULL;

    // 打开当前进程的访问令牌
    if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken)) {
        return false;
    }

    // 获取令牌提升信息
    TOKEN_ELEVATION elevation;
    DWORD dwSize = sizeof(TOKEN_ELEVATION);

    if (GetTokenInformation(hToken, TokenElevation, &elevation, sizeof(elevation), &dwSize)) {
        isElevated = elevation.TokenIsElevated;
    }

    CloseHandle(hToken);
    return isElevated != FALSE;
}

// 方法调用处理
void AdminCheckerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    if (method_call.method_name().compare("isWindowsAdmin") == 0) {
        // 调用管理员检测函数
        bool isAdmin = IsWindowsAdmin();
        result->Success(flutter::EncodableValue(isAdmin));
    } else {
        result->NotImplemented();
    }
}

}  // namespace

void AdminCheckerPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
    AdminCheckerPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}