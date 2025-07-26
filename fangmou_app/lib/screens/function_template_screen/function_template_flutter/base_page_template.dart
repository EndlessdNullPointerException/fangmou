import 'dart:io';

import 'package:fangmou_app/common_widgets/directory_path_selector.dart';
import 'package:fangmou_app/common_widgets/simple_content_card.dart';
import 'package:fangmou_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../widget/copyable_field.dart';

const String templateScreen = '''
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class {{pageName}} extends ConsumerStatefulWidget {
  const {{pageName}}({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _{{pageName}}State();
}

class _{{pageName}}State extends ConsumerState<{{pageName}}> {
  @override
  Widget build(BuildContext context) {
    {{screen.model}}
    {{screen.viewmodel}}
    return layout();
  }

  Widget layout() {
    return Container();
  }
}
''';
const String templateState = '''

part "{{directory}}.g.dart"

@riverpod
class {{pageName}}Viewmodel extends _\${{pageName}}Viewmodel{
  
  @override
  {{type}} build({{params}}){
    return 
  }
}
''';
const String templateViewmodel = '''
class {{pageName}}State {

{{field}}

  {{pageName}}State({{field.constructor}});
  {{pageName}}State.initiate():{{field.initiate}};
  {{pageName}}State copyWith({{field.copyWith.Params}}){
    return {{pageName}}State({{field.copyWith.values}});
  }
}
''';

class BasePageTemplateScreen extends ConsumerStatefulWidget {
  final FangMouGoRoute route;
  const BasePageTemplateScreen({super.key, required this.route});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BasePageTemplateScreenState();
}

class _BasePageTemplateScreenState extends ConsumerState<BasePageTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return layout();
  }

  final TextEditingController pageName = TextEditingController();
  final TextEditingController templateScreenController = TextEditingController();
  final TextEditingController directoryController = TextEditingController();
  bool fileGenerate = false;

  Widget layout() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(top: 55),
          child: SimpleContentCard(
            content: Column(
              children: [
                TextField(
                  controller: pageName,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    labelText: 'pageName',
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Checkbox(
                      value: fileGenerate,
                      onChanged: (value) {
                        logger.d(value);
                        setState(() {
                          fileGenerate = value!;
                        });
                      },
                    ),
                    Text("是否生成文件"),
                    Spacer(flex: 1),
                    Flexible(
                      flex: 2,
                      child: FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Visibility(
                          visible: fileGenerate,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          maintainSemantics: true,
                          child: DirectoryPathSelector(controller: directoryController),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(onPressed: generate, child: Text("生成")),
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: resetParams, child: Text("重置")),
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: clearAll, child: Text("清空")),
                    Spacer(),
                  ],
                ),
                Divider(),
                CopyableField(controller: templateScreenController),
              ],
            ),
          ),
        ),
        Positioned(
          // 定位到顶部
          top: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [SizedBox(height: 50, child: Row(children: toolBar())), Divider(height: 0, thickness: 3)],
          ),
        ),
      ],
    );
  }

  List<Widget> toolBar() {
    return [
      MaterialButton(
        onPressed: () {
          AppRouter.context!.pop();
        },
        child: Icon(Icons.arrow_back),
      ),
      Spacer(),
      Text(widget.route.name!,style: Theme.of(AppRouter.context!).textTheme.headlineMedium),
      SizedBox(width: 10,)
    ];
  }

  // region <- Functions: 生成代码方法 ->

  Future<void> generate() async {
    String result0 = "";

    // region <- Logic: 生成可复制文本 ->
    result0 = templateScreenGenerator();
    // endregion <- Logic: 生成可复制文本->

    // region <- Logic: 生成文件->
    if (fileGenerate) {
      if (directoryController.text.isEmpty) {
        showCustomDialog("请选择路径");
        return;
      }

      try {
        var file = File("${directoryController.text}/fileName.dart");
        await file.writeAsString(result0);
      } catch (e) {
        logger.d(e);
      }
    }

    // endregion <- Logic:生成文件 ->
  }

  void resetParams() {}

  void clearAll() {
    resetParams();
  }

  String templateScreenGenerator() {
    String result = "";
    result = templateScreen.replaceAll("{{pageName}}", pageName.text);
    return result;
  }

  String templateScreenStateGenerator() {
    String result = "";

    return result;
  }

  String templateViewmodelGenerator() {
    String result = "";
    return result;
  }

  // endregion <- Functions: 生成代码方法 ->
}
