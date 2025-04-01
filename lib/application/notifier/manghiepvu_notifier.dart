import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





class MaNghiepVuNotifier extends StateNotifier<List<MaNghiepVuModel>> {
  MaNghiepVuNotifier() : super([]){
    getMaNghiepVu();
  }


  final _sqlRepository = const SqlRepository(tableName: TableName.maNghiepVu);


  Future<void> getMaNghiepVu() async{
    try{
      final data = await _sqlRepository.getData();
      state = data.map((e)=>MaNghiepVuModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> add(String field, dynamic value) async{
    try{
      return await _sqlRepository.addCell(field: field, value: value);
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> update(String field, dynamic value, int id) async{
    try{
      return await  _sqlRepository.updateCell(field: field, value: value,  where: "ID = ?" ,whereArgs: [id]);
    }catch(e){
      errorSql(e);
      return 0;
    }
  }
  Future<int> delete(int id) async{
    try{
      return await _sqlRepository.delete(where: "ID = $id");
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

}