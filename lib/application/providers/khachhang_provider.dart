import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/combobox/combobox.dart';

final khachHangProvider = StateNotifierProvider.autoDispose<KhachHangNotifier, List<KhachHangModel>>((ref) {
  return KhachHangNotifier();
});

final khachHangTheoDoiProvider = StateProvider.autoDispose<ComboboxItem>((ref) {
  return  ComboboxItem(value: 'Danh sách khách hàng đang theo dõi', title: [], valueOther: 1);
});


final lstNhaCungProvider = FutureProvider.autoDispose<List<KhachHangModel>>((ref) async {
  final sqlRepository = SqlRepository(tableName: TableName.khachHang);
  final data = await sqlRepository.getData(where: "TheoDoi = ? AND LoaiKH IN (?,?)", whereArgs: [1, "NC", "CH"]);
  return data.map((e)=>KhachHangModel.fromMap(e)).toList();
});// Lấy danh sách nhà cung gán vào combobox


final lstKhachProvider = FutureProvider.autoDispose<List<KhachHangModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.khachHang);
  final data = await sqlRepository.getData(where: "TheoDoi = ? AND LoaiKH IN (?,?)", whereArgs: [1, "KH", "CH"]);
  return data.map((e)=>KhachHangModel.fromMap(e)).toList();
});// Lấy danh sách khách hàng






///Nhóm khách
final nhomKhachProvider = StateNotifierProvider.autoDispose<NhomKhachNotifier, List<NhomKhachModel>>(
  (ref) => NhomKhachNotifier(),
);

final lstNhomKhachProvider = FutureProvider.autoDispose<List<NhomKhachModel>>((ref) async {
  const nhomKhachRepository = SqlRepository(tableName: TableName.nhomKhach);
  final data = await nhomKhachRepository.getData();
  return data.map((e) => NhomKhachModel.fromMap(e)).toList();
});
