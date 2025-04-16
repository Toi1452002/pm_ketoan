import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';

class BangKeHangNhapNotifier extends StateNotifier<List<BangKeHangNXModel>> {
  BangKeHangNhapNotifier() : super([]){
   getBangKeHangNhap();
  }
  final _sqlRepository = SqlRepository(tableName: ViewName.vbcBangKeHangNhap);
  Future<void> getBangKeHangNhap({String? tN, String? dN}) async{
    try{
      String tuNgay = Helper.dateFormatYMD(DateTime.now().copyWith(day: 1));
      String denNgay = Helper.sqlDateTimeNow();

      if(tN!=null && dN!=null){
        tuNgay = tN;
        denNgay = dN;
      }
      final data = await _sqlRepository.getData(where: "${PhieuNhapString.ngay} BETWEEN ? AND ? ",whereArgs: [tuNgay,denNgay]);
      state = data.map((e)=>BangKeHangNXModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }
}


class BangKeHangXuatNotifier extends StateNotifier<List<BangKeHangNXModel>> {
  BangKeHangXuatNotifier() : super([]){
    getBangKeHangXuat();
  }
  final _sqlRepository = SqlRepository(tableName: ViewName.vbcBangKeHangXuat);
  Future<void> getBangKeHangXuat({String? tN, String? dN}) async{
    try{
      String tuNgay = Helper.dateFormatYMD(DateTime.now().copyWith(day: 1));
      String denNgay = Helper.sqlDateTimeNow();

      if(tN!=null && dN!=null){
        tuNgay = tN;
        denNgay = dN;
      }
      final data = await _sqlRepository.getData(where: "${PhieuXuatString.ngay} BETWEEN ? AND ? ",whereArgs: [tuNgay,denNgay]);
      state = data.map((e)=>BangKeHangNXModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

}
