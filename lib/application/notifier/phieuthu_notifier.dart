import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../providers/phieuthu_provider.dart';
import '../providers/tuychon_provider.dart';

class PhieuThuNotifier extends StateNotifier<PhieuThuModel?> {
  PhieuThuNotifier() : super(null);
  final _sqlRepository = const SqlRepository(tableName: TableName.phieuThu);

  Future<void> getLastPhieuThu({WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository
          .getCustomData('''SELECT * FROM V_PhieuThu WHERE STT = (SELECT MAX(STT) FROM V_PhieuThu)''');
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM V_PhieuThu''');
      if (data.isNotEmpty) {
        PhieuThuModel phieuThu = PhieuThuModel.fromMap(data.first);
        phieuThu = phieuThu.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuThu;
        if (ref != null) {
          ref.read(phieuThuCTProvider.notifier).getPhieuThuCT(phieuThu.id!);
        }
      }else{
        state = null;
      }
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> addPhieuThu(UserModel user, WidgetRef ref) async {
    try {
      String phieu = 'T000000';
      final lastPhieu =
      await _sqlRepository.getCellValue(field: 'Phieu', where: '''ID = (SELECT MAX(ID) FROM TTC_PhieuThu)''');
      final pTN = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PTn').giaTri.toString();
      final pTC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PTc').giaTri.toString();

      if (lastPhieu != null) {
        final num = int.parse(lastPhieu.substring(1)) + 1;
        phieu = 'T${'0' * (6 - num.toString().length)}$num';
      }

      await _sqlRepository
          .addRow(PhieuThuModel(
          phieu: phieu,
          ngay: Helper.sqlDateTimeNow(),
          maTC: null,
          maKhach: null,
          tenKhach: null,
          diaChi: null,
          nguoiNop: null,
          nguoiThu: user.hoTen,
          soTien: 0,
          noiDung: null,
          pttt: 'NH',
          khoa: false,
          updatedAt: null,
          updatedBy: null,
          createdBy: user.userName,
          soCT: '',
          tkNo: pTN,
          tkCo: pTC)
          .toMap())
          .whenComplete(() async {
        getLastPhieuThu(ref: ref);
      });
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> onMovePhieuThu(int stt, {WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository.getCustomData('''SELECT * FROM V_PhieuThu WHERE STT = $stt''');
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM V_PhieuThu''');
      if (data.isNotEmpty) {
        PhieuThuModel phieuThu = PhieuThuModel.fromMap(data.first);
        phieuThu = phieuThu.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuThu;
        if (ref != null) {
          ref.read(phieuThuCTProvider.notifier).getPhieuThuCT(phieuThu.id!);
        }
      }
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> updatePhieuThu(String field, dynamic value, String phieu) async {
    try {
      if (field == PhieuThuString.ngay) state = state!.copyWith(ngay: value);
      if (field == PhieuThuString.maTC) state = state!.copyWith(maTC: value??'');
      if (field == PhieuThuString.pttt) state = state!.copyWith(pttt: value);
      if (field == PhieuThuString.tkNo) state = state!.copyWith(tkNo: value??'');
      if (field == PhieuThuString.tkCo) state = state!.copyWith(tkCo: value??'');
      if (field == PhieuThuString.khoa) state = state!.copyWith(khoa: value == 1 ? true : false);
      if(field == PhieuThuString.tenKhach) state!.tenKhach = value;
      if(field == PhieuThuString.diaChi) state!.diaChi = value;
      if(field == PhieuThuString.nguoiNop) state!.nguoiNop = value;
      if(field == PhieuThuString.nguoiThu) state!.nguoiThu = value;
      if(field == PhieuThuString.noiDung) state!.noiDung = value;
      if(field == PhieuThuString.soCT) state!.soCT = value;
      await _sqlRepository.updateCell(field: field, value: value, where: "Phieu = ?", whereArgs: [phieu]);
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateMaKhach(dynamic value, String phieu, KhachHangModel khach) async {
    try {
      state = state!.copyWith(maKhach: value??'', tenKhach: khach.tenKH, diaChi: khach.diaChi);
      await _sqlRepository
          .updateCell(field: PhieuThuString.maKhach, value: value, where: "Phieu = ?", whereArgs: [phieu]);
      await _sqlRepository
          .updateCell(field: PhieuThuString.tenKhach, value: khach.tenKH, where: "Phieu = ?", whereArgs: [phieu]);
      await _sqlRepository
          .updateCell(field: PhieuThuString.diaChi, value: khach.diaChi, where: "Phieu = ?", whereArgs: [phieu]);
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> deletePhieuThu(int id, {WidgetRef? ref}) async {
    try {
      await _sqlRepository.delete(where: "ID = $id").whenComplete(() {
        getLastPhieuThu(ref: ref);
      });
    } catch (e) {
      errorSql(e);
    }
  }


  void formatSoTien(dynamic value) {
    state = state!.copyWith(soTien: value);
  }
}
class PhieuThuCTNotifier extends StateNotifier<List<PhieuThuChiTietModel>> {
  PhieuThuCTNotifier() : super([]);

  final _sqlRepository = const SqlRepository(tableName: TableName.phieuThuCT);

  Future<void> getPhieuThuCT(int maID) async {
    try {
      final data = await _sqlRepository.getData(where: "${PhieuThuCTString.maID} = ?", whereArgs: [maID]);
      state = data.map((e) => PhieuThuChiTietModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<int> addPhieuThuCT(String field, dynamic value, int maID) async {
    try {
      final id = await _sqlRepository.addRow({PhieuThuCTString.maID: maID, field: value});
      return id;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<int> updatePhieuThuCT(String field, dynamic value, int id) async {
    try {
      final result = await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<int> deletePhieuThuCT(int id) async {
    try {
      return await _sqlRepository.delete(where: 'ID = $id');
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }
}

class BangKePhieuThuNotifier extends StateNotifier<List<PhieuThuModel>> {
  BangKePhieuThuNotifier() : super([]){
    getBangKePhieuThu();
  }
  final _sqlRepository = const SqlRepository(tableName: ViewName.phieuThu);

  Future<void> getBangKePhieuThu({String? tN, String? dN}) async {
    try {
      String tuNgay = Helper.dateFormatYMD(DateTime.now().copyWith(day: 1));
      String denNgay = Helper.sqlDateTimeNow();

      if(tN!=null && dN!=null){
        tuNgay = tN;
        denNgay = dN;
      }

      final data = await _sqlRepository.getData(where: "${PhieuThuString.ngay} BETWEEN ? AND ? ",whereArgs: [tuNgay,denNgay]);
      state = data.map((e) => PhieuThuModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }
}
