import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BangTaiKhoanNotifier extends StateNotifier<List<BangTaiKhoanModel>> {
  BangTaiKhoanNotifier() : super([]){
    getBangTaiKhoan();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.bangTaiKhoan);
  Future<void> getBangTaiKhoan() async{
    try{
      final data = await _sqlRepository.getData();
      state = data.map((e)=>BangTaiKhoanModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }
  Future<int> add({required String field, required String value}) async{
    try{
      int id = await _sqlRepository.addCell(field: field, value: value);
      return id;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> update({required String field, required String value, required int id}) async{
    try{
      int result = await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?" ,whereArgs: [id]);
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }
}