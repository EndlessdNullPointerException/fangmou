import 'package:fangmou_app/screens/function_decompress_screen/widget/password_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/DirectoryPathSelector.dart';
import '../../common_widgets/gadget_widget.dart';
import '../../utils/constants/constants.dart';
import 'function_decompress_screen_viewmodel.dart';

class FunctionDecompressScreen extends ConsumerWidget {
  const FunctionDecompressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d("FunctionDecompressScreen build");

    var screenState = ref.watch(functionDecompressScreenViewModelProvider);
    var screenViewmodel = ref.watch(functionDecompressScreenViewModelProvider.notifier);
    return switch (screenState) {
      // 数据加载成功
      AsyncData(value: final state) => staticWidget(screenViewmodel, {
        "directoryPathSelector": DirectoryPathSelector(controller: state.pathController),
        "passwordList": PasswordItemWidget(deleteCallBack: screenViewmodel.deletePasswordItem, passwordControllerList: state.passwordControllerList),
        "decompressDescendantFolder": Checkbox(
          value: state.decompressDescendantFolder,
          onChanged: (bool? value) {
            screenViewmodel.changeDecompressDescendantFolder(value);
          },
        ),
        "decompressAllTypeFile": Checkbox(
          value: state.decompressAllTypeFile,
          onChanged: (bool? value) {
            screenViewmodel.changeDecompressAllTypeFile(value);
          },
        ),
        "deleteOriginFile": Checkbox(
          value: state.deleteOriginFile,
          onChanged: (bool? value) {
            screenViewmodel.changeDeleteOriginFile(value);
          },
        ),
      }),
      _ => staticWidget(screenViewmodel, {
        "directoryPathSelector": DirectoryPathSelector(controller: TextEditingController()),
        "passwordList": Text("获取数据中"),
        "decompressDescendantFolder": Checkbox(value: false, onChanged: (bool? value) {}),
        "decompressAllTypeFile": Checkbox(value: false, onChanged: (bool? value) {}),
        "deleteOriginFile": Checkbox(value: false, onChanged: (bool? value) {}),
      }),
    };
  }

  Widget staticWidget(FunctionDecompressScreenViewModel screenViewmodel, Map<String, Widget> dynamicWidgets) {
    return Column(
      children: [
        dynamicWidgets["directoryPathSelector"]!,
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dynamicWidgets["decompressDescendantFolder"]!,
            Text("多级解压"),
            SizedBox(width: 10),
            dynamicWidgets["deleteOriginFile"]!,
            Text("解压成功后，删除源压缩文件"),
            dynamicWidgets["decompressAllTypeFile"]!,
            Text("尝试解压所有类型文件"),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: () => {showLoadingDialog(screenViewmodel.decompress())}, child: Text("开始解压")),
        SizedBox(height: 20),
        Row(
          children: [
            Text("解压密码："),
            Spacer(),
            ElevatedButton(onPressed: screenViewmodel.addPasswordItem, child: Text("新增密码项")),
            SizedBox(width: 10),
            ElevatedButton(onPressed: screenViewmodel.saveDecompressPasswordLocal, child: Text("保存密码")),
            SizedBox(width: 10),
            ElevatedButton(onPressed: screenViewmodel.getDecompressPasswordLocal, child: Text("从本地重新获取密码")),
          ],
        ),
        dynamicWidgets["passwordList"]!,
      ],
    );
  }
}
