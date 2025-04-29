import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/constants.dart';

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
      ]).whenComplete(() {
        getListTuyChon();
      });

      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
}

class NhomMC1Notifier extends StateNotifier<List<MaDMModel>> {
  NhomMC1Notifier()
    : super(getMaNhomC1().map((e)=>MaDMModel(ma: e)).toList()
      // [
        // MaDMModel(ma: 'TDM'),
        // MaDMModel(ma: 'TNX'),
        // MaDMModel(ma: 'TTC'),
        // MaDMModel(ma: 'TCN'),
        // MaDMModel(ma: 'TKH'),
        // MaDMModel(ma: 'TGT'),
        // MaDMModel(ma: 'TLU'),
        // MaDMModel(ma: 'TTS'),
        // MaDMModel(ma: 'TKT'),
        // MaDMModel(ma: 'THT'),
      // ]
  );
  final _sqlRepository = SqlRepository(tableName: TableName.nhomMC1);

  Future<void> getList(String userName) async {
    try {
      final data = await _sqlRepository.getData(where: 'UserName = ?', whereArgs: [userName]);
      state = data.map((e) => MaDMModel.fromMap(e, field: 'MaC1')).toList();
    } catch (e) {
      errorSql(e);
    }
  }
}

class NhomMC2Notifier extends StateNotifier<List<MaDMModel>> {
  NhomMC2Notifier()
    : super(getMaNhomC2().map((e)=>MaDMModel(ma: e)).toList()
      // [
      //   MaDMModel(ma: 'TDM1'),
      //   MaDMModel(ma: 'TNX1'),
      //   MaDMModel(ma: 'TTC1'),
      //   MaDMModel(ma: 'TKT1'),
      //   MaDMModel(ma: 'TKT2'),
      //   MaDMModel(ma: 'TKT3'),
      // ]
  );
  final _sqlRepository = SqlRepository(tableName: TableName.nhomMC2);

  Future<void> getList(String userName) async {
    try {
      final data = await _sqlRepository.getData(where: 'UserName = ?', whereArgs: [userName]);
      state = data.map((e) => MaDMModel.fromMap(e, field: 'MaC2')).toList();
    } catch (e) {
      errorSql(e);
    }
  }
}

class HangMucNotifier extends StateNotifier<List<MaDMModel>> {
  HangMucNotifier()
    : super(getMaHangMuc().map((e)=>MaDMModel(ma: e)).toList()
      // [
      //   MaDMModel(ma: 'F00_CusInfo'), //TTDN 0
      //   MaDMModel(ma: 'F00_DSUser'), //1
      //   MaDMModel(ma: 'F00_PhanQuyenUser'), //2
      //   MaDMModel(ma: 'F00_TuyChon'), //3
      //
      //   MaDMModel(ma: 'FDM_BkeHangHoa'), //4
      //   MaDMModel(ma: 'FDM_BkeKhachHang'), //5
      //   MaDMModel(ma: 'FDM_BkeNhanVien'), //6
      //   MaDMModel(ma: 'FDM_MaNghiepVu'), //7
      //   MaDMModel(ma: 'FDM_BangTaiKhoan'), //8
      //   MaDMModel(ma: 'FDM_DkyKhachHang'), //9
      //   MaDMModel(ma: 'FDM_DkyHangHoa'), //10
      //   MaDMModel(ma: 'FDM_DKyTaiKhoan'), //11
      //
      //   MaDMModel(ma: 'FNX_PhieuNhap'), //12
      //   MaDMModel(ma: 'FNX_PhieuXuat'), //13
      //   MaDMModel(ma: 'FNX_BkeHoaDonMua'), //14
      //   MaDMModel(ma: 'FNX_BkeHoaDonBan'), //15
      //   MaDMModel(ma: 'FNX_BkeHangBan'), //16
      //
      //   MaDMModel(ma: 'FTC_PhieuThu'), //17
      //   MaDMModel(ma: 'FTC_PhieuChi'), //18
      //   MaDMModel(ma: 'FTC_BkePhieuThu'), //19
      //   MaDMModel(ma: 'FTC_BkePhieuChi'), //20
      //   MaDMModel(ma: 'FTC_SoQuyTM'), //21
      //   MaDMModel(ma: 'FTC_SoTGNH'), //22
      //
      //   MaDMModel(ma: 'FCN_SoMuaHang'), //23
      //   MaDMModel(ma: 'FCN_SoBanHang'), //24
      //   MaDMModel(ma: 'FCN_TongHopCongNo'), //25
      //
      //   MaDMModel(ma: 'FNX_BkeHangNhap'), //26
      //   MaDMModel(ma: 'FNX_BkeHangXuat'), //27
      //   MaDMModel(ma: 'FNX_NhapXuatTon'), //28
      //
      //   MaDMModel(ma: 'FGT_TinhGiaVon'), //29
      //   MaDMModel(ma: 'GT1'), //30
      //   MaDMModel(ma: 'GT2'), //31
      //   MaDMModel(ma: 'GT3'), //32
      //   MaDMModel(ma: 'GT4'), //33
      //
      //   MaDMModel(ma: 'FTL_BangCong'), //34
      //   MaDMModel(ma: 'FTL_BangLuong'), //35
      //
      //   MaDMModel(ma: 'FTS_BangKHTSCD'), //36
      //   MaDMModel(ma: 'FTS_BangPBCCDC'), //37
      //
      //   MaDMModel(ma: 'FKT_SoNKChung'), //38
      //   MaDMModel(ma: 'FKT_SoCaiTK'), //39
      //   MaDMModel(ma: 'FKT_SoChiTietTK'), //40
      //
      //   MaDMModel(ma: 'FKT_ThueTNDNtt'), //41
      //   MaDMModel(ma: 'FKT_BangCDPS'), //42
      //   MaDMModel(ma: 'FKT_BangCDKT'), //43
      //   MaDMModel(ma: 'FKT_BaoCaoKQKD'), //44
      //   MaDMModel(ma: 'FKT_BaoCaoLCTT'), //45
      //   MaDMModel(ma: 'FKT_BaoCaoTMTC'), //46
      //
      //   MaDMModel(ma: 'FKT_ChuyenLo'), //47
      //   MaDMModel(ma: 'FKT_ThueTNDN'), //48
      //   MaDMModel(ma: 'FKT_ThueTNCN'), //49
      //   MaDMModel(ma: 'FKT_SoThue'), //50
      // ]
  );
  final _sqlRepository = SqlRepository(tableName: TableName.hangMuc);

  Future<void> getList(String userName) async {
    try {
      final data = await _sqlRepository.getData(where: 'UserName = ?', whereArgs: [userName]);
      state = data.map((e) => MaDMModel.fromMap(e, field: 'TenForm')).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<bool?> getChoPhep(String tableName, String wField, String wValue, String userName) async {
    try {
      final data = await _sqlRepository.getCellValue(
        field: 'ChoPhep',
        where: "$wField = '$wValue' AND UserName = '$userName'",
        tableNameOther: tableName,
      );
      if (data != null) {
        return data == '1' ? true : false;
      } else {
        return null;
      }
    } catch (e) {
      errorSql(e);
      return null;
    }
  }

  Future<void> updateChoPhep(
    String tableName,
    String field,
    dynamic value,
    String userName,
    String wField,
    String wValue,
  ) async {
    try {
      await _sqlRepository.updateCell(
        field: 'ChoPhep',
        value: value,
        where: "$wField = ? AND UserName = ?",
        whereArgs: [wValue, userName],
        tableNameOther: tableName,
      );
    } catch (e) {
      errorSql(e);
    }
  }
}
