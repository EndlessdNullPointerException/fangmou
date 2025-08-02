import 'package:fangmou_app/screens/function_value_screen/widget/name_generator.dart';
import 'package:fangmou_app/screens/function_value_screen/widget/uuid_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './function_value_screen_viewmodel.dart';
import 'function_value_screen_state.dart';
import 'model/values.dart';

class FunctionValueScreen extends ConsumerStatefulWidget {
  const FunctionValueScreen({super.key});

  @override
  ConsumerState<FunctionValueScreen> createState() => _FunctionValueScreenState();
}

class _FunctionValueScreenState extends ConsumerState<FunctionValueScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: Values.values.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(functionValueScreenViewmodelProvider);
    final screenViewmodel = ref.watch(functionValueScreenViewmodelProvider.notifier);

    return layout(screenState, screenViewmodel);
  }

  Widget layout(FunctionValueScreenState screenState, FunctionValueScreenViewmodel screenViewmodel) {
    return Stack(
      children: [
        Positioned(top: 0, left: 0, right: 0, child: toolBar(screenState, screenViewmodel)),
        Padding(padding: EdgeInsetsGeometry.only(top: 55), child: body(screenState, screenViewmodel)),
      ],
    );
  }

  Widget toolBar(FunctionValueScreenState screenState, FunctionValueScreenViewmodel screenViewmodel) {
    return Column(
      // mainAxisSize: MainAxisSize.min 让 Column 的高度自适应内容
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Spacer(),
            Flexible(
              flex: 30,
              child: FractionallySizedBox(
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.blue,
                  indicatorWeight: 3,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.orangeAccent,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  onTap: null,
                  tabs: Values.values.map((value) => Tab(text: value.title)).toList(),
                ),
              ),
            ),
            // 这是右侧的搜索图标按钮
            Spacer(),
          ],
        ),
        const Divider(height: 1, thickness: 1), // 添加一个分割线，UI更美观
      ],
    );
  }

  Widget body(FunctionValueScreenState screenState, FunctionValueScreenViewmodel screenViewmodel) {
    return IndexedStack(index: _currentIndex,children: [
      UuidGenerator(),NameGenerator(),
    ],);
  }
}
