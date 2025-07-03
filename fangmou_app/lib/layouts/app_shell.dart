// 导航栏作为根容器，管理路由和子页面
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routes/app_router.dart';
import 'CustomAppBar/CustomAppBar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity, // 关键行
        child: CustomAppBar(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical, // 滚动方向
            physics: BouncingScrollPhysics(), // iOS风格弹性滚动
            child: Padding(padding: EdgeInsets.all(20), child: child), // 需滚动的内容
          ),
            routeItemList: AppRouter.routeItemList,
        ),
      )
    );
  }
}

/// 全局进度条实现初版
/// 主要使用 AbsorbPointer() 和 Position.fill 实现
///
/// 通过     ref.read(AppShell.waitingProvider.notifier).state = true; 开启进度条
/// 通过     ref.read(AppShell.progressStateProvider.notifier).state = 0.001; 设置进度
/// 通过     ref.read(AppShell.waitingProvider.notifier).state = false; 关闭进度条
/// 存在问题，使用一次后 AbsorbPointer() 不会自动失效
// class AppShell extends ConsumerWidget {
//   final Widget child;
//   const AppShell({super.key, required this.child});
//
//   static final StateProvider<bool> waitingProvider = StateProvider<bool>((ref) => false);
//
//   static final StateProvider<double> progressStateProvider = StateProvider<double>((ref) => 0);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isWaiting = ref.watch(waitingProvider);
//     final progressValue = ref.watch(progressStateProvider);
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           AbsorbPointer(
//             absorbing: isWaiting,
//             child: CustomAppBar(
//               body: SingleChildScrollView(
//                 scrollDirection: Axis.vertical, // 滚动方向
//                 physics: BouncingScrollPhysics(), // iOS风格弹性滚动
//                 child: Center(child: Padding(padding: EdgeInsets.all(20), child: child)), // 需滚动的内容
//               ),
//             ),
//           ),
//           if (isWaiting)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black54,
//                 child:
//                     progressValue > 0
//                         ? Center(
//                           child: Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(width: 50, height: 50, child: CircularProgressIndicator(value: progressValue, strokeWidth: 4)),
//                                 SizedBox(height: 10),
//                                 Text('已完成 ${(progressValue * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18)),
//                               ],
//                             ),
//                           ),
//                         )
//                         : Container(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
