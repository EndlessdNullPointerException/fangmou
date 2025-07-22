import 'package:fangmou_app/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_router.dart';
import '../../utils/constants/constants.dart';
import 'model/tabs.dart';

class FunctionTemplateScreen extends StatefulWidget {
  const FunctionTemplateScreen({super.key});

  @override
  State<FunctionTemplateScreen> createState() => _FunctionTemplateScreenState();
}

class _FunctionTemplateScreenState extends State<FunctionTemplateScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Tabs.values.length, vsync: this);
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
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Column(
            // mainAxisSize: MainAxisSize.min 让 Column 的高度自适应内容
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // 使用 Expanded 让 TabBar 占据所有剩余空间
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
                        tabs: Tabs.values.map((tab) => Tab(text: tab.title)).toList(),
                      ),
                    ),
                  ),
                  // 这是右侧的搜索图标按钮
                  Spacer(flex: 40),
                  Flexible(
                    flex: 30,
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
                            contentPadding: EdgeInsetsGeometry.only(left: 10),
                            constraints: BoxConstraints(maxHeight: 40),
                            filled: true,
                            hintText: "搜索模板",
                            suffixIcon: GestureDetector(onTap: () => logger.d(""), child: Icon(Icons.search)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () => logger.d(""), icon: Icon(Icons.close), tooltip: "取消搜索"),
                  SizedBox(width: 10),
                ],
              ),
              const Divider(height: 1, thickness: 1), // 添加一个分割线，UI更美观
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(top: 50),
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.only(left: 10, right: 10),
            child:
            // 使用 IndexedStack 替代 TabBarView
            IndexedStack(index: _currentIndex, children: Tabs.values.map((v) => tabBarView(v.routes)).toList()),
          ),
        ),
      ],
    );
  }

  Widget tabBarView(list) {
    return ListView.builder(
      itemBuilder:
          (context, i) => Visibility(
            visible: true,
            child: GestureDetector(
              onTap: () => AppRouter.context!.push(list[i].path),
              behavior: HitTestBehavior.opaque, // 整个 GestureDetector 包裹的区域（包括空白区）都会捕捉事件
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list[i].name,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(height: 1.1, fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Divider(),
                      Row(children: [Text("使用次数："), Text("100"), Spacer(), Text("最后使用时间：${DateTime.now().formatDateTime}")]),
                    ],
                  ),
                ),
              ),
            ),
          ),

      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
