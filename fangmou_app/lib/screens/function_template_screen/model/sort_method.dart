enum SortMethod {
  lastDesc(name:"最后使用时间降序"),
  lastAsc(name:"最后使用时间升序"),
  timesDesc(name:"使用次数降序"),
  timesAsc(name:"使用次数升序"),
  titleDesc(name:"标题降序"),
  titleAsc(name:"标题升序");

  const SortMethod({required this.name});
  final String name;
}
