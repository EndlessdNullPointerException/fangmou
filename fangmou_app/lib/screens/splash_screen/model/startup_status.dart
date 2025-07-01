enum StartupStatus {
  start(message: "开始加载", progressPercent: 0.0, initializeFailed: false),
  initializeSevenZip(message: "初始化 7z 功能", progressPercent: 0.1, initializeFailed: false),
  testSevenZip(message: "测试 7z 功能", progressPercent: 0.2, initializeFailed: false),
  success(message: "成功", progressPercent: 1, initializeFailed: false),

  failure(message: "失败", progressPercent: 0, initializeFailed: true);

  // 构造方法需要用const修饰
  const StartupStatus({required this.message, required this.progressPercent, required this.initializeFailed});

  // 属性是不可变的，需要使用final修饰
  final String message;
  final double progressPercent;
  final bool initializeFailed;
}
