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
}