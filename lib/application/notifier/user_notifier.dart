import 'package:app_ketoan/core/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ketoan/data/data.dart';


class UserNotifier extends StateNotifier<List<UserModel>> {
  UserNotifier() : super([]){
    getUsers();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.user);

  Future<void> getUsers() async{
    try{
      final data = await _sqlRepository.getData(orderBy: UserString.userName);
      state = data.map((e)=>UserModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<int> addUser(UserModel user)async{
    try{
      final id = await _sqlRepository.addRow(user.toMap());
      if(id!=0){
        getUsers();
        await Future.wait([
          _sqlRepository.addRows(getMaHangMuc().map((e){
            return {
              UserString.userName: user.userName,
              'TenForm': e
            };
          }).toList(),tableNameOther: TableName.hangMuc),
          _sqlRepository.addRows(getMaNhomC1().map((e){
            return {
              UserString.userName: user.userName,
              'MaC1': e
            };
          }).toList(),tableNameOther: TableName.nhomMC1),
          _sqlRepository.addRows(getMaNhomC2().map((e){
            return {
              UserString.userName: user.userName,
              'MaC2': e
            };
          }).toList(),tableNameOther: TableName.nhomMC2)
        ]);
      }
      return id;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> updateUser(UserModel user) async{
    try{
      final result = await _sqlRepository.updateRow(user.toMap(),where: "${UserString.id} = '${user.id}'",);
      if(result==1){
        getUsers();
      }
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<void> deleteUser(int id) async{
    try{
      await _sqlRepository.delete(where: "${UserString.id} = '$id'");
      state.removeWhere((e)=>e.id == id);
    }catch(e){
      errorSql(e);
    }
  }
  Future<int> changeAccountUser(int id, String username, String password) async{
    try{
      final result = await _sqlRepository.updateRow({
        UserString.userName: username,
        UserString.passWord: password
      },where: "${UserString.id} = $id");
      if(result==1){
        getUsers();
      }
      return result;
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

}