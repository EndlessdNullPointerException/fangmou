import 'package:flutter/material.dart';
import 'package:fangmou_plugin/admin_check.dart';
void main() => runApp(const AdminCheckerApp());

class AdminCheckerApp extends StatefulWidget {
  const AdminCheckerApp({super.key});

  @override
  State<AdminCheckerApp> createState() => _AdminCheckerAppState();
}

class _AdminCheckerAppState extends State<AdminCheckerApp> {
  bool _isAdmin = false;
  bool _isChecking = false;

  Future<void> _checkAdminStatus() async {
    setState(() => _isChecking = true);

    try {
      final isAdmin = await AdminChecker.isWindowsAdmin();
      setState(() {
        _isAdmin = isAdmin;
        _isChecking = false;
      });
    } catch (e) {
      setState(() => _isChecking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('检测失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Windows管理员权限检测',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('Windows管理员权限检测')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.admin_panel_settings, size: 100, color: Colors.blue),
              const SizedBox(height: 30),
              Text(
                '当前管理员权限状态:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _isChecking
                  ? const CircularProgressIndicator()
                  : Text(
                _isAdmin ? '已获得管理员权限' : '未获得管理员权限',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isAdmin ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isChecking ? null : _checkAdminStatus,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  '检测管理员权限',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '此插件仅检测Windows平台管理员权限状态。'
                      '如需管理员权限，请右键单击应用程序并选择"以管理员身份运行"。',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}