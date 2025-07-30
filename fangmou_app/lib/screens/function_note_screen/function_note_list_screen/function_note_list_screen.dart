import 'package:fangmou_app/screens/function_note_screen/function_note_list_screen/function_note_list_screen_state.dart';
import 'package:fangmou_app/screens/function_note_screen/function_note_list_screen/model/pop_option.dart';
import 'package:fangmou_app/screens/function_note_screen/function_note_list_screen/model/sort_method.dart';
import 'package:fangmou_app/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/when_status_widget.dart';
import 'function_note_list_screen_viewmodel.dart';

class FunctionNoteListScreen extends ConsumerStatefulWidget {
  const FunctionNoteListScreen({super.key});

  @override
  ConsumerState<FunctionNoteListScreen> createState() => _FunctionNoteListScreenState();
}

class _FunctionNoteListScreenState extends ConsumerState<FunctionNoteListScreen> {
  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(functionNoteListScreenViewmodelProvider);
    final screenViewmodel = ref.watch(functionNoteListScreenViewmodelProvider.notifier);
    return screenState.when(
      data: (screenState) => layout(screenState, screenViewmodel),
      error: whenError,
      loading: whenLoading,
    );
  }

  Widget layout(FunctionNoteListScreenState screenState, FunctionNoteListScreenViewmodel screenViewmodel) {
    return Stack(
      children: [
        Positioned(
          top: 0, // 定位到顶部
          left: 0,
          right: 0,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child:
                    screenState.editMode
                        ?
                        // 编辑模式工具栏
                        editBar(screenState, screenViewmodel)
                        :
                        // 浏览模式工具栏
                        viewBar(screenState, screenViewmodel), // 你的子控件
              ),
              Divider(height: 0, thickness: 3),
            ],
          ),
        ),
        // 主页面内容
        Padding(
          padding: EdgeInsets.only(top: 55), // 调整边距
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // 滚动方向
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: list(screenState, screenViewmodel),
            ), // 需滚动的内容
          ),
        ),
        // region 浮动按钮
        floatButton(screenState, screenViewmodel),
        // endregion
      ],
    );
  }

  Widget editBar(FunctionNoteListScreenState screenState, FunctionNoteListScreenViewmodel screenViewmodel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(flex: 1),
        Checkbox(value: screenState.selectedAll, onChanged: (value) => screenViewmodel.selectAll(value ?? false)),
        Text("全选"),
        Spacer(flex: 1),
        Flexible(
          flex: 2,
          child: FractionallySizedBox(
            widthFactor: 1.0, // 占满 Flexible 分配的空间
            child: MaterialButton(
              onPressed: screenViewmodel.reverseSelected,
              padding: const EdgeInsets.all(0),
              elevation: 3,
              color: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text("反选"),
            ),
          ),
        ),
        Spacer(flex: 45),
        Flexible(
          flex: 4,
          child: FractionallySizedBox(
            widthFactor: 1.0, // 占满 Flexible 分配的空间
            child: MaterialButton(
              onPressed: screenViewmodel.deleteSelected,
              padding: const EdgeInsets.all(0),
              textColor: Colors.red,
              elevation: 3,
              color: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text("删除选中"),
            ),
          ),
        ),
        Spacer(flex: 1),
        Flexible(
          flex: 4,
          child: FractionallySizedBox(
            widthFactor: 1.0, // 占满 Flexible 分配的空间
            child: MaterialButton(
              onPressed: screenViewmodel.exitEditMode,
              padding: const EdgeInsets.all(0),
              textColor: Colors.red,
              elevation: 3,
              color: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text("退出管理"),
            ),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }

  Widget viewBar(FunctionNoteListScreenState screenState, FunctionNoteListScreenViewmodel screenViewmodel) {
    return Row(
      children: [
        Spacer(flex: 1),
        Flexible(
          flex: 12,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent, // 获得焦点后的高亮
            ),
            child: DropdownButton<SortMethod>(
              value: screenState.sortBy,
              isExpanded: true,
              elevation: 0,
              isDense: true,
              underline: Divider(height: 0),
              items:
                  SortMethod.values
                      .map((item) => DropdownMenuItem<SortMethod>(value: item, child: Text(item.message)))
                      .toList(),
              onChanged: (v) => screenViewmodel.resort(v!),
            ),
          ),
        ),
        Spacer(flex: 20),
        Flexible(
          flex: 34,
          child: FractionallySizedBox(
            widthFactor: 1.0, // 占满 Flexible 分配的空间
            child: Theme(
              data: Theme.of(context).copyWith(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent, // 获得焦点后的高亮
              ),
              child: TextField(
                style: const TextStyle(color: Colors.blue, height: 2),
                controller: screenState.keyword,
                onSubmitted: (v) => screenViewmodel.search(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                  fillColor: Colors.transparent,
                  isDense: true,
                  contentPadding: EdgeInsetsGeometry.only(left: 10),
                  constraints: BoxConstraints(maxHeight: 40),
                  filled: true,
                  hintText: "搜索笔记",
                  suffixIcon: GestureDetector(onTap: () => screenViewmodel.search(), child: Icon(Icons.search)),
                ),
              ),
            ),
          ),
        ),
        Spacer(flex: 33),
        IconButton(onPressed: screenViewmodel.search, icon: Icon(Icons.refresh)),
        PopupMenuButton<PopOption>(
          itemBuilder:
              (context) =>
                  PopOption.values
                      .map(
                        (item) => PopupMenuItem<PopOption>(
                          value: item,
                          child: Wrap(spacing: 10, children: <Widget>[Text(item.text)]),
                        ),
                      )
                      .toList(),
          offset: const Offset(0, 40),
          onSelected: (e) => screenViewmodel.onPopupMenuSelected(e),
        ),
      ],
    );
  }

  Widget list(FunctionNoteListScreenState screenState, FunctionNoteListScreenViewmodel screenViewmodel) {
    return ListView.builder(
      itemCount: screenState.noteMessageList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder:
          (context, i) => GestureDetector(
            onTap: () => screenViewmodel.gotoDetail(screenState.noteMessageList[i].id),
            onLongPress: () => screenViewmodel.intoEditMode(selectedIndex: i),
            behavior: HitTestBehavior.opaque, // 整个 GestureDetector 包裹的区域（包括空白区）都会捕捉事件
            child: Card(
              elevation: 5,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 控制内部对齐方式
                    Row(
                      children: [
                        Text(
                          screenState.noteMessageList[i].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(height: 1.1, fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Spacer(),
                        Visibility(
                          visible: screenState.editMode,
                          maintainSize: true, // 保留占位空间
                          maintainAnimation: true, // 如果需要保留动画可以设置为true
                          maintainState: true, // 如果需要保留状态可以设置为true
                          child: Checkbox(
                            value: screenState.selectedList[i],
                            onChanged:
                                (checkState) =>
                                    screenViewmodel.selectCheckbox(checkState, i, screenState.noteMessageList[i]),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      // 添加 /n/n 可以保证 Text 的高度恒定为三行
                      '${screenState.noteMessageList[i].excerpt}\n\n',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.1, fontSize: 20),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text("最后更新时间：${screenState.noteMessageList[i].lastUpdateAt.formatDateTime}"),
                        Spacer(),
                        Text("创建时间：${screenState.noteMessageList[i].createdAt.formatDateTime}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // region <- Logic:悬浮按钮 ->
  // 定义悬浮按钮控制
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

  Widget floatButton(FunctionNoteListScreenState screenState, FunctionNoteListScreenViewmodel screenViewmodel) {
    return Positioned(
      top: _top,
      left: _left,
      child: GestureDetector(
        // 当拖动更新时
        // 当拖动更新时
        onPanUpdate: (details) {
          // details.delta 包含了从上次更新到本次更新的拖动距离 (dx, dy)
          // 我们通过更新 _top 和 _left 的值来改变按钮的位置
          setState(() {
            _top += details.delta.dy;
            _left += details.delta.dx;
          });
        },
        child: FloatingActionButton(onPressed: screenViewmodel.addNote, child: const Icon(Icons.add)),
      ),
    );
  }

  // endregion <- Logic:悬浮按钮 ->
}
