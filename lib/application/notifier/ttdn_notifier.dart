import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class ThongTinDoanhNghiepNotifier extends StateNotifier<List<TTDNModel>> {
  ThongTinDoanhNghiepNotifier() : super([]){
   getTTDN();
  }
  final _sqlRepository = SqlRepository(tableName: TableName.ttdn);

  Future<void> getTTDN() async {
    try {
      final data = await _sqlRepository.getData();
      state = data.map((e)=>TTDNModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> updateTTDN(int id, String field, String value)async{
    try{
      await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?" ,whereArgs: [id]);
    }catch(e){
      errorSql(e);
    }
  }
}
