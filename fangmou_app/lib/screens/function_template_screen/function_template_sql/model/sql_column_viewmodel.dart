import '../../../../model/sql/sql.dart';

class SqlColumnViewmodel {
  bool checked = false;
  final SqlColumn sqlColumn;

  SqlColumnViewmodel({required this.sqlColumn});

  factory SqlColumnViewmodel.initiate(DataBase dataBase) {
    switch (dataBase) {
      case DataBase.sqlLite:
        return SqlColumnViewmodel(
          sqlColumn: SqlColumn(
            columnName: "",
            dataType: DataType.textSqlLite,
            long: 0,
            defaultValue: "",
            notNull: true,
            index: Index.none,
            comment: "",
          ),
        );
      case DataBase.mySql:
        return SqlColumnViewmodel(
          sqlColumn: SqlColumn(
            columnName: "",
            dataType: DataType.varcharMySql,
            long: 0,
            defaultValue: "",
            notNull: true,
            index: Index.none,
            comment: "",
          ),
        );
      case DataBase.sqlServer:
        return SqlColumnViewmodel(
          sqlColumn: SqlColumn(
            columnName: "",
            dataType: DataType.varcharSqlServer,
            long: 0,
            defaultValue: "",
            notNull: true,
            index: Index.none,
            comment: "",
          ),
        );
    }
  }

  static List<SqlColumnViewmodel> baseColumns(DataBase database) {
    switch (database) {
      case DataBase.mySql:
        return [
          SqlColumnViewmodel.id(DataType.varcharMySql),
          SqlColumnViewmodel.deleteFlag(DataType.booleanMySql),
          SqlColumnViewmodel.createdAt(DataType.datetimeMySql),
          SqlColumnViewmodel.updatedAt(DataType.datetimeMySql),
          SqlColumnViewmodel.deletedAt(DataType.datetimeMySql),
        ];
      case DataBase.sqlServer:
        return [
          SqlColumnViewmodel.id(DataType.varcharSqlServer),
          SqlColumnViewmodel.deleteFlag(DataType.bitSqlServer),
          SqlColumnViewmodel.createdAt(DataType.datetime2SqlServer),
          SqlColumnViewmodel.updatedAt(DataType.datetime2SqlServer),
          SqlColumnViewmodel.deletedAt(DataType.datetime2SqlServer),
        ];
      case DataBase.sqlLite:
        return [
          SqlColumnViewmodel.id(DataType.textSqlLite),
          SqlColumnViewmodel.deleteFlag(DataType.integerSqlLite),
          SqlColumnViewmodel.createdAt(DataType.textSqlLite),
          SqlColumnViewmodel.updatedAt(DataType.textSqlLite),
          SqlColumnViewmodel.deletedAt(DataType.textSqlLite),
        ];
    }
  }

  static SqlColumnViewmodel id(DataType datatype) {
    return SqlColumnViewmodel(
      sqlColumn: SqlColumn(
        columnName: "id",
        dataType: datatype,
        long: 32,
        defaultValue: "",
        notNull: true,
        index: Index.pk,
        comment: "主键",
      ),
    );
  }

  static SqlColumnViewmodel deleteFlag(DataType datatype) {
    return SqlColumnViewmodel(
      sqlColumn: SqlColumn(
        columnName: "deletion_flag",
        dataType: datatype,
        long: 0,
        defaultValue: "false",
        notNull: true,
        index: Index.idx,
        comment: "删除标志",
      ),
    );
  }

  static SqlColumnViewmodel createdAt(DataType datatype) {
    return SqlColumnViewmodel(
      sqlColumn: SqlColumn(
        columnName: "created_at",
        dataType: datatype,
        long: 0,
        defaultValue: "",
        notNull: true,
        index: Index.none,
        comment: "创建时间",
      ),
    );
  }

  static SqlColumnViewmodel updatedAt(DataType datatype) {
    return SqlColumnViewmodel(
      sqlColumn: SqlColumn(
        columnName: "updated_at",
        dataType: datatype,
        long: 0,
        defaultValue: "",
        notNull: true,
        index: Index.none,
        comment: "修改时间",
      ),
    );
  }

  static SqlColumnViewmodel deletedAt(DataType datatype) {
    return SqlColumnViewmodel(
      sqlColumn: SqlColumn(
        columnName: "deleted_at",
        dataType: datatype,
        long: 0,
        defaultValue: "",
        notNull: true,
        index: Index.none,
        comment: "删除时间",
      ),
    );
  }
}
