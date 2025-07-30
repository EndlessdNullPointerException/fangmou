enum DataBase {
  mySql,
  sqlServer,
  sqlLite;

  List<DataType> get dataBaseTypeList => DataType.values.where((item) => item.dataBase == this).toList();
}

enum DataType {
  // region --- SQLite 主要数据类型 (核心存储类) ---
  // SQLite 的类型系统是动态的，以下是其5个核心存储类。
  // 您在建表时使用的类型名（如 INT, VARCHAR, DATETIME）会触发对应的“类型亲和性”。

  // 亲和性: INTEGER
  integerSqlLite(name: "INTEGER", dataBase: DataBase.sqlLite),
  // 亲和性: REAL
  realSqlLite(name: "REAL", dataBase: DataBase.sqlLite),
  // 亲和性: TEXT
  textSqlLite(name: "TEXT", dataBase: DataBase.sqlLite),
  // 亲和性: BLOB
  blobSqlLite(name: "BLOB", dataBase: DataBase.sqlLite),
  // endregion

  // region --- MySQL 主要数据类型 ---

  // ** Numeric Types **
  tinyintMySql(name: "TINYINT", dataBase: DataBase.mySql),
  smallintMySql(name: "SMALLINT", dataBase: DataBase.mySql),
  mediumintMySql(name: "MEDIUMINT", dataBase: DataBase.mySql),
  intMySql(name: "INT", dataBase: DataBase.mySql),
  bigintMySql(name: "BIGINT", dataBase: DataBase.mySql),
  decimalMySql(name: "DECIMAL", dataBase: DataBase.mySql),
  floatMySql(name: "FLOAT", dataBase: DataBase.mySql),
  doubleMySql(name: "DOUBLE", dataBase: DataBase.mySql),
  booleanMySql(name: "BOOLEAN", dataBase: DataBase.mySql), // 别名，实际为 TINYINT(1)

  // ** String Types **
  charMySql(name: "CHAR", dataBase: DataBase.mySql),
  varcharMySql(name: "VARCHAR", dataBase: DataBase.mySql),
  tinytextMySql(name: "TINYTEXT", dataBase: DataBase.mySql),
  textMySql(name: "TEXT", dataBase: DataBase.mySql),
  mediumtextMySql(name: "MEDIUMTEXT", dataBase: DataBase.mySql),
  longtextMySql(name: "LONGTEXT", dataBase: DataBase.mySql),
  enumMySql(name: "ENUM", dataBase: DataBase.mySql),
  setMySql(name: "SET", dataBase: DataBase.mySql),

  // ** Date and Time Types **
  dateMySql(name: "DATE", dataBase: DataBase.mySql),
  timeMySql(name: "TIME", dataBase: DataBase.mySql),
  datetimeMySql(name: "DATETIME", dataBase: DataBase.mySql),
  timestampMySql(name: "TIMESTAMP", dataBase: DataBase.mySql),
  yearMySql(name: "YEAR", dataBase: DataBase.mySql),

  // ** Binary Types **
  binaryMySql(name: "BINARY", dataBase: DataBase.mySql),
  varbinaryMySql(name: "VARBINARY", dataBase: DataBase.mySql),
  tinyblobMySql(name: "TINYBLOB", dataBase: DataBase.mySql),
  blobMySql(name: "BLOB", dataBase: DataBase.mySql),
  mediumblobMySql(name: "MEDIUMBLOB", dataBase: DataBase.mySql),
  longblobMySql(name: "LONGBLOB", dataBase: DataBase.mySql),

  // ** Other Types **
  jsonMySql(name: "JSON", dataBase: DataBase.mySql),
  geometryMySql(name: "GEOMETRY", dataBase: DataBase.mySql),

  // endregion

  // region --- SQL Server 主要数据类型 ---

  // ** Exact Numeric Types **
  bitSqlServer(name: "BIT", dataBase: DataBase.sqlServer),
  tinyintSqlServer(name: "TINYINT", dataBase: DataBase.sqlServer),
  smallintSqlServer(name: "SMALLINT", dataBase: DataBase.sqlServer),
  intSqlServer(name: "INT", dataBase: DataBase.sqlServer),
  bigintSqlServer(name: "BIGINT", dataBase: DataBase.sqlServer),
  decimalSqlServer(name: "DECIMAL", dataBase: DataBase.sqlServer),
  numericSqlServer(name: "NUMERIC", dataBase: DataBase.sqlServer),
  moneySqlServer(name: "MONEY", dataBase: DataBase.sqlServer),
  smallmoneySqlServer(name: "SMALLMONEY", dataBase: DataBase.sqlServer),

  // ** Approximate Numeric Types **
  floatSqlServer(name: "FLOAT", dataBase: DataBase.sqlServer),
  realSqlServer(name: "REAL", dataBase: DataBase.sqlServer),

  // ** Date and Time Types **
  dateSqlServer(name: "DATE", dataBase: DataBase.sqlServer),
  timeSqlServer(name: "TIME", dataBase: DataBase.sqlServer),
  datetimeSqlServer(name: "DATETIME", dataBase: DataBase.sqlServer),
  datetime2SqlServer(name: "DATETIME2", dataBase: DataBase.sqlServer),
  smalldatetimeSqlServer(name: "SMALLDATETIME", dataBase: DataBase.sqlServer),
  datetimeoffsetSqlServer(name: "DATETIMEOFFSET", dataBase: DataBase.sqlServer),

  // ** Character String Types **
  charSqlServer(name: "CHAR", dataBase: DataBase.sqlServer),
  varcharSqlServer(name: "VARCHAR", dataBase: DataBase.sqlServer),

  // ** Unicode Character String Types **
  ncharSqlServer(name: "NCHAR", dataBase: DataBase.sqlServer),
  nvarcharSqlServer(name: "NVARCHAR", dataBase: DataBase.sqlServer),

  // ** Binary Types **
  binarySqlServer(name: "BINARY", dataBase: DataBase.sqlServer),
  varbinarySqlServer(name: "VARBINARY", dataBase: DataBase.sqlServer),

  // ** Other Types **
  uniqueidentifierSqlServer(name: "UNIQUEIDENTIFIER", dataBase: DataBase.sqlServer),
  xmlSqlServer(name: "XML", dataBase: DataBase.sqlServer),
  geographySqlServer(name: "GEOGRAPHY", dataBase: DataBase.sqlServer),
  geometrySqlServer(name: "GEOMETRY", dataBase: DataBase.sqlServer),
  rowversionSqlServer(name: "ROWVERSION", dataBase: DataBase.sqlServer); // 用于版本控制，不是时间戳
  // endregion

  const DataType({required this.name, required this.dataBase});

  final String name;
  final DataBase dataBase;
}

enum Index {
  pk(name: "PRIMARY KEY"),
  uk(name: "UNIQUE"),
  idx(name: "INDEX"),
  none(name: "");

  const Index({required this.name});
  final String name;
}

class SqlColumn {
  String columnName;
  DataType dataType;
  int long;
  String defaultValue;
  bool notNull;
  Index index;
  String comment;

  SqlColumn({
    required this.columnName,
    required this.dataType,
    required this.long,
    required this.defaultValue,
    required this.notNull,
    required this.index,
    required this.comment,
  });
}
