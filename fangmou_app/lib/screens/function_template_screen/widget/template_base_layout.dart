import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/directory_path_selector.dart';
import '../../../common_widgets/simple_content_card.dart';
import '../../../routes/app_router.dart';

typedef ResetParamsCallback = void Function(GlobalKey<FormState> formkey);
typedef ClearAllCallBack = void Function(GlobalKey<FormState> formkey);
typedef GenerateCallback = void Function(GlobalKey<FormState> formkey, bool fileGenerate, String directory);
typedef ParamFieldBuilder = Widget Function(bool isFileGenerate);

class TemplateBaseLayout extends StatefulWidget {
  final String name;

  final ParamFieldBuilder paramField;
  final Widget resultField;

  final ResetParamsCallback resetParams;
  final ClearAllCallBack clearAll;
  final GenerateCallback generate;

  const TemplateBaseLayout({
    super.key,
    required this.paramField,

    required this.name,
    required this.resultField,
    required this.resetParams,
    required this.clearAll,
    required this.generate,
  });

  @override
  State<StatefulWidget> createState() => _TemplateBaseLayoutState();
}

class _TemplateBaseLayoutState extends State<TemplateBaseLayout> {
  bool fileGenerate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController directoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return layout();
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
      Text(widget.name, style: Theme.of(context).textTheme.headlineMedium),
      SizedBox(width: 10,)
    ];
  }

  Widget layout() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(top: 55),
          child: SimpleContentCard(
            hasSingleChildScrollView: true,
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical, // 滚动方向
              physics: BouncingScrollPhysics(),
              padding: EdgeInsetsGeometry.only(right: 10, top: 0),
              child: Column(
                children: [
                  Form(
                    canPop: true,
                    key: _formKey,
                    child: Column(
                      children: [
                        widget.paramField(fileGenerate),
                        Row(
                          children: [
                            Spacer(),
                            SizedBox(width: 10),
                            ElevatedButton(onPressed: () => widget.resetParams(_formKey), child: Text("重置参数")),
                            SizedBox(width: 10),
                            ElevatedButton(onPressed: () => widget.clearAll(_formKey), child: Text("清空所有")),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => widget.generate(_formKey, fileGenerate, directoryController.text),
                              child: Text("模板生成"),
                            ),
                            SizedBox(width: 10),
                            Checkbox(
                              value: fileGenerate,
                              onChanged: (value) {
                                setState(() {
                                  fileGenerate = value!;
                                });
                              },
                            ),
                            Text("生成文件"),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Visibility(
                                  visible: fileGenerate,
                                  maintainState: true,
                                  child: DirectoryPathSelector(controller: directoryController),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  widget.resultField,
                ],
              ),
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
}
