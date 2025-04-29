import 'dart:io';

import 'package:app_ketoan/core/utils/custom_alert.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../application/application.dart';
import '../../core/constants/app_string.dart';
import '../../widgets/widgets.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final txtTaiKhoan = TextEditingController();
  final txtMatKhau = TextEditingController();

  void _login() async{
    try{
      final sqlRepository = SqlRepository(tableName: TableName.user);
      if(txtTaiKhoan.text.isNotEmpty && txtMatKhau.text.isNotEmpty){
          final data = await sqlRepository.getData(where: "${UserString.userName} = ? AND ${UserString.passWord} = ?",whereArgs: [txtTaiKhoan.text,txtMatKhau.text]);
          if(data.isNotEmpty){
            final user = UserModel.fromMap(data.first);
            ref.read(userInfoProvider.notifier).state = user;
            ref.read(tuyChonProvider.notifier).getListTuyChon();
            ref.read(nhomMaC1Provider.notifier).getList(txtTaiKhoan.text);
            ref.read(nhomMaC2Provider.notifier).getList(txtTaiKhoan.text);
            ref.read(hangMucProvider.notifier).getList(txtTaiKhoan.text);
          }else{
            CustomAlert().warning('Đăng nhập thất bại', title: 'Login');

          }
      }
    }catch(e){
      errorSql(e);
    }
  }

  void _duLieu() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['db'],
        type: FileType.custom,
        lockParentWindow: true);
    if (result != null) {
      GetStorage().write(GetKeyStorage.dataPath, result.paths.first);
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.slate[600]
        ),
        child: Center(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.border,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: Colors.gray[700], blurRadius: 10, spreadRadius: 2, offset: const Offset(-5, 5)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'R',
                          style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'G',
                          style: TextStyle(fontSize: 40, color: Colors.green.shade700, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'B',
                          style: TextStyle(fontSize: 40, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // Text('Software and Website',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  //     color: Colors.grey.shade600
                  // ),),
                  OutlinedContainer(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,

                      children: [
                        LabelTextfield(label: 'Tên người dùng',controller: txtTaiKhoan,autofocus: true,),
                        LabelTextfield(label: 'Mật khẩu',obscureText: true, spacing: 48,controller: txtMatKhau,onSubmitted: (val){
                          _login();
                        },),
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PrimaryButton(child: Text('Dữ liệu'), onPressed: () =>_duLieu()),
                            PrimaryButton(child: Text('Vào'), onPressed: () =>_login()),
                            PrimaryButton(child: Text('Thoát'), onPressed: () {
                              exit(0);
                            }),
                          ],
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: context.theme.colorScheme.border,
                          ),
                          child: SelectableText(
                            GetStorage().read(GetKeyStorage.dataPath) ?? '',
                            style: TextStyle(
                              color: Colors.blue.shade900
                            ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
