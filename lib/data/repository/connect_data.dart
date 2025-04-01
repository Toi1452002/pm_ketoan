import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../core/core.dart';

Future<Database?> connectData() async{
  try{
    final cnn = await databaseFactory.openDatabase(GetStorage().read(GetKeyStorage.dataPath));
    await cnn.execute('PRAGMA foreign_keys = ON');
    return cnn;
  }catch(e){
    throw Exception(e);
  }
}
