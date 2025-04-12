import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lstBangTaiKhoan15Provider = FutureProvider.autoDispose<List<BangTaiKhoanModel>>((ref) async {
  final sqlRepository = SqlRepository(tableName: TableName.bangTaiKhoan);
  final data = await sqlRepository.getData(where: "${BangTaiKhoanString.maLK} =?", whereArgs: ['15']);
  return data.map((e) => BangTaiKhoanModel.fromMap(e)).toList();
}); // Lấy danh sách bảng tài khoản co MALK = 15

final btkListAllProvider = FutureProvider.autoDispose<List<BangTaiKhoanModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.bangTaiKhoan);
  final data = await sqlRepository.getData(where: "MAXL = ?", whereArgs: [0]);
  return data.map((e) => BangTaiKhoanModel.fromMap(e)).toList();
}); // lấy danh sách bảng tải khoản có MAXL = 0

final lstBangTaiKhoanBHTKNoProvider = FutureProvider.autoDispose<List<BangTaiKhoanModel>>((ref) async {
  final sqlRepository = SqlRepository(tableName: TableName.bangTaiKhoan);
  final data = await sqlRepository.getData(where: "${BangTaiKhoanString.maTK}  IN (?,?)", whereArgs: ['156', '632']);
  return data.map((e) => BangTaiKhoanModel.fromMap(e)).toList();
});


final lstBangTaiKhoanBHTKCoProvider = FutureProvider.autoDispose<List<BangTaiKhoanModel>>((ref) async {
  final sqlRepository = SqlRepository(tableName: TableName.bangTaiKhoan);
  final data = await sqlRepository.getData(
    where: "${BangTaiKhoanString.maLK} = ? OR ${BangTaiKhoanString.maTK} = ?",
    whereArgs: ['15', '632'],
  );
  return data.map((e) => BangTaiKhoanModel.fromMap(e)).toList();
});
