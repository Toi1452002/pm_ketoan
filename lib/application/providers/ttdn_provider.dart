import 'package:app_ketoan/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';



final ttdnProvider = StateNotifierProvider.autoDispose<ThongTinDoanhNghiepNotifier, List<TTDNModel>>((ref) {
  return ThongTinDoanhNghiepNotifier();
});
final ttdnTenCTyProvider = FutureProvider.autoDispose<String>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.ttdn);
  return await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'TCT'") ?? '';
});


final ttdnDiaChiProvider = FutureProvider.autoDispose<String>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.ttdn);
  return await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'DC'") ?? '';
});