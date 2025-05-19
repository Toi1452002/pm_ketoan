import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CongNoNotifier extends StateNotifier<List<SoMBHangModel>> {
  CongNoNotifier() : super([]) {
    // getSoMuaHang();
  }

  final _sqlRepository = SqlRepository(tableName: ViewName.vbcSoMuaHang);

  Future<void> getSoMuaHang({required DateTime tN, required DateTime dN, String maKhach = ''}) async {
    try {
      final data = await _sqlRepository.getData(
        where: "${SoMBHangString.ngay} BETWEEN ? AND ? AND MaKhach = ?",
        whereArgs: [Helper.dateFormatYMD(tN), Helper.dateFormatYMD(dN), maKhach],
      );
      state = data.map((e) => SoMBHangModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }

  Future<void> getSoBanHang({required DateTime tN, required DateTime dN, String maKhach = ''}) async {
    try {
      final data = await _sqlRepository.getData(
        where: "${SoMBHangString.ngay} BETWEEN ? AND ? AND MaKhach = ?",
        whereArgs: [Helper.dateFormatYMD(tN), Helper.dateFormatYMD(dN), maKhach],
        tableNameOther: ViewName.vbcSoBanHang,
      );
      state = data.map((e) => SoMBHangModel.fromMap(e)).toList();
    } catch (e) {
      errorSql(e);
    }
  }
}

class TongHopCongNoNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TongHopCongNoNotifier() : super([]){
    // getTongHopCongNo();
  }

  final _sqlRepository = SqlRepository(tableName: '');

  Future<void> getTongHopCongNo({DateTime? ngay}) async {
    ngay ??= DateTime.now();
    final getNo = await _sqlRepository.getCustomData(
      '''SELECT MaKhach FROM ${ViewName.vdmDauKyKhachHang} WHERE Ngay <= '${Helper.dateFormatYMD(ngay)}' AND SoDuNo IS NOT NULL''',
    );

    final getSoBanHang = await _sqlRepository.getCustomData('''
    SELECT DISTINCT MaKhach FROM ${ViewName.vbcSoBanHang} WHERE Ngay <= '${Helper.dateFormatYMD(ngay)}'
    ''');

    final getSoMuaHang = await _sqlRepository.getCustomData('''
    SELECT DISTINCT MaKhach FROM ${ViewName.vbcSoMuaHang} WHERE Ngay <= '${Helper.dateFormatYMD(ngay)}'
    ''');

    List<String> lstNo = getNo.map((e)=>e['MaKhach'].toString()).toList();
    List<String> lstSoBanHang = getSoBanHang.map((e)=>e['MaKhach'].toString()).toList();
    List<String> lstSoMuaHang = getSoMuaHang.map((e)=>e['MaKhach'].toString()).toList();
    List<String> lstKhach = <String>{...lstNo,...lstSoBanHang,...lstSoMuaHang}.toList();

    final getCongNo = await _sqlRepository.getCustomData('''
    SELECT a.MaKhach, a.TenKH,a.LoaiKH,
    (SELECT COALESCE(SUM(No-Co),0)  FROM VBC_SoBanHang sbh WHERE sbh.MaKhach = a.MaKhach AND sbh.Ngay <='${Helper.dateFormatYMD(ngay)}') as PhaiThu,
    (SELECT COALESCE(SUM(No-Co),0)  FROM VBC_SoMuaHang smh WHERE smh.MaKhach = a.MaKhach AND smh.Ngay <='${Helper.dateFormatYMD(ngay)}') as PhaiTra,
    (SELECT COALESCE(SoDuNo,0)  FROM VDM_DKyKhachHang dkKH  WHERE dkKH.MaKhach = a.MaKhach AND dkKH.Ngay <='${Helper.dateFormatYMD(ngay)}' ) as SoDuNo
    FROM TDM_KhachHang a WHERE MaKhach IN(${lstKhach.map((e)=>"'$e'").join(',')})
    ''');
    state = getCongNo.map((e){
      return {
        'MaKhach': e['MaKhach'],
        'TenKH': e['TenKH'],
        'PhaiTra': e['PhaiTra']+(['NC','CH'].contains(e['LoaiKH']) ? e['SoDuNo']??0 :0),
        'PhaiThu': e['PhaiThu'] + (e['LoaiKH']=='KH' ? e['SoDuNo']??0 :0)
      };
    }).toList();
  }
}
