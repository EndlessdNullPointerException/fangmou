import 'package:fangmou_app/routes/fangmou_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/directory_path_selector.dart';
import '../../../common_widgets/gadget_widget.dart';
import '../../../common_widgets/simple_content_card.dart';
import '../../../data_source/local/sql_lite/template_local.dart';
import '../../../routes/app_router.dart';
import '../../../utils/constants/constants.dart';
import '../model/tabs.dart';

typedef ResetParamsCallback = void Function(GlobalKey<FormState> formkey);
typedef ClearAllCallBack = void Function(GlobalKey<FormState> formkey);
typedef GenerateCallback = Future<void> Function(bool fileGenerate, String directory);
typedef ParamFieldBuilder = Widget Function(bool isFileGenerate);
typedef AllExpandOrCollapseCallback = void Function(bool isFileGenerate);

class TemplateBaseLayout extends StatefulWidget {
  final String id;

  final ParamFieldBuilder paramField;
  final Widget resultField;

  final ResetParamsCallback resetParams;
  final ClearAllCallBack clearAll;
  final GenerateCallback generate;
  final AllExpandOrCollapseCallback allExpandOrCollapseCallback;

  const TemplateBaseLayout({
    super.key,
    required this.paramField,
    required this.id,
    required this.resultField,
    required this.resetParams,
    required this.clearAll,
    required this.generate,
    required this.allExpandOrCollapseCallback,
  });

  @override
  State<StatefulWidget> createState() => _TemplateBaseLayoutState();
}

class _TemplateBaseLayoutState extends State<TemplateBaseLayout> {
  final templateLocal = GetIt.I.get<TemplateLocal>();

  bool fileGenerate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController directoryController = TextEditingController();

  late TemplateRoutes currentRoute;
  @override
  void initState() {
    super.initState();
    currentRoute = TemplateRoutes.values.singleWhere((item) => item.id == widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return layout();
  }

  List<Widget> toolBar() {
    return [
      IconButton(
        onPressed: () {
          AppRouter.context!.pushNamed(FangMouRoutes.functionTemplate.name);
        },
        icon: Icon(Icons.arrow_back),
      ),
      Text(currentRoute.title, style: Theme.of(context).textTheme.headlineMedium),
      Spacer(),
      Flexible(
        flex: 1,
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Visibility(
            visible: fileGenerate,
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            child: DirectoryPathSelector(controller: directoryController),
          ),
        ),
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
      SizedBox(width: 10),
      ElevatedButton(onPressed: () => widget.resetParams(_formKey), child: Text("重置参数")),
      SizedBox(width: 10),
      ElevatedButton(onPressed: () => widget.clearAll(_formKey), child: Text("清空所有")),
      SizedBox(width: 10),
      ElevatedButton(onPressed: dataCheck, child: Text("模板生成")),
      SizedBox(width: 10),
    ];
  }

  // 数据校验
  // 如果校验通过，则直接进行生成
  void dataCheck() async {
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }
    if (fileGenerate && directoryController.text.isEmpty) {
      showCustomToast("请选择路径");
      return;
    }
    try {
      await widget.generate(fileGenerate, directoryController.text);
      showCustomToast("成功", color: Colors.green);
      await templateLocal.updateById(widget.id);
    } catch (e) {
      showCustomDialog(e.toString());
      logger.e(e);
      rethrow;
    }
  }

  Widget layout() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(top: 60),
          child: SimpleContentCard(
            hasSingleChildScrollView: true,
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical, // 滚动方向
              physics: BouncingScrollPhysics(),
              padding: EdgeInsetsGeometry.only(right: 10, top: 0),
              child: Column(
                children: [
                  Form(canPop: true, key: _formKey, child: Column(children: [widget.paramField(fileGenerate)])),
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
            children: [SizedBox(height: 60, child: Row(children: toolBar())), Divider(height: 0, thickness: 3)],
          ),
        ),
        floatButton(),
      ],
    );
  }


  // region  悬浮按钮
  late double _top;
  late double _left;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 延迟初始化位置，以确保可以获取到屏幕尺寸
    if (!_isInitialized) {
      final size = MediaQuery.of(context).size;
      // 初始位置设置在右下角，并留出一些边距
      _top = size.height - 150;
      _left = size.width - 150;
      _isInitialized = true;
    }
  }

  Widget floatButton() {
    return Positioned(
      top: _top,
      left: _left,
      child: GestureDetector(
        // 当拖动更新时
        // 当拖动更新时
        onPanUpdate: (details) {
          // details.delta 包含了从上次更新到本次更新的拖动距离 (dx, dy)
          // 通过更新 _top 和 _left 的值来改变按钮的位置
          setState(() {
            _top += details.delta.dy;
            _left += details.delta.dx;
          });
        },
        child: Column(
          children: [
            FloatingActionButton(
              shape: CircleBorder(),
              mini: true,
              onPressed: () => widget.allExpandOrCollapseCallback(false),
              tooltip: "收起",
              child: Icon(Icons.arrow_drop_down),
            ),
            SizedBox(height: 5),
            FloatingActionButton(
              mini: true,
              shape: CircleBorder(),
              onPressed: () => widget.allExpandOrCollapseCallback(true),
              tooltip: "展开",
              child: Icon(Icons.arrow_drop_up),
            ),
          ],
        ),
      ),
    );
  }

  // endregion  悬浮按钮
}
