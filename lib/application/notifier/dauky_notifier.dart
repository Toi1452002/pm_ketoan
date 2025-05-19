import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/data.dart';

class DauKyHangHoaNotifier extends StateNotifier<List<DauKyHangHoaModel>> {
  DauKyHangHoaNotifier() : super([]) {
    getTonDauKy();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.dauKyHangHoa);

  Future<void> getTonDauKy() async {
    try {
      final data = await _sqlRepository.getData(
        tableNameOther: ViewName.vdmDauKyHangHoa,
        orderBy: DauKyHangHoaString.ngay,
      );
      state = data.map((e) => DauKyHangHoaModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<bool> capNhatDauKy(List<DauKyHangHoaModel> lst) async {
    try {
      await _sqlRepository.delete();
      await _sqlRepository.addRows(lst.map((e) => e.toMap()).toList());
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
}

class DauKyKhachHangNotifier extends StateNotifier<List<DauKyKhachHangModel>> {
  DauKyKhachHangNotifier() : super([]) {
    getDKyKhachHang();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.dauKyKhachHang);

  Future<void> getDKyKhachHang() async {
    try {
      final data = await _sqlRepository.getData(
        tableNameOther: ViewName.vdmDauKyKhachHang,
        orderBy: DauKyKhachHangString.ngay,
      );
      state = data.map((e) => DauKyKhachHangModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<bool> capNhatDKyKhachHang(List<DauKyKhachHangModel> lst) async {
    try {
      await _sqlRepository.delete();
      await _sqlRepository.addRows(lst.map((e) => e.toMap()).toList());
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
}

class DkyTaiKhoanNotifier extends StateNotifier<List<DauKyTaiKhoangModel>> {
  DkyTaiKhoanNotifier() : super([]) {
    getDKyTaiKhoan();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.dauKyTaiKhoan);

  Future<void> getDKyTaiKhoan({DateTime? val}) async {
    try {
      val ??= DateTime.now();
      String date = DateFormat('yyyy-MM').format(DateTime(val.year, val.month - 1));
      final data = await _sqlRepository.getCustomData('''
      SELECT a.MaTk, a.TenTK, b.DKCo,b.DKNo, a.TinhChat
      FROM TDM_BangTaiKhoan a LEFT JOIN TDM_DKyTaiKhoan b on a.MaTK = b.MaTK  AND  b.DKy = 1 AND b.Thang = '$date'
      ''');
      state = data.map((e) => DauKyTaiKhoangModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<bool> capNhatDauKyTK(List<DauKyTaiKhoangModel> lst) async {
    try {
      for (var e in lst) {
        // e.dKy = false;
        final resultUpdate = await _sqlRepository.updateRow(
          e.toMap(),
          where: "${DauKyTaiKhoanString.thang} = '${e.thang}' AND ${DauKyTaiKhoanString.maTK} = '${e.maTK}'",
        );
        if (resultUpdate == 0) {
          e.dKy = true;
          await _sqlRepository.addRow(e.toMap());
        }
      }
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
}
