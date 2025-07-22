enum SortMethod {
  titleAsc(message: "标题升序", field: "title", direction: "ASC"),
  titleDesc(message: "标题降序", field: "title", direction: "DESC"),
  createTimeAsc(message: "创建时间升序", field: "created_at", direction: "ASC"),
  createTimeDesc(message: "创建时间降序", field: "created_at", direction: "DESC"),
  updateTimeAsc(message: "最后更新时间升序", field: "last_update_at", direction: "ASC"),
  updateTimeDesc(message: "最后更新时间降序", field: "last_update_at", direction: "DESC");

  const SortMethod({required this.message, required this.field, required this.direction});

  final String message;
  final String field;
  final String direction;
}
