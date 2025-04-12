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
        if (ref != null) {
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
      final pXC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PXc').giaTri.toString();
      final pXN = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='PXn').giaTri.toString();
      final tXC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='TXc').giaTri.toString();
      final tXN = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='TXn').giaTri.toString();
      final thueSuat = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='TS').giaTri;
      await _sqlRepository
          .addRow(
            PhieuXuatModel(
              ngay: Helper.sqlDateTimeNow(),
              phieu: phieu,
              maNX: 'XB',
              dienGiai: '',
              congTien: 0,
              thueSuat: thueSuat.toDouble(),
              tienThue: 0,
              khoa: false,
              kyHieu: '',
              soHD: '',
              kChiuThue: thueSuat==0 ?true: false,
              createdBy: userName,
              createdAt: Helper.sqlDateTimeNow(hasTime: true),
              pttt: 'TM/CK',
              ngayCT: Helper.sqlDateTimeNow(),
              tkNo: pXN,
              tkCo: pXC,
              tkVatNo: tXN,
              tkVatCo: tXC,
            ).toMap(),
          )
          .whenComplete(() {
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
        if (ref != null) {
          ref.read(phieuXuatCTProvider.notifier).getPhieuXuatCT(phieuXuat.id!);
        }
      }
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> deletePhieuXuat(int id, {WidgetRef? ref}) async {
    try {
      await _sqlRepository.delete(where: 'ID = $id').whenComplete(() {
        getLastPhieuXuat(ref: ref);
      });
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updatePhieuXuat(String field, dynamic value, String phieu, {required String userName}) async {
    try {
      if (field == PhieuXuatString.ngay) state = state!.copyWith(ngay: value);
      if (field == PhieuXuatString.ngayCT) state = state!.copyWith(ngayCT: value);
      if (field == PhieuXuatString.khoa) state = state!.copyWith(khoa: value == 1 ? true : false);
      if (field == PhieuXuatString.maNX) state = state!.copyWith(maNX: value);
      if (field == PhieuXuatString.kyHieu) state?.kyHieu = value;
      if (field == PhieuXuatString.soHD) state?.soHD = value;
      if (field == PhieuXuatString.dienGiai) state?.dienGiai = value;
      if (field == PhieuXuatString.pttt) state = state!.copyWith(pttt: value);
      if (field == PhieuXuatString.tkNo) state = state!.copyWith(tkNo: value??'');
      if (field == PhieuXuatString.tkCo) state = state!.copyWith(tkCo: value??'');
      if (field == PhieuXuatString.tkVatCo) state = state!.copyWith(tkVatCo: value??'');
      if (field == PhieuXuatString.tkVatNo) state = state!.copyWith(tkVatNo: value??'');
      if (field == PhieuXuatString.congTien) state = state!.copyWith(congTien: value);
      if (field == PhieuXuatString.tienThue) state = state!.copyWith(tienThue: value);

      if (field == PhieuXuatString.kChiuThue) state = state!.copyWith(kChiuThue: value == 1 ? true : false);
      if (field == PhieuXuatString.thueSuat) {
        state?.thueSuat = double.parse(value);
      }
      await _sqlRepository.updateRow({
        field: value,
        PhieuXuatString.updatedBy: userName,
        PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateTienThueGTGT(double value, String phieu, {required String userName}) async {
    try {
      state!.tienThue = value;
      await _sqlRepository.updateRow({
        PhieuXuatString.tienThue: value,
        PhieuXuatString.updatedBy: userName,
        PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateMaKhach(dynamic maKhach, String phieu, {required String userName}) async {
    try {
      String dienGiai =maKhach==null?'': "Bán hàng cho khách $maKhach";

      state = state!.copyWith(maKhach: maKhach ?? '', dienGiai: dienGiai);

      await _sqlRepository.updateRow({
        PhieuXuatString.maKhach: maKhach,
        PhieuXuatString.dienGiai: dienGiai,
        PhieuXuatString.updatedBy: userName,
        PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
      }, where: "Phieu = '$phieu'");
    } catch (e) {
      errorSql(e);
    }
  }
}

class PhieuXuatCTNotifier extends StateNotifier<List<PhieuXuatCTModel>> {
  PhieuXuatCTNotifier() : super([]);
  final _sqlRepository = SqlRepository(tableName: TableName.phieuXuatCT);

  Future<void> getPhieuXuatCT(int maID) async {
    try {
      final data = await _sqlRepository.getData(
        tableNameOther: ViewName.phieuXuatCT,
        where: "${PhieuXuatCTString.maID} = ?",
        whereArgs: [maID],
      );
      state = data.map((e) => PhieuXuatCTModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<int> addPhieuXuatCT(String field, dynamic value, int maID) async {
    try {
      final id = await _sqlRepository.addRow({PhieuXuatCTString.maID: maID, field: value});
      return id;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<void> updateMaHang(int id, {required HangHoaModel hangHoa}) async {
    try {
      await _sqlRepository.updateRow({
        PhieuXuatCTString.tenHH: hangHoa.tenHH,
        PhieuXuatCTString.dvt: hangHoa.donViTinh,
        PhieuXuatCTString.donGia: hangHoa.giaBan,
      }, where: "ID = $id");
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> updateTongTien({
    required PhieuXuatModel phieuXuat,
    required String userName,
    required PhieuXuatNotifier phieuXuatNotifier,
  }) async {
    final data = await _sqlRepository.getCustomData('''
        SELECT SUM(ThanhTien) as TongTien FROM ${ViewName.phieuXuatCT} WHERE MaID = ${phieuXuat.id}
       ''');
    final sum = data.first['TongTien'];
    double tongTien = 0;
    if (sum != null) {
      tongTien = double.parse(sum.toString());
    }
    final tienThue = (phieuXuat.thueSuat * tongTien) / 100;
    if (phieuXuatNotifier.mounted) {
      Future.wait([
        phieuXuatNotifier.updatePhieuXuat(PhieuXuatString.congTien, tongTien, phieuXuat.phieu, userName: userName),
        phieuXuatNotifier.updatePhieuXuat(PhieuXuatString.tienThue, tienThue, phieuXuat.phieu, userName: userName),
      ]);
    } else {
      Future.wait([
        _sqlRepository.updateRow(
          {
            PhieuXuatString.congTien: tongTien,
            PhieuXuatString.updatedBy: userName,
            PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
          },
          where: "Phieu = '${phieuXuat.phieu}'",
          tableNameOther: TableName.phieuXuat,
        ),
        _sqlRepository.updateRow(
          {
            PhieuXuatString.tienThue: tienThue,
            PhieuXuatString.updatedBy: userName,
            PhieuXuatString.updatedAt: Helper.sqlDateTimeNow(hasTime: true),
          },
          where: "Phieu = '${phieuXuat.phieu}'",
          tableNameOther: TableName.phieuXuat,
        ),
      ]);
    }
  }

  Future<int> updatePhieuXuatCT(String field, dynamic value, int id, {int? MaID, WidgetRef? ref}) async {
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

class BCPhieuXuatNotifier extends StateNotifier<List<VBCPhieuXuatModel>> {
  BCPhieuXuatNotifier() : super([]) {
    getBCPhieuXuat(quy: Helper.getQuarterNow(), nam: DateTime.now().year.toString());
  }

  final _sqlRepository = SqlRepository(tableName: ViewName.vbcPhieuXuat);

  Future<void> getBCPhieuXuat({String? thang, String? quy, String? nam}) async {
    try {
      String where = "";

      if (thang == null && quy == null) {
        where = "strftime('%Y', ${PhieuXuatString.ngayCT}) = '$nam'";
      }

      if (quy != null) {
        where = '''strftime('%Y', ${PhieuXuatString.ngayCT}) = '$nam' AND strftime('%m', ${PhieuXuatString.ngayCT}) 
        BETWEEN '${mQuy[quy]?.first}' AND '${mQuy[quy]?.last}'
        ''';
      }
      if (thang != null) {
        if (thang.length == 1) thang = "0$thang";
        where =
            "strftime('%Y', ${PhieuXuatString.ngayCT}) = '$nam' AND strftime('%m', ${PhieuXuatString.ngayCT}) = '$thang'";
      }
      final data = await _sqlRepository.getData(where: where);
      state = data.map((e) => VBCPhieuXuatModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }
}
