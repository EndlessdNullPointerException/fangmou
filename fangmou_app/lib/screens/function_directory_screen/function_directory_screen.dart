import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/DirectoryPathSelector.dart';
import '../../common_widgets/gadget_widget.dart';
import 'function_directory_screen_viewmodel.dart';
import 'model/process_mode.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(value: ProcessMode.manga, groupValue: screenState.processMode, onChanged: screenViewmodel.changeProcessMode),
            Text("漫画模式"),
            SizedBox(width: 10),
            Radio(value: ProcessMode.photography, groupValue: screenState.processMode, onChanged: screenViewmodel.changeProcessMode),
            Text("写真模式"),
          ],
        ),
        ElevatedButton(child: Text("开始"), onPressed: () => {showLoadingDialog(screenViewmodel.startPathProcess())}),
        SizedBox(height: 20), // 垂直间距
      ],
    );
  }
}
