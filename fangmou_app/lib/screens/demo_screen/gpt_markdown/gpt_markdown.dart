import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
class GptMarkdownExample extends StatefulWidget {
  const GptMarkdownExample({super.key});

  @override
  State<GptMarkdownExample> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<GptMarkdownExample> {

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(
      '''
# 10	平台适配

## 10.1	响应式布局

#### 响应式布局简介

响应式布局的核心目标是**让界面自动适配不同屏幕尺寸与方向**，确保在手机、平板、桌面等设备上均能提供最佳显示效果。Flutter 通过动态计算屏幕参数与组件约束实现这一目标。



#### 核心工具 - MediaQuery

`MediaQuery` 是用于获取设备屏幕信息的基础 API：

1. 获取屏幕尺寸：

   ```
   final screenSize = MediaQuery.of(context).size;  
   ```

2. 获取设备像素比率：

   ```
   final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);  
   ```

3. 判断当前设备的屏幕方向是否为**竖屏模式**（即高度大于宽度）：

   ```
   final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;  
   ```



#### LayoutBuilder

根据父容器约束动态构建布局：

```dart
LayoutBuilder(  
  builder: (context, constraints) {  
    if (constraints.maxWidth > 600) {  
      return DesktopLayout();  
    } else {  
      return MobileLayout();  
    }  
  },  
)  
```



#### OrientationBuilder

响应屏幕方向变化：

```dart
OrientationBuilder(  
  builder: (context, orientation) {  
    return orientation == Orientation.portrait  
        ? VerticalLayout()  
        : HorizontalLayout();  
  },  
)  
```



#### 布局切换

通过定义屏幕尺寸断点实现布局切换：

```dart
enum ScreenType { mobile, tablet, desktop }  

ScreenType getScreenType(BuildContext context) {  
  final width = MediaQuery.sizeOf(context).width;  
  if (width >= 1200) return ScreenType.desktop;  
  if (width >= 600) return ScreenType.tablet;  
  return ScreenType.mobile;  
}  

// 使用示例  
Widget build(BuildContext context) {  
  final screenType = getScreenType(context);  
  return switch(screenType) {  
    ScreenType.desktop => DesktopView(),  
    ScreenType.tablet => TabletView(),  
    ScreenType.mobile => MobileView(),  
  };  
}  
```



#### 自适应组件

###### 相对尺寸计算

```dart
Container(  
  width: MediaQuery.sizeOf(context).width * 0.8, // 占屏80%宽度  
  height: MediaQuery.sizeOf(context).height * 0.3,  
)  
```

###### 动态列数网格

```dart
GridView.builder(  
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(  
    maxCrossAxisExtent: _calculateCellSize(context), // 根据屏幕计算单元尺寸  
  ),  
  itemBuilder: ...,  
)  
```

###### 文本自适应

```dart
Text(  
  'Responsive Text',  
  style: TextStyle(  
    fontSize: _calculateFontSize(context), // 动态字体大小  
  ),  
)  
```



#### 高级响应模式

###### 主从布局（Master-Detail）

在宽屏同时显示列表与详情，窄屏分页显示：

```dart
Widget build(BuildContext context) {  
  final isWideScreen = MediaQuery.sizeOf(context).width > 800;  
  return isWideScreen  
      ? Row(  
          children: [  
            Expanded(flex: 1, child: ItemList()),  
            Expanded(flex: 2, child: ItemDetail()),  
          ],  
        )  
      : ItemListPage();  
}  
```

###### 动态导航模式

宽屏显示抽屉导航，窄屏显示底部导航栏：

```dart
Scaffold(  
  drawer: isDesktop ? null : const AppDrawer(), // 抽屉仅在移动端显示  
  bottomNavigationBar: isDesktop ? null : BottomNavBar(),  
  body: _selectedScreen,  
)  
```

---





## 10.2	Android 平台适配基础

 **SafeArea** 

来确保子控件不会被状态栏、导航栏及底部操作栏所遮挡



---



## 10.3	Android 平台适配 - 应用图标



---



## 10.4	Android 平台适配 - 自定义启动页



---



## 10.5	windows 权限获取



---


    ''',
    );
  }
}