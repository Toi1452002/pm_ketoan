import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';

class PhieuNhapNotifier extends StateNotifier<PhieuNhapModel?> {
  PhieuNhapNotifier() : super(null);

  final _sqlRepository = SqlRepository(tableName: TableName.phieuNhap);

  Future<void> getLastPhieuNhap({WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository.getCustomData(
        '''SELECT * FROM ${ViewName.phieuNhap} WHERE STT = (SELECT MAX(STT) FROM  ${ViewName.phieuNhap})''',
      );
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM ${ViewName.phieuNhap}''');
      if (data.isNotEmpty) {
        PhieuNhapModel phieuNhap = PhieuNhapModel.fromMap(data.first);
        phieuNhap = phieuNhap.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuNhap;
        if (ref != null) {
          ref.read(phieuNhapCTProvider.notifier).getPhieuNhapCT(phieuNhap.id!);
        }
      } else {
        state = null;
      }
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> addPhieuNhap(String userName, WidgetRef ref) async {
    try {
      String phieu = 'N000000';
      final lastPhieu = await _sqlRepository.getCellValue(
        field: 'Phieu',
        where: '''ID = (SELECT MAX(ID) FROM ${TableName.phieuNhap})''',
      );
      if (lastPhieu != null) {
        final num = int.parse(lastPhieu.substring(1)) + 1;
        phieu = 'N${'0' * (6 - num.toString().length)}$num';
      }
      final pNC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PNc').giaTri.toString();
      final pNN = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PNn').giaTri.toString();
      final tNC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='TNc').giaTri.toString();
      final tNN = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='TNn').giaTri.toString();
      final thueSuat = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='TS').giaTri;

      await _sqlRepository
          .addRow(
            PhieuNhapModel(
              ngay: Helper.sqlDateTimeNow(),
              phieu: phieu,
              maNX: 'NM',
              dienGiai: '',
              congTien: 0,
              thueSuat: thueSuat.toDouble(),
              tienThue: 0,
              khoa: false,
              kyHieu: '',
              kChiuThue: false,
              createdBy: userName,
              createdAt: Helper.sqlDateTimeNow(hasTime: true),
              pttt: 'TM/CK',
              ngayCT: Helper.sqlDateTimeNow(),
              tkNo: pNC,
              tkCo: pNN,
              tkVatNo: tNN,
              tkVatCo: tNC,
              soCT: null,
            ).toMap(),
          )
          .whenComplete(() {
            getLastPhieuNhap(ref: ref);
          });
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> onMovePhieuNhap(int stt, {WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository.getCustomData('''SELECT * FROM ${ViewName.phieuNhap} WHERE STT = $stt''');
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM ${ViewName.phieuNhap}''');
      if (data.isNotEmpty) {
        PhieuNhapModel phieuNhap = PhieuNhapModel.fromMap(data.first);
        phieuNhap = phieuNhap.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuNhap;
        if (ref != null) {
          ref.read(phieuNhapCTProvider.notifier).getPhieuNhapCT(phieuNhap.id!);
        }
      }
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> deletePhieuNhap(int id,  {WidgetRef? ref}) async {
    try {
      await _sqlRepository.delete(where: 'ID = $id').whenComplete(() {
        getLastPhieuNhap(ref: ref);
      });
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updatePhieuNhap(String field, dynamic value, String phieu, {required String userName}) async {
    try {
      if (field == PhieuNhapString.ngay) state = state!.copyWith(ngay: value);
      if (field == PhieuNhapString.ngayCT) state = state!.copyWith(ngayCT: value);
      if (field == PhieuNhapString.khoa) state = state!.copyWith(khoa: value == 1 ? true : false);
      if (field == PhieuNhapString.maNX) state = state!.copyWith(maNX: value);
      if (field == PhieuNhapString.kyHieu) state?.kyHieu = value;
      if (field == PhieuNhapString.soCT) state?.soCT = value;
      if (field == PhieuNhapString.dienGiai) state?.dienGiai = value;
      if (field == PhieuNhapString.pttt) state = state!.copyWith(pttt: value);
      if (field == PhieuNhapString.tkNo) state = state!.copyWith(tkNo: value??'');
      if (field == PhieuNhapString.tkCo) state = state!.copyWith(tkCo: value??'');
      if (field == PhieuNhapString.tkVatCo) state = state!.copyWith(tkVatCo: value??'');
      if (field == PhieuNhapString.tkVatNo) state = state!.copyWith(tkVatNo: value??'');
      if (field == PhieuNhapString.congTien) state = state!.copyWith(congTien: value);
      if (field == PhieuNhapString.tienThue) state = state!.copyWith(tienThue: value);

      if (field == PhieuNhapString.kChiuThue) state = state!.copyWith(kChiuThue: value == 1 ? true : false);
      if (field == PhieuNhapString.thueSuat) {
        state?.thueSuat = double.parse(value);
      }
      await _sqlRepository.updateRow({
        field: value,
        PhieuNhapString.updatedBy: userName,
        PhieuNhapString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateTienThueGTGT(double value, String phieu, {required String userName}) async {
    try {
      state!.tienThue = value;
      await _sqlRepository.updateRow({
        PhieuNhapString.tienThue: value,
        PhieuNhapString.updatedBy: userName,
        PhieuNhapString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateMaKhach(dynamic maKhach, String phieu, {required String userName}) async {
    try {
      String dienGiai =maKhach!=null? "Mua hàng từ nhà cung $maKhach":'';

      state = state!.copyWith(maKhach: maKhach ?? '', dienGiai: dienGiai);

      await _sqlRepository.updateRow({
        PhieuNhapString.maKhach: maKhach,
        PhieuNhapString.dienGiai: dienGiai,
        PhieuNhapString.updatedBy: userName,
        PhieuNhapString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }
}

class PhieuNhapCTNotifier extends StateNotifier<List<PhieuNhapCTModel>> {
  PhieuNhapCTNotifier() : super([]);
  final _sqlRepository = SqlRepository(tableName: TableName.phieuNhapCT);

  Future<void> getPhieuNhapCT(int maID) async {
    try {
      final data = await _sqlRepository.getData(
        tableNameOther: ViewName.phieuNhapCT,
        where: "${PhieuNhapCTString.maID} = ?",
        whereArgs: [maID],
      );
      state = data.map((e) => PhieuNhapCTModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<int> addPhieuNhapCT(String field, dynamic value, int maID) async {
    try {
      final id = await _sqlRepository.addRow({PhieuNhapCTString.maID: maID, field: value});
      return id;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<void> updateMaHang(int id, {required HangHoaModel hangHoa}) async {
    try {
      await _sqlRepository.updateRow({
        PhieuNhapCTString.tenHH: hangHoa.tenHH,
        PhieuNhapCTString.dvt: hangHoa.donViTinh,
        PhieuNhapCTString.donGia: hangHoa.giaBan,
      }, where: "ID = $id");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateTongTien({
    required PhieuNhapModel phieuNhap,
    required String userName,
    required PhieuNhapNotifier phieuNhapNotifer
  }) async {
    // final wPhieuNhap = ref.read(phieuNhapProvider);
    // final userName = ref.read(userInfoProvider)!.userName;
    final data = await _sqlRepository.getCustomData('''
        SELECT SUM(ThanhTien) as TongTien FROM ${ViewName.phieuNhapCT} WHERE MaID = ${phieuNhap.id}
       ''');
    // final tongTien = double.parse(data.first['TongTien'].toString());
    final sum = data.first['TongTien'];
    double tongTien = 0;
    if(sum!=null){
      tongTien = double.parse(sum.toString());
    }

    final tienThue = (phieuNhap.thueSuat * tongTien) / 100;
    if(phieuNhapNotifer.mounted){
      phieuNhapNotifer.updatePhieuNhap(PhieuNhapString.congTien, tongTien, phieuNhap.phieu, userName: userName);
      phieuNhapNotifer.updatePhieuNhap(PhieuNhapString.tienThue, tienThue, phieuNhap.phieu, userName: userName);
    }else{
      Future.wait([
        _sqlRepository.updateRow(
          {
            PhieuXuatString.congTien: tongTien,
            PhieuXuatString.updatedBy: userName,
            PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
          },
          where: "Phieu = '${phieuNhap.phieu}'",
          tableNameOther: TableName.phieuNhap,
        ),
        _sqlRepository.updateRow(
          {
            PhieuXuatString.tienThue: tienThue,
            PhieuXuatString.updatedBy: userName,
            PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
          },
          where: "Phieu = '${phieuNhap.phieu}'",
          tableNameOther: TableName.phieuNhap,
        ),
      ]);
    }


  }

  Future<int> updatePhieuNhapCT(String field, dynamic value, int id, {int? MaID, WidgetRef? ref}) async {
    try {
      final result = await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<int> deletePhieuNhapCT(int id) async {
    try {
      return await _sqlRepository.delete(where: 'ID = $id');
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }
}


class BCPhieuNhapNotifier extends StateNotifier<List<VBCPhieuNhapModel>> {
  BCPhieuNhapNotifier() : super([]){
    getBCPhieuNhap(quy: Helper.getQuarterNow(), nam: DateTime.now().year.toString());
  }
  final sqlRepository = SqlRepository(tableName: ViewName.vbcPhieuNhap);
  Future<void> getBCPhieuNhap({String? thang, String? quy, String? nam})async{
    try{
      String where = "";

      if (thang == null && quy == null) {
        where = "strftime('%Y', ${PhieuXuatString.ngay}) = '$nam'";
      }

      if (quy != null) {
        where = '''strftime('%Y', ${PhieuXuatString.ngay}) = '$nam' AND strftime('%m', ${PhieuXuatString.ngay}) 
        BETWEEN '${mQuy[quy]?.first}' AND '${mQuy[quy]?.last}'
        ''';
      }
      if (thang != null) {
        if (thang.length == 1) thang = "0$thang";
        where =
        "strftime('%Y', ${PhieuXuatString.ngay}) = '$nam' AND strftime('%m', ${PhieuXuatString.ngay}) = '$thang'";
      }
      final data = await sqlRepository.getData(where: where);
      state = data.map((e)=>VBCPhieuNhapModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }
}
