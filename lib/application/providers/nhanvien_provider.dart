import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../application.dart';

final nhanVienProvider = StateNotifierProvider.autoDispose<NhanVienNotifier, List<NhanVienModel>>((ref) {
  return NhanVienNotifier();
});

final nvListAllProvider = FutureProvider.autoDispose<List<NhanVienModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.nhanVien);
  final data = await sqlRepository.getData(where: "TheoDoi = ?", whereArgs: [1]);
  return data.map((e)=>NhanVienModel.fromMap(e)).toList();
});// Lấy danh sách nhân viên

// final moTaPCGTProvider = FutureProvider.autoDispose<List<MoTaPCGTModel>>((ref) async {
//   const sql = SqlRepository(tableName: TableName.moTaPCGTTL);
//   final data = await sql.getData();
//   return data.map((e)=>MoTaPCGTModel.fromMap(e)).toList();
// });//Lấy danh sách PC và GT để hiện lên lưới lúc insert nhân viên


final pcvagtProvider = StateNotifierProvider.autoDispose<PCvaGTNotifier, List<PCvaGTModel>>((ref) {
  return PCvaGTNotifier();
});
//
// final nvFilterProvider = StateNotifierProvider.autoDispose<NhanVienFilterNotifier, NhanVienFilter>((ref) {
//   return NhanVienFilterNotifier();
// });
//
//
// class NhanVienFilter{
//   final String? maNV;
//   final String? hoTen;
//   final String? phai;
//   final String? ngaySinh;
//   final String? diaChi;
//   final String? trinhDo;
//   final String? chuyenMon;
//
//   const NhanVienFilter({
//     this.maNV,
//     this.hoTen,
//     this.phai,
//     this.ngaySinh,
//     this.diaChi,
//     this.trinhDo,
//     this.chuyenMon,
//   });
//
//   NhanVienFilter copyWith({
//     String? maNV,
//     String? hoTen,
//     String? phai,
//     String? ngaySinh,
//     String? diaChi,
//     String? trinhDo,
//     String? chuyenMon,
//   }) {
//     return NhanVienFilter(
//       maNV: maNV ?? this.maNV,
//       hoTen: hoTen ?? this.hoTen,
//       phai: phai ?? this.phai,
//       ngaySinh: ngaySinh ?? this.ngaySinh,
//       diaChi: diaChi ?? this.diaChi,
//       trinhDo: trinhDo ?? this.trinhDo,
//       chuyenMon: chuyenMon ?? this.chuyenMon,
//     );
//   }
// }