import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../../../application/application.dart';


class ThayDoiTaiKhoan extends ConsumerWidget {
   ThayDoiTaiKhoan({super.key});
  final txtTenDangNhapCu = TextEditingController();
  final txtMatKhauCu = TextEditingController();
  final txtTenDangNhapMoi = TextEditingController();
  final txtMatKhauMoi = TextEditingController();
  final txtNhapLaiMatKhau = TextEditingController();
   void _onXacNhan(WidgetRef ref, BuildContext context) async {
     final user = ref.read(userInfoProvider);

     if ([txtTenDangNhapCu.text, txtMatKhauCu.text, txtTenDangNhapMoi.text, txtMatKhauMoi.text, txtNhapLaiMatKhau.text]
         .contains('')) {
       CustomAlert().error('Không được bỏ trống bất cứ ô nào');
       return;
     }

     if (txtTenDangNhapCu.text != user?.userName) {
       CustomAlert().error('Tên đăng nhập cũ không khớp');
       return;
     }
     if (txtMatKhauCu.text != user?.passWord) {
       CustomAlert().error('Mật khẩu cũ không khớp');
       return;
     }

     if (txtNhapLaiMatKhau.text != txtMatKhauMoi.text) {
       CustomAlert().error('Nhập lại mật khẩu sai');
       return;
     }

     int result = await ref.read(userProvider.notifier).changeAccountUser(user!.id!, txtTenDangNhapMoi.text, txtMatKhauMoi.text);

     if (result == 1) {
       final btn = await CustomAlert().success('Cập nhật thành công, đăng nhập lại');
       if(btn==AlertButton.okButton){
         ref.read(userInfoProvider.notifier).state = null;
         Navigator.pop(context);
         Navigator.pop(context);
       }
     }
   }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(backgroundColor: context.theme.colorScheme.border,child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 20,
        children: [
          OutlinedContainer(padding: EdgeInsets.all(10),child: Column(spacing: 10,children: [
            LabelTextfield(label: 'Tên đăng nhập cũ',spacing: 16,controller: txtTenDangNhapCu,),
            LabelTextfield(label: 'Mật khẩu cũ',obscureText: true,spacing: 50,controller: txtMatKhauCu,),
          ],)),
          OutlinedContainer(padding: EdgeInsets.all(10),child: Column(spacing: 10,children: [
            LabelTextfield(label: 'Tên đăng nhập mới',controller: txtTenDangNhapMoi,),
            LabelTextfield(label: 'Mật khẩu mới',obscureText: true,spacing: 44,controller: txtMatKhauMoi,),
            LabelTextfield(label: 'Nhập lại mật khẩu',obscureText: true,spacing: 17,controller: txtNhapLaiMatKhau,),
          ],)),
          Button.primary(onPressed: ()=>_onXacNhan(ref, context),child: Text('Chấp nhận'),)

        ],
      ),
    ));
  }
}