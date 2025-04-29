import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../application.dart';
import '../providers/tuychon_provider.dart';
class PhieuchiNotifier extends StateNotifier<PhieuChiModel?> {
  PhieuchiNotifier() : super(null);

  final _sqlRepository = const SqlRepository(tableName: TableName.phieuChi);

  Future<void> getLastPhieuChi({WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository
          .getCustomData('''SELECT * FROM V_PhieuChi WHERE STT = (SELECT MAX(STT) FROM V_PhieuChi)''');
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM V_PhieuChi''');
      if (data.isNotEmpty) {
        PhieuChiModel phieuChi = PhieuChiModel.fromMap(data.first);
        phieuChi = phieuChi.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuChi;
        if (ref != null) {
          ref.read(phieuChiCTProvider.notifier).getPhieuChiCT(phieuChi.id!);
        }
      }else{
        state = null;
      }
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> onMovePhieuChi(int stt, {WidgetRef? ref}) async {
    try {
      final data = await _sqlRepository.getCustomData('''SELECT * FROM V_PhieuChi WHERE STT = $stt''');
      final rowCount = await _sqlRepository.getCustomData('''SELECT COUNT(*) as count FROM V_PhieuChi''');
      if (data.isNotEmpty) {
        PhieuChiModel phieuChi = PhieuChiModel.fromMap(data.first);
        phieuChi = phieuChi.copyWith(countRow: rowCount.first['count'].toString());
        state = phieuChi;
        if (ref != null) {
          ref.read(phieuChiCTProvider.notifier).getPhieuChiCT(phieuChi.id!);
        }
      }
    } catch (e) {
      errorSql(e);
    }
  }
  Future<void> addPhieuChi(UserModel user, WidgetRef ref) async {
    try {
      String phieu = 'C000000';
      final lastPhieu =
      await _sqlRepository.getCellValue(field: PhieuChiString.phieu, where: '''ID = (SELECT MAX(ID) FROM ${TableName.phieuChi})''');

      if (lastPhieu != null) {
        final num = int.parse(lastPhieu.substring(1)) + 1;
        phieu = 'C${'0' * (6 - num.toString().length)}$num';
      }
      final pCC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PCc').giaTri.toString();
      final pCN = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PCn').giaTri.toString();
      await _sqlRepository
          .addRow(PhieuChiModel(
          phieu: phieu,
          ngay: Helper.sqlDateTimeNow(),
          maTC: null,
          maKhach: null,
          tenKhach: null,
          diaChi: null,
          nguoiNhan: null,
          nguoiChi: user.hoTen,
          soTien: 0,
          noiDung: null,
          pttt: 'NH',
          khoa: false,
          updatedAt: null,
          updatedBy: null,
          createdBy: user.userName,
          soCT: '',
          tkNo: pCN,
          tkCo: pCC)
          .toMap())
          .whenComplete(() async {
        getLastPhieuChi(ref: ref);
      });
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updatePhieuChi(String field, dynamic value, String phieu) async {
    try {
      if (field == PhieuChiString.ngay) state = state!.copyWith(ngay: value);

      if (field == PhieuChiString.pttt) state = state!.copyWith(pttt: value);
      if (field == PhieuChiString.tkNo) state = state!.copyWith(tkNo: value??'');
      if (field == PhieuChiString.tkCo) state = state!.copyWith(tkCo: value??'');
      if (field == PhieuChiString.khoa) state = state!.copyWith(khoa: value == 1 ? true : false);
      if(field == PhieuChiString.tenKhach) state!.tenKhach = value;
      if(field == PhieuChiString.diaChi) state!.diaChi = value;
      if(field == PhieuChiString.nguoiNhan) state!.nguoiNhan = value;
      if(field == PhieuChiString.nguoiChi) state!.nguoiChi = value;
      if(field == PhieuChiString.noiDung) state!.noiDung = value;
      if(field == PhieuChiString.soCT) state!.soCT = value;
      await _sqlRepository.updateCell(field: field, value: value, where: "Phieu = ?", whereArgs: [phieu]);
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateNhanVien(dynamic value, String phieu, NhanVienModel nv) async {
    try {
      state = state!.copyWith(maNV: value??'', tenKhach: nv.hoTen, diaChi: nv.diaChi);
      await _sqlRepository.updateRow({
        PhieuChiString.maNV: value,
        PhieuChiString.maKhach: null,
        PhieuChiString.tenKhach: nv.hoTen,
        PhieuChiString.diaChi: nv.diaChi
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateNhaCung(dynamic value, String phieu, KhachHangModel kh) async {
    try {
      state = state!.copyWith(maKhach: value??'', tenKhach: kh.tenKH, diaChi: kh.diaChi);
      await _sqlRepository.updateRow({
        PhieuChiString.maKhach: value,
        PhieuChiString.maNV: null,
        PhieuChiString.tenKhach: kh.tenKH,
        PhieuChiString.diaChi: kh.diaChi
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateKieuChi(dynamic value, String phieu) async{
    try {
      state = state!.copyWith(maTC: value??'',maKhach: '',maNV: '', tenKhach: '', diaChi: '');
      await _sqlRepository.updateRow({
        PhieuChiString.maTC : value,
        PhieuChiString.maKhach: null,
        PhieuChiString.maNV: null,
        PhieuChiString.tenKhach: null,
        PhieuChiString.diaChi: null
      }, where: "Phieu = '$phieu'");

    }catch(e){
      errorSql(e);

    }

  }
  Future<int> deletePhieuChi(int id, {WidgetRef? ref}) async {
    try {
      return await _sqlRepository.delete(where: "ID = $id").whenComplete(() {
        getLastPhieuChi(ref: ref);
      });
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }
  void formatSoTien(dynamic value) {
    state = state!.copyWith(soTien: value);
  }
}

class BangKePhieuChiNotifier extends StateNotifier<List<PhieuChiModel>> {
  BangKePhieuChiNotifier() : super([]){
    getBangKePhieuChi();
  }
  final _sqlRepository = const SqlRepository(tableName: ViewName.phieuChi);

  Future<void> getBangKePhieuChi({String? tN, String? dN}) async {
    try {
      String tuNgay = Helper.dateFormatYMD(DateTime.now().copyWith(day: 1));
      String denNgay = Helper.sqlDateTimeNow();

      if(tN!=null && dN!=null){
        tuNgay = tN;
        denNgay = dN;
      }
      final data = await _sqlRepository.getData(where: "${PhieuThuString.ngay} BETWEEN ? AND ? ",whereArgs: [tuNgay,denNgay]);
      state = data.map((e) => PhieuChiModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }
}
class PhieuChiCTNotifier extends StateNotifier<List<PhieuChiCTModel>> {
  PhieuChiCTNotifier() : super([]);

  final _sqlRepository = const SqlRepository(tableName: TableName.phieuChiCT);

  Future<void> getPhieuChiCT(int maID) async {
    try {
      final data = await _sqlRepository.getData(where: "${PhieuChiCTString.maID} = ?", whereArgs: [maID]);
      state = data.map((e) => PhieuChiCTModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<int> addPhieuChiCT(String field, dynamic value, int maID) async {
    try {
      final id = await _sqlRepository.addRow({PhieuChiCTString.maID: maID, field: value});
      return id;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<int> updatePhieuChiCT(String field, dynamic value, int id) async {
    try {
      final result = await _sqlRepository.updateCell(field: field, value: value, where: "ID = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<int> deletePhieuChiCT(int id) async {
    try {
      return await _sqlRepository.delete(where: 'ID = $id');
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }
}