import 'package:fangmou_app/screens/splash_screen/splash_screen_viewmodel.dart';
import 'package:fangmou_app/screens/splash_screen/widget/startup_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants/constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenStateful();
}

class _SplashScreenStateful extends ConsumerState<SplashScreen> {
  // 初始化执行标志
  bool _executed = false;

  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(slashScreenViewmodelProvider);
    final screenViewmodel = ref.watch(slashScreenViewmodelProvider.notifier);

    // 确保在 Widget 重建完成后执行
    if (!_executed) {
      logger.d("startup");
      // 确保在 Widget 重建完成后执行
      screenViewmodel.initial();
      // 标记为已执行
      _executed = true;
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StartupProgressBar(message: screenState.message, progressPercent: screenState.progressPercent),
        ),
      ),
    );
  }
}
