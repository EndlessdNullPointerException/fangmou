extension DateTimeExtension on DateTime {
  String get formatDateTime {
    // 补零函数：确保数字为两位数
    String pad(int n) => n.toString().padLeft(2, '0');

    return '${[
      year, // 年（四位数）
      pad(month), // 月（补零）
      pad(day), // 日（补零）
    ].join('.')} ${[
      pad(hour), // 时（24小时制，补零）
      pad(minute), // 分（补零）
      pad(second), // 秒（补零）
    ].join(':')}'; // 用冒号连接时间
  }
}
