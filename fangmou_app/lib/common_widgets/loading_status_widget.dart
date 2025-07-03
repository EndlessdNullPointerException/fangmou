import 'package:fangmou_app/routes/app_router.dart';
import 'package:flutter/material.dart';

class LoadingStatusWidget extends StatelessWidget {
  final Stream<LoadingStatusData> currentStatus;

  const LoadingStatusWidget({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingStatusData>(
      stream: currentStatus, // 传入要监听的单订阅流
      builder: (BuildContext context, AsyncSnapshot<LoadingStatusData> snapshot) {
        if (snapshot.hasError) {
          return buildDialog(LoadingStatus.error,"出现错误${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return buildDialog(LoadingStatus.error,"出现错误,无数据可用");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildDialog(LoadingStatus.loading,"等待中"); // 数据加载中
        }

        return buildDialog(snapshot.data!.loadingStatus,snapshot.data!.currentStatusDescription);
      },
    );
  }

  Widget buildDialog(LoadingStatus loadingStatus, String? currentStatusDescription) {
    return AlertDialog(
      title: Text(loadingStatus.statusMessage),
      content: Wrap(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  switch (loadingStatus) {
                    LoadingStatus.success => Icon(Icons.check_circle,size: 40,color: Colors.green,),
                    LoadingStatus.error => Icon(Icons.error,size: 40,color: Colors.red,),
                    LoadingStatus.loading => CircularProgressIndicator(
                      backgroundColor: Colors.grey.withAlpha(33),
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      strokeWidth: 5,
                    ),
                  },
                  if (loadingStatus == LoadingStatus.loading)

                  SizedBox(height: 10),
                  switch (loadingStatus) {
                    LoadingStatus.success => Text("完成"),
                    LoadingStatus.error => Text("处理失败，请退出"),
                    LoadingStatus.loading => Text("进行中,$currentStatusDescription"),
                  },
                ],
              ),
            ),
          ),
        ],
      ),

      actions: [TextButton(onPressed: () => Navigator.pop(AppRouter.context!), child: Text('确定'))],
    );
  }
}

class LoadingStatusData {
  final LoadingStatus loadingStatus;
  final String currentStatusDescription;

  const LoadingStatusData({required this.loadingStatus, required this.currentStatusDescription});
}

enum LoadingStatus {
  success(statusMessage: "已完成"),
  error(statusMessage: "失败"),
  loading(statusMessage: "进行中");

  final String statusMessage;
  const LoadingStatus({required this.statusMessage});
}
