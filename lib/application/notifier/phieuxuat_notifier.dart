import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';

class PhieuXuatNotifier extends StateNotifier<PhieuXuatModel?> {
  PhieuXuatNotifier() : super(null);

  final _sqlRepository = SqlRepository(tableName: TableName.phieuXuat);

  Future<void> getLastPhieuXuat({WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository.getCustomData(
        '''SELECT * FROM ${ViewName.phieuXuat} WHERE STT = (SELECT MAX(STT) FROM  ${ViewName.phieuXuat})''',
      );
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM ${ViewName.phieuXuat}''');
      if (data.isNotEmpty) {
        PhieuXuatModel phieuXuat = PhieuXuatModel.fromMap(data.first);
        phieuXuat = phieuXuat.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuXuat;
        if(ref!=null){
          ref.read(phieuXuatCTProvider.notifier).getPhieuXuatCT(phieuXuat.id!);
        }
      } else {
        state = null;
      }
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> addPhieuXuat(String userName, WidgetRef ref) async {
    try {
      String phieu = 'X000000';
      final lastPhieu = await _sqlRepository.getCellValue(
        field: 'Phieu',
        where: '''ID = (SELECT MAX(ID) FROM ${TableName.phieuXuat})''',
      );
      if (lastPhieu != null) {
        final num = int.parse(lastPhieu.substring(1)) + 1;
        phieu = 'X${'0' * (6 - num.toString().length)}$num';
      }

      await _sqlRepository.addRow(
        PhieuXuatModel(
          ngay: Helper.sqlDateTimeNow(),
          phieu: phieu,
          maNX: 'XB',
          dienGiai: '',
          congTien: 0,
          thueSuat: 0,
          tienThua: 0,
          khoa: false,
          kyHieu: '',
          soHD: '',
          kChiuThue: true,
          createdBy: userName,
          createdAt: Helper.sqlDateTimeNow(hasTime: true),
          pttt: 'TM/CK',
          ngayCT: Helper.sqlDateTimeNow(),
          tkNo: '131',
          tkCo: '5113',
          tkVatNo: '131',
          tkVatCo: '3331',
        ).toMap(),
      ).whenComplete((){
        getLastPhieuXuat(ref: ref);
      });
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> onMovePhieuXuat(int stt, {WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository.getCustomData('''SELECT * FROM ${ViewName.phieuXuat} WHERE STT = $stt''');
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM ${ViewName.phieuXuat}''');
      if (data.isNotEmpty) {
        PhieuXuatModel phieuXuat = PhieuXuatModel.fromMap(data.first);
        phieuXuat = phieuXuat.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuXuat;
        if(ref!=null){
          ref.read(phieuXuatCTProvider.notifier).getPhieuXuatCT(phieuXuat.id!);
        }
      }
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> deletePhieuXuat(int id, BuildContext context) async{
    try{
       await _sqlRepository.delete(where: 'ID = $id').whenComplete((){
        getLastPhieuXuat();
         showDeleteSuccess(context);
      });
    }catch(e){
      errorSql(e);
    }
  }

  Future<void> updatePhieuXuat(String field, dynamic value, String phieu,{required String userName}) async{
    try{
      if(field==PhieuXuatString.ngay) state = state!.copyWith(ngay: value);
      if(field==PhieuXuatString.ngayCT) state = state!.copyWith(ngayCT: value);
      if(field==PhieuXuatString.khoa) state = state!.copyWith(khoa: value==1?true:false);
      if(field==PhieuXuatString.maNX) state = state!.copyWith(maNX: value);
      if(field==PhieuXuatString.kyHieu) state?.kyHieu = value;
      if(field==PhieuXuatString.soHD) state?.soHD = value;
      if(field==PhieuXuatString.dienGiai) state?.dienGiai = value;
      if(field==PhieuXuatString.pttt) state = state!.copyWith(pttt: value);
      if(field==PhieuXuatString.tkNo) state = state!.copyWith(tkNo: value);
      if(field==PhieuXuatString.tkCo) state = state!.copyWith(tkCo: value);
      if(field==PhieuXuatString.tkVatCo) state = state!.copyWith(tkVatCo: value);
      if(field==PhieuXuatString.tkVatNo) state = state!.copyWith(tkVatNo: value);

      if(field==PhieuXuatString.kChiuThue) state = state!.copyWith(kChiuThue: value==1?true:false);
      if(field==PhieuXuatString.thueSuat) {
        state?.thueSuat = double.parse(value);
      }
      await _sqlRepository.updateRow({
        field:value,
        PhieuXuatString.updatedBy: userName,
        PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true)
      }, where: "Phieu = '$phieu'");

    }catch(e){
      errorSql(e);
    }
  }

  Future<void> updateMaKhach(dynamic maKhach, String phieu,{required String userName}) async{
    try{
      String dienGiai = "Bán hàng cho khách $maKhach";

      state = state!.copyWith(maKhach: maKhach??'',dienGiai: dienGiai);

      await _sqlRepository.updateRow({
        PhieuXuatString.maKhach: maKhach,
        PhieuXuatString.dienGiai: dienGiai,
        PhieuXuatString.updatedBy: userName,
        PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true)
      },where: "Phieu = '$phieu'",);
    }catch(e){
      errorSql(e);
    }
  }
}


class PhieuXuatCTNotifier extends StateNotifier<List<PhieuXuatCTModel>> {
  PhieuXuatCTNotifier() : super([]);
  final _sqlRepository = SqlRepository(tableName: TableName.phieuXuatCT);
  Future<void> getPhieuXuatCT(int maID) async{
    try{
      final data =await _sqlRepository.getData(tableNameOther: ViewName.phieuXuatCT,where: "${PhieuXuatCTString.maID} = ?",whereArgs: [maID]);
      state = data.map((e)=>PhieuXuatCTModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> addPhieuXuatCT(String field, dynamic value, int maID) async{
    try {
      final id = await _sqlRepository.addRow({PhieuXuatCTString.maID: maID, field: value});
      return id;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<void> updateMaHang(int id, {required HangHoaModel hangHoa}) async{
    try{
      await _sqlRepository.updateRow({
        PhieuXuatCTString.tenHH: hangHoa.tenHH,
        PhieuXuatCTString.dvt: hangHoa.donViTinh,
        PhieuXuatCTString.donGia: hangHoa.giaBan
      },where: "ID = $id");
    }catch(e){
      errorSql(e);

    }
  }

  Future<int> updatePhieuXuatCT(String field, dynamic value, int id) async {
    try {
      final result = await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<int> deletePhieuXuatCT(int id) async {
    try {
      return await _sqlRepository.delete(where: 'ID = $id');
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }


}