import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../widgets/widgets.dart';
import '../application.dart';

final hangHoaProvider = StateNotifierProvider.autoDispose<HangHoaNotifier, List<HangHoaModel>>(
  (ref) => HangHoaNotifier(),
); //Provider chính của hàng hóa

final hangHoaGetListProvider = FutureProvider.autoDispose<List<HangHoaModel>>((ref) async {
  final sqlRepository = SqlRepository(tableName: ViewName.hangHoa);
  final data = await sqlRepository.getData(where: '${HangHoaString.theoDoi} = ?',whereArgs: [1]);
  return data.map((e)=>HangHoaModel.fromMap(e)).toList();
  // ref.read(lstHangHoaProvider.notifier).state = data.map((e)=>HangHoaModel.fromMap(e)).toList();
});

// final lstHangHoaProvider = StateProvider<List<HangHoaModel>>((ref) {
//   return [];
// });


final lstLoaiHangProvider = FutureProvider.autoDispose<List<LoaiHangModel>>((ref) async {
  final sqlRepository = SqlRepository(tableName: TableName.loaiHang);
  final data  = await sqlRepository.getData();
  return data.map((e)=>LoaiHangModel.fromMap(e)).toList();
});//Lấy danh sách loại hàng gán vào combobox

final lstDonViTinhProvider = FutureProvider.autoDispose<List<DonViTinhModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.dvt);
  final data = await sqlRepository.getData();
  return data.map((e)=>DonViTinhModel.fromMap(e)).toList();
});// Láy danh sách đơn vị tinh gán vào combobox

final lstNhomHangProvider = FutureProvider.autoDispose<List<NhomHangModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.nhomHang);
  final data = await sqlRepository.getData();
  return data.map((e)=>NhomHangModel.fromMap(e)).toList();
});// Lấy danh sách nhóm hàng gán vào combobox



final nhomHangProvider =
StateNotifierProvider.autoDispose<NhomHangNotifier, List<NhomHangModel>>((ref) => NhomHangNotifier()); // CRUD Nhóm hàng


final dvtProvider =
StateNotifierProvider.autoDispose<DonViTinhNotifier, List<DonViTinhModel>>((ref) => DonViTinhNotifier()); // CRUD đơn vị tính


final hangHoaTheoiDoiProvider = StateProvider.autoDispose<ComboboxItem>((ref) {
  return  ComboboxItem(value: 'Danh sách hàng hóa đang theo dõi', title: [], valueOther: 1);
});// Lọc theo dõi hàng hóa