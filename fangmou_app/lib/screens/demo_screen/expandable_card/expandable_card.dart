import 'package:flutter/material.dart';

class ExpandableCardScreen extends StatefulWidget {
  const ExpandableCardScreen({super.key});

  @override
  State<ExpandableCardScreen> createState() => _ExpandableCardScreenState();
}

class _ExpandableCardScreenState extends State<ExpandableCardScreen> {
  // 模拟一些列表数据
  final List<String> _cardTitles = ['卡片 A - 个人信息', '卡片 B - 订单详情', '卡片 C - 系统设置'];

  // 1. 新的状态模型：使用 List<bool> 来管理每个卡片的展开状态
  late List<bool> _isExpandedList;

  @override
  void initState() {
    super.initState();
    // 2. 初始化状态列表，默认所有卡片都是折叠的
    _isExpandedList = List<bool>.filled(_cardTitles.length, false);
  }

  // 3. “全部展开”的逻辑
  void _expandAll() {
    setState(() {
      // 将列表中的所有值都设置为 true
      _isExpandedList = List<bool>.filled(_cardTitles.length, true);
    });
  }

  // 4. “全部折叠”的逻辑
  void _collapseAll() {
    setState(() {
      // 将列表中的所有值都设置为 false
      _isExpandedList = List<bool>.filled(_cardTitles.length, false);
    });
  }

  // 5. 单个卡片独立控制的逻辑
  void _toggleCard(int index) {
    setState(() {
      // 只改变被点击卡片对应索引的布尔值
      _isExpandedList[index] = !_isExpandedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('列表状态管理 (覆盖模式)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 外部统一控制按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _expandAll, child: const Text('全部展开')),
                ElevatedButton(onPressed: _collapseAll, child: const Text('全部折叠')),
              ],
            ),
            const SizedBox(height: 20),

            // 使用 ListView.builder 来动态构建卡片列表
            Expanded(
              child: ListView.builder(
                itemCount: _cardTitles.length,
                itemBuilder: (context, index) {
                  return ExpandableCard(
                    title: _cardTitles[index],
                    // 关键逻辑 1: 将对应索引的状态传递给子组件
                    isExpanded: _isExpandedList[index],
                    // 关键逻辑 2: 传递一个只处理对应索引的回调函数
                    onToggle: () => _toggleCard(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 子组件：一个可展开的卡片
class ExpandableCard extends StatelessWidget {
  // 从父组件接收的属性
  final String title;
  final bool isExpanded; // 接收当前是否展开的状态
  final VoidCallback onToggle; // 接收状态切换的回调函数

  const ExpandableCard({super.key, required this.title, required this.isExpanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // 内部事件：点击 ListTile 来触发状态改变
          ListTile(
            title: Text(title),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            // 当用户点击时，执行父组件传来的回调函数
            onTap: onToggle,
          ),
          // 根据从父组件接收的 isExpanded 值来决定是否显示内容
          Visibility(
            visible: isExpanded,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade200,
              child: const Text('这是卡片的详细内容，可以被内部和外部事件控制显示和隐藏。'),
            ),
          ),
        ],
      ),
    );
  }
}
