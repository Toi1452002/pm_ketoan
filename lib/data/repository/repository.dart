import 'package:app_ketoan/core/utils/custom_alert.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'connect_data.dart';

class SqlRepository {
  final String tableName;

  const SqlRepository({required this.tableName});

  Future<List<Map<String, dynamic>>> getData({String? orderBy, String? where, List<Object?>? whereArgs, String? tableNameOther}) async {
    final cnn = await connectData();
    final data = await cnn!.query(tableNameOther??tableName, orderBy: orderBy, where: where, whereArgs: whereArgs);
    return data;
  }

  Future<List<Map<String, dynamic>>> getCustomData(String sql) async {
    final cnn = await connectData();
    final data = await cnn!.rawQuery(sql);
    return data;
  }

  Future<int> addRow(Map<String, dynamic> map) async {
    final cnn = await connectData();
    return await cnn!.insert(tableName, map);
  }

  Future<int> updateRow(Map<String, dynamic> map, {String? where, String? tableNameOther }) async {
    final cnn = await connectData();
    return await cnn!.update(tableNameOther??tableName, map, where: where);
  }

  Future<int> addCell({required String field, required String value}) async {
    final cnn = await connectData();
    return await cnn!.insert(tableName, {field: value});
  }

  Future<int> updateCell({
    required String field,
    required dynamic value,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final cnn = await connectData();
    return await cnn!.update(tableName, {field: value}, where: where, whereArgs: whereArgs);
  }

  Future<int> delete({String? where, String? tableNameOther}) async {
    final cnn = await connectData();
    return await cnn!.delete(tableNameOther ?? tableName, where: where);
  }

  Future<String?> getCellValue({required String field, required String where}) async {
    final cnn = await connectData();
    final data = await cnn!.rawQuery("SELECT $field FROM $tableName WHERE $where");
    return data.isEmpty ? null : data.first[field].toString();
  }

  Future<void> addRows(List<Map<String, dynamic>> data, {String? tableNameOther}) async {
    final cnn = await connectData();
    final bacth = cnn!.batch();
    for (var x in data) {
      bacth.insert(tableNameOther ?? tableName, x);
    }
    await bacth.commit(noResult: true);
  }

}

errorSql(Object e) {
  if (e is DatabaseException) {
    try {
      final a = e.toString().indexOf('SqliteException(');
      int b = e.toString().indexOf('Causing ');
      CustomAlert().error(e.toString().substring(a, b));
    } catch (err) {
      CustomAlert().error(e.toString());
    }
  } else {
    CustomAlert().error(e.toString());
  }
}


