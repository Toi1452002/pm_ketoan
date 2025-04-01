import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/hethong/user/component/thaydoi_taikhoan.dart';
import 'package:app_ketoan/views/hethong/user/component/thongtin_user.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../../application/application.dart';
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';

class UserView extends ConsumerWidget {
  UserView({super.key});

  List<UserModel> _lstUser = [];

  late TrinaGridStateManager _stateManager;
  
  void _showThongTinUser(BuildContext context, {UserModel? user}) {
    showCustomDialog(context,
        title: 'THÔNG TIN NGƯỜI DÙNG',
        width: 500,
        height: 490,
        child: ThongTinUser(user: user,),
        onClose: () {});
  }
  Future<void> _onDelete(TrinaColumnRendererContext re, WidgetRef ref) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value == 1) {
      CustomAlert().warning('Không thể xóa quản trị', title: 'User');
    } else {
      if (re.cell.value != '') {
        final btn = await CustomAlert().warning(AppString.delete, title: 'User');
        if (btn == AlertButton.okButton) {
          await ref.read(userProvider.notifier).deleteUser(re.cell.value);
          _stateManager.removeCurrentRow();
        }
      }
    }
  }
  void _showThayDoiTaiKhoan(BuildContext context) {
    showCustomDialog(context, title: 'THAY ĐỔI TÀI KHOẢN NGƯỜI DÙNG',
        width: 500,
        height: 350,
        child: ThayDoiTaiKhoan(),
        onClose: (){});
  }
  void _onDoubleTapUsername(TrinaGridOnRowDoubleTapEvent event, WidgetRef ref, BuildContext context){
    final userLogin = ref.read(userInfoProvider);
    if (event.cell.column.field == UserString.userName) {
      final user = _lstUser.firstWhere((e) => e.userName == event.cell.value);
      if(userLogin?.id==1){//  cho phép chỉnh sửa thông tin user
        _showThongTinUser(context, user: user);
      }
      if(userLogin?.id!=1 && userLogin?.id == user.id){// chỉ chỉnh sửa thông tin của bản thân
        _showThayDoiTaiKhoan(context);
      }
    }
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLogin = ref.read(userInfoProvider);

    ref.listen(userProvider, (context, state) {
      if (state.isNotEmpty) {
        _lstUser = state;
        _stateManager.removeAllRows();
        _stateManager.appendRows(
          List.generate(state.length, (i) {
            final user = state[i];
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: "", renderer: (context) => DataGridContainer()),
                'delete': TrinaCell(value: user.id),
                UserString.userName: TrinaCell(value: user.userName,renderer: (context)=>Text(context.cell.value,style: TextStyle(color: Colors.red),).small()),
                UserString.hoTen: TrinaCell(value: user.hoTen),
                UserString.email: TrinaCell(value: user.email),
                UserString.dienThoai: TrinaCell(value: user.dienThoai),
              },
            );
          }),
        );
      }
    });
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconButton.outline(icon: Icon(Icons.add), onPressed: () =>_showThongTinUser(context), size: ButtonSize.normal, enabled: ref.read(userInfoProvider)?.id == 1),
          ],
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) => _onDoubleTapUsername(event, ref, context),
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnTypeText(),
              width: 20,
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(
              title: '',
              field: 'delete',
              renderer: (re) {
                return DataGridDelete(
                  onTap:
                      ref.read(userInfoProvider)?.id == 1
                          ? () {
                            _onDelete(re, ref);
                          }
                          : null,
                );
              },
              type: TrinaColumnTypeText(),
              width: 25,
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(title: 'Username', field: UserString.userName, type: TrinaColumnTypeText(), width: 150),
            DataGridColumn(title: 'Họ và tên', field: UserString.hoTen, type: TrinaColumnTypeText(), width: 200),
            DataGridColumn(title: 'Email', field: UserString.email, type: TrinaColumnTypeText(), width: 200),
            DataGridColumn(title: 'Điện thoại', field: UserString.dienThoai, type: TrinaColumnTypeText(), width: 200),
          ],
        ),
      ),
    );
  }
}
