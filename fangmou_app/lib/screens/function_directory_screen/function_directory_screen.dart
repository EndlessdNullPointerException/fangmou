import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/DirectoryPathSelector.dart';
import 'function_directory_screen_viewmodel.dart';

class FunctionDirectoryScreen extends ConsumerWidget {
  // 定义 Provider
  const FunctionDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(functionDirectoryScreenViewmodelProvider);
    var screenViewmodel = ref.watch(functionDirectoryScreenViewmodelProvider.notifier);

    return Column(
      children: [
        SizedBox(height: 20), // 垂直间距
        SizedBox(height: 20), // 垂直间距
        DirectoryPathSelector(controller: screenState.pathController),
        SizedBox(height: 20), // 垂直间距
        ElevatedButton(child: Text("开始"), onPressed: () => {screenViewmodel.startPathProcess(ref)}),
        SizedBox(height: 20), // 垂直间距
      ],
    );
  }
}
