import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ketoan/data/data.dart';


class UserNotifier extends StateNotifier<List<UserModel>> {
  UserNotifier() : super([]){
    getUsers();
  }

  final _sqlRepository = SqlRepository(tableName: TableName.user);

  Future<void> getUsers() async{
    try{
      final data = await _sqlRepository.getData();
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