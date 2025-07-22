import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../../../common_widgets/when_status_widget.dart';
import 'function_note_detail_screen_state.dart';
import 'function_note_detail_screen_viewmodel.dart';

class FunctionNoteDetailScreen extends ConsumerWidget {
  final String id;
  const FunctionNoteDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(functionNoteDetailScreenViewmodelProvider(id));
    var screenViewmodel = ref.read(functionNoteDetailScreenViewmodelProvider(id).notifier);

    return screenState.when(
      data:
          (value) =>
              layout(context: context, screenState: value, screenViewmodel: screenViewmodel, dynamicWidgetMap: {}),
      loading: () => whenLoading(),
      error: (error, stack) => whenError(error),
    );
  }

  Widget layout({
    required BuildContext context,
    required FunctionNoteDetailScreenState screenState,
    required FunctionNoteDetailScreenViewmodel screenViewmodel,
    Map<String, Widget>? dynamicWidgetMap,
  }) {
    return Stack(
      children: [
        Positioned(
          top: 0, // 定位到顶部
          left: 0,
          right: 0,
          child: Column(
            children: [
              Row(
                children:
                    screenState.editMode
                        ? editToolBar(screenState, screenViewmodel)
                        : viewToolBar(screenState, screenViewmodel),
              ),
              Divider(height: 0),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 55), // 调整边距
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // 滚动方向
            physics: BouncingScrollPhysics(), // iOS风格弹性滚动
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Card(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Column(
                    children: [
                      screenState.editMode
                          ? editTitle(context, screenState, screenViewmodel)
                          : viewTitle(context, screenState, screenViewmodel),
                      Divider(),
                      screenState.editMode
                          ? editMain(context, screenState, screenViewmodel)
                          : viewMain(context, screenState, screenViewmodel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> editToolBar(
    FunctionNoteDetailScreenState screenState,
    FunctionNoteDetailScreenViewmodel screenViewmodel,
  ) {
    return [
      MaterialButton(onPressed: () => screenViewmodel.back(), child: Icon(Icons.arrow_back)),
      Spacer(),
      MaterialButton(onPressed: screenState.didAlter ? () => screenViewmodel.save() : null, child: Text("保存")),
      MaterialButton(onPressed: () => screenViewmodel.toViewMode(), child: Text("退出编辑")),
    ];
  }

  List<Widget> viewToolBar(
    FunctionNoteDetailScreenState screenState,
    FunctionNoteDetailScreenViewmodel screenViewmodel,
  ) {
    return [
      MaterialButton(onPressed: () => screenViewmodel.back(), child: Icon(Icons.arrow_back)),
      Spacer(),
      MaterialButton(onPressed: () => screenViewmodel.toEditMode(), child: Text("编辑")),
    ];
  }

  Widget editTitle(
    BuildContext context,
    FunctionNoteDetailScreenState screenState,
    FunctionNoteDetailScreenViewmodel screenViewmodel,
  ) {
    return TextField(
      controller: screenState.editTitle,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        hintText: "标题",
        hintStyle: TextStyle(
          color: Colors.grey[400], // 使用浅灰色
        ),
      ),
      maxLines: 1,
    );
  }

  Widget editMain(
    BuildContext context,
    FunctionNoteDetailScreenState screenState,
    FunctionNoteDetailScreenViewmodel screenViewmodel,
  ) {
    return TextField(
      controller: screenState.editMain,
      onChanged: screenViewmodel.changed,
      decoration: InputDecoration(
        hintText: "正文...",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400], // 使用浅灰色
        ),
      ),
      maxLines: null,
    );
  }

  Widget viewTitle(
    BuildContext context,
    FunctionNoteDetailScreenState screenState,
    FunctionNoteDetailScreenViewmodel screenViewmodel,
  ) {
    return Text(screenState.noteBasicMessage.title, style: Theme.of(context).textTheme.headlineLarge);
  }

  Widget viewMain(
    BuildContext context,
    FunctionNoteDetailScreenState screenState,
    FunctionNoteDetailScreenViewmodel screenViewmodel,
  ) {
    return GptMarkdown(screenState.noteMain.main, style: Theme.of(context).textTheme.bodyLarge);
  }
}
