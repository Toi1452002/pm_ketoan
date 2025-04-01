import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HangHoaNotifier extends StateNotifier<List<HangHoaModel>> {
  HangHoaNotifier() : super([]){
   getHangHoa();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.hangHoa);
  Future<void> getHangHoa({int theoDoi = 1}) async{
    try{
      String where = "1=? ";
      List<Object?> whereArgs = [1];
      if (theoDoi != 2) {
        where += "AND ${HangHoaString.theoDoi} = ? ";
        whereArgs.add(theoDoi);
      }


      final data = await _sqlRepository.getData(tableNameOther: ViewName.hangHoa,where: where,whereArgs: whereArgs);
      state = data.map((e)=>HangHoaModel.fromMap(e)).toList();
      // state = await _hangHoaRepository.getHangHoa(theoDoi: theoDoi,filter: filter);
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> add(HangHoaModel hangHoa) async{
    try{
      return await _sqlRepository.addRow(hangHoa.toMap());
    }catch(e){
      errorSql(e);
      return 0;
    }
  }


  Future<int> update(HangHoaModel hangHoa, int id) async{
    try{
      return await _sqlRepository.updateRow(hangHoa.toMap(), where: "ID = $id");
    }
    catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> delete(int id) async{
    try{
      state.removeWhere((e)=>e.id == id);
      return await _sqlRepository.delete(where: "ID = $id");
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

}

///Nhóm hàng notifier
class NhomHangNotifier extends StateNotifier<List<NhomHangModel>> {
  NhomHangNotifier() : super([]){
    getAll();
  }
  final nhomHangRepository = const SqlRepository(tableName: TableName.nhomHang);

  Future<void> getAll() async{
    try{
      final data = await nhomHangRepository.getData();
      state = data.map((e)=>NhomHangModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> add({required String field, required String value}) async{
    try{
      int id = await nhomHangRepository.addCell(field: field, value: value);
      return id;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> update({required String field, required String value, required int id}) async{
    try{
      int result = await nhomHangRepository.updateCell(field: field, value: value, where: "ID = ?" ,whereArgs: [id]);
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }
  Future<int> delete(int id) async{
    try{
      int result = await nhomHangRepository.delete(where: "ID = $id");
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }


}


class DonViTinhNotifier extends StateNotifier<List<DonViTinhModel>> {
  DonViTinhNotifier() : super([]){
    getAll();
  }
  final dvtRepository =  const SqlRepository(tableName: TableName.dvt);

  Future<void> getAll() async{
    try{
      final data = await dvtRepository.getData();
      state = data.map((e)=>DonViTinhModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> add({required String field, required String value}) async{
    try{
      int id = await dvtRepository.addCell(field: field, value: value);
      return id;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> update({required String field, required String value, required int id}) async{
    try{
      int result = await dvtRepository.updateCell(field: field, value: value, where: "ID = ?" ,whereArgs: [id]);
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }
  Future<int> delete(int id) async{
    try{
      int result = await dvtRepository.delete(where: "ID = $id");
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }


}