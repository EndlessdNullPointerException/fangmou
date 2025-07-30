import '../../../../model/sql/sql.dart';

class SqlColumnModel {
  bool checked = false;
  final SqlColumn sqlColumn;

  SqlColumnModel({required this.sqlColumn});

  factory SqlColumnModel.initiate(DataBase dataBase) {
    switch (dataBase) {
      case DataBase.sqlLite:
        return SqlColumnModel(
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
        return SqlColumnModel(
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
        return SqlColumnModel(
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

  static List<SqlColumnModel> baseColumns(DataBase database) {
    switch (database) {
      case DataBase.mySql:
        return [
          SqlColumnModel.id(DataType.varcharMySql),
          SqlColumnModel.deleteFlag(DataType.booleanMySql),
          SqlColumnModel.createdAt(DataType.datetimeMySql),
          SqlColumnModel.updatedAt(DataType.datetimeMySql),
          SqlColumnModel.deletedAt(DataType.datetimeMySql),
        ];
      case DataBase.sqlServer:
        return [
          SqlColumnModel.id(DataType.varcharSqlServer),
          SqlColumnModel.deleteFlag(DataType.bitSqlServer),
          SqlColumnModel.createdAt(DataType.datetime2SqlServer),
          SqlColumnModel.updatedAt(DataType.datetime2SqlServer),
          SqlColumnModel.deletedAt(DataType.datetime2SqlServer),
        ];
      case DataBase.sqlLite:
        return [
          SqlColumnModel.id(DataType.textSqlLite),
          SqlColumnModel.deleteFlag(DataType.integerSqlLite),
          SqlColumnModel.createdAt(DataType.textSqlLite),
          SqlColumnModel.updatedAt(DataType.textSqlLite),
          SqlColumnModel.deletedAt(DataType.textSqlLite),
        ];
    }
  }

  static SqlColumnModel id(DataType datatype) {
    return SqlColumnModel(
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

  static SqlColumnModel deleteFlag(DataType datatype) {
    return SqlColumnModel(
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

  static SqlColumnModel createdAt(DataType datatype) {
    return SqlColumnModel(
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

  static SqlColumnModel updatedAt(DataType datatype) {
    return SqlColumnModel(
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

  static SqlColumnModel deletedAt(DataType datatype) {
    return SqlColumnModel(
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
