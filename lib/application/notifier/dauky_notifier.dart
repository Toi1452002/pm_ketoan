import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';


class DauKyHangHoaNotifier extends StateNotifier<List<DauKyHangHoaModel>> {
  DauKyHangHoaNotifier() : super([]){
    getTonDauKy();
  }
  
  final _sqlRepository = SqlRepository(tableName: TableName.dauKyHangHoa);

  Future<void> getTonDauKy() async{
    try{
      final data = await _sqlRepository.getData(tableNameOther: ViewName.vdmDauKyHangHoa,orderBy: DauKyHangHoaString.ngay);
      state = data.map((e)=>DauKyHangHoaModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<bool> capNhatDauKy(List<DauKyHangHoaModel> lst) async{
    try{
      await _sqlRepository.delete();
      await _sqlRepository.addRows(lst.map((e)=>e.toMap()).toList());
      // getTonDauKy();
      return true;
    }catch(e){
      errorSql(e);
      return false;
    }
  }

}