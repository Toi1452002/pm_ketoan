import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';

class KhachHangNotifier extends StateNotifier<List<KhachHangModel>> {
  KhachHangNotifier() : super([]){
    getAll();
  }
  final _sqlRepository = SqlRepository(tableName: TableName.khachHang);

  Future<void> getAll({int theoDoi = 1}) async{
    try{
      String where = "1=? ";
      List<Object?> whereArgs = [1];
      if (theoDoi != 2) {
        where += "AND ${KhachHangString.theoDoi} = ? ";
        whereArgs.add(theoDoi);
      }
      final data = await _sqlRepository.getData(where: where,whereArgs: whereArgs);
      state = data.map((e)=>KhachHangModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> addKhach(KhachHangModel k) async{
    try{
      return await _sqlRepository.addRow(k.toMap());
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> updateKhach(KhachHangModel k, String maKhach) async{
    try{
      return await _sqlRepository.updateRow(k.toMap(),where: "${KhachHangString.maKhach} = '$maKhach'");
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> deleteKhach(String maKhach) async{
    try{
      state.removeWhere((e)=>e.maKhach == maKhach);
      return await _sqlRepository.delete(where: "${KhachHangString.maKhach} = '$maKhach'");
    }catch(e){
      errorSql(e);
      return 0;
    }
  }
}

class NhomKhachNotifier extends StateNotifier<List<NhomKhachModel>> {
  NhomKhachNotifier() : super([]){
    getAll();
  }

  final _sqlRepository = const SqlRepository(tableName: TableName.nhomKhach);

  Future<void> getAll() async{
    try{
      final data = await _sqlRepository.getData();
      state = data.map((e)=>NhomKhachModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }


  Future<int> addNhomKhach({required String field, required String value}) async{
    try{
      int id = await _sqlRepository.addCell(field: field, value: value);
      return id;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> updateNhomKhach({required String field, required String value, required int id}) async{
    try{
      int result = await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?" ,whereArgs: [id]);
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }
  Future<int> deleteNhomKhach(int id) async{
    try{
      int result = await _sqlRepository.delete(where: "ID = $id");
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }


}
