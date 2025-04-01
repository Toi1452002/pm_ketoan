import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/combobox/combobox.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../../../application/application.dart';

class ThongTinUser extends ConsumerStatefulWidget {
  final UserModel? user;

  const ThongTinUser({super.key, this.user});

  @override
  ThongTinUserState createState() => ThongTinUserState();
}

class ThongTinUserState extends ConsumerState<ThongTinUser> {
  String selectLevel = '1';
  final txtHoTen = TextEditingController();
  final txtDienThoai = TextEditingController();
  final txtDiaChi = TextEditingController();
  final txtEmail = TextEditingController();
  final txtGhiChu = TextEditingController();
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();


  @override
  void initState() {
    if(widget.user!=null){
      final user = widget.user;
      txtHoTen.text = user!.hoTen;
      txtDienThoai.text = user.dienThoai;
      txtDiaChi.text = user.diaChi;
      txtEmail.text = user.email;
      txtGhiChu.text = user.ghiChu;
      txtUsername.text = user.userName;
      txtPassword.text = user.passWord;
      selectLevel = user.level.toString();
    }
    super.initState();
  }
  void _onSave()  async{
    UserModel user = UserModel(userName: txtUsername.text,
        passWord: txtPassword.text,
        level: int.parse(selectLevel),
        hoTen: txtHoTen.text,
        dienThoai: txtDienThoai.text,
        diaChi: txtDiaChi.text,
        email: txtEmail.text,
        ghiChu: txtGhiChu.text);

    if(widget.user==null){
      int id = await ref.read(userProvider.notifier).addUser(user);
      if(id!= 0 && mounted){
        Navigator.pop(context);
      }
    }else{
      user = user.copyWith(id: widget.user!.id);
      int result = await ref.read(userProvider.notifier).updateUser(user);
      if(result ==1 && mounted){
        Navigator.pop(context);
      }
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          children: [
            OutlinedContainer(
              padding: EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                children: [
                  LabelTextfield(label: 'Họ và tên',spacing: 15,controller: txtHoTen,),
                  LabelTextfield(label: 'Điện thoại',controller: txtDienThoai,),
                  LabelTextfield(label: 'Địa chỉ',spacing: 32,controller: txtDiaChi,),
                  LabelTextfield(label: 'Email',spacing: 42,controller: txtEmail,),
                  LabelTextfield(label: 'Ghi chú', maxLines: 2,spacing: 28,controller: txtGhiChu,),
                ],
              ),
            ),
            OutlinedContainer(
              padding: EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                children: [
                  LabelTextfield(label: 'Username',spacing: 15,controller: txtUsername,),
                  LabelTextfield(label: 'Password',spacing: 20,controller: txtPassword,obscureText: true,),
                  LabelCombobox(
                    spacing: 47,
                    label: 'Level',
                    selected: selectLevel,
                    readOnly: true,
                    enabled: widget.user!=null && widget.user!.id==1 ?  false : true,
                    columnWidth: const [30, 100],
                    items: [
                      ComboboxItem(value: '1', title: ['1', 'Cấp nhân viên']),
                      ComboboxItem(value: '2', title: ['2', 'Cấp quản trị']),
                    ],
                    onChanged: (String? val, o) {
                      setState(() {
                        selectLevel = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Button.primary(onPressed: _onSave,child: Text(widget.user==null?'Thêm mới':'Cập nhật'),)
          ],
        ),
      ),
    );
  }
}
