import 'package:fangmou_app/common_widgets/fangmou_standard_widget.dart';
import 'package:fangmou_app/common_widgets/gadget_widget.dart';
import 'package:fangmou_app/utils/data_generator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UuidGenerator extends StatefulWidget {
  const UuidGenerator({super.key});

  @override
  State<StatefulWidget> createState() => _UuidGeneratorState();
}

class _UuidGeneratorState extends State<UuidGenerator> {
  final TextEditingController controller = TextEditingController(text: "1");

  List<TextEditingController> resultList = [];

  @override
  void initState() {
    super.initState();
    generateUuid();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: SingleChildScrollView(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          children: [
            Row(
              children: [
                fangmouStandardTextField(
                  flex: 10,
                  controller: controller,
                  labelText: "数量",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                ElevatedButton(onPressed: generateUuid, child: Text("生成")),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: copyAll, child: Text("复制全部")),
            SizedBox(height: 10),
            idList(),
          ],
        ),
      ),
    );
  }

  Widget idList() {
    return ListView.builder(
      itemCount: resultList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                fangmouStandardTextField(flex: 30, controller: resultList[index]),
                IconButton(onPressed: () => copyUuid(index), icon: Icon(Icons.copy)),
                Spacer(flex: 1),
              ],
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  generateUuid() {
    setState(() {
      resultList.clear();
      for (int i = 0; i < int.parse(controller.text); i++) {
        resultList.add(TextEditingController(text: generateUuid32()));
      }
    });
  }

  void copyAll() {
    StringBuffer result = StringBuffer();

    for (int i = 0; i < int.parse(controller.text); i++) {
      result.write("${resultList[i].text}\n");
    }

    Clipboard.setData(ClipboardData(text: result.toString()));

    showCustomToast("成功", color: Colors.green);
  }

  void copyUuid(int index) {
    Clipboard.setData(ClipboardData(text: resultList[index].text));
  }
}
