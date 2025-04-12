import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TuyChonNotifier extends StateNotifier<List<TuyChonModel>> {
  TuyChonNotifier() : super([]);

  final _sqlRepository = SqlRepository(tableName: TableName.tuyChon);

  Future<void> getListTuyChon() async {
    try {
      final data = await _sqlRepository.getData();
      state = data.map((e) => TuyChonModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<bool> updateTuyChon({required bool xBC, required bool kPC}) async {
    try {
      Future.wait([
        _sqlRepository.updateRow({TuyChonString.giaTri: xBC ? 1 : 0}, where: "${TuyChonString.nhom}='qlXBC'"),
        _sqlRepository.updateRow({TuyChonString.giaTri: kPC ? 1 : 0}, where: "${TuyChonString.nhom}='qlKPC'"),
      ]).whenComplete((){
        getListTuyChon();
      });


      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
}
