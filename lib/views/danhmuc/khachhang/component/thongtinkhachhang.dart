import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/danhmuc/khachhang/component/danhmucnhom.dart';
import 'package:app_ketoan/widgets/combobox/combobox.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../../../application/application.dart';
import '../../../../core/core.dart';
import '../../../../widgets/dialog_windows/dialog_windows.dart';

class ThongTinKhachHangView extends ConsumerStatefulWidget {
  final KhachHangModel? khach;

  const ThongTinKhachHangView({super.key, this.khach});

  @override
  ConsumerState createState() => _ThongTinKhachHangState();
}

class _ThongTinKhachHangState extends ConsumerState<ThongTinKhachHangView> {
  String? _nhomSelect;
  String? _loaiKhachSelect = "KH";
  bool _theoDoi = true;

  final txtMaKH = TextEditingController();
  final txtTenKH = TextEditingController();
  final txtDiaChi = TextEditingController();
  final txtDienThoai = TextEditingController();
  final txtDiDong = TextEditingController();
  final txtFax = TextEditingController();
  final txtEmail = TextEditingController();
  final txtMST = TextEditingController();
  final txtSoTK = TextEditingController();
  final txtNganHang = TextEditingController();
  final txtGhiChu = TextEditingController();

  void _showDanhMucNhom() {
    showCustomDialog(
      context,
      title: 'DANH MỤC NHÓM',
      width: 410,
      height: 600,
      child: const DanhMucNhomView(),
      onClose: () async {
        await Future.delayed(const Duration(milliseconds: 300), () {
          ref.refresh(lstNhomKhachProvider);
        });
      },
    );
  }

  @override
  void initState() {
    if (widget.khach != null) {
      final k = widget.khach;
      txtMaKH.text = k!.maKhach;
      txtTenKH.text = k.tenKH;
      txtDiaChi.text = k.diaChi;
      txtDienThoai.text = k.dienThoai;
      txtDiDong.text = k.diDong;
      txtFax.text = k.fax;
      txtEmail.text = k.email;
      txtMST.text = k.mst;
      txtSoTK.text = k.soTK;
      txtNganHang.text = k.nganHang;
      txtGhiChu.text = k.ghiChu;

      // setState(() {
      _theoDoi = k.theoDoi;
      _loaiKhachSelect = k.loaiKH;
      _nhomSelect = k.maNhom;
      // });
    }

    super.initState();
  }

  void _onSave() async {
    final user = ref.read(userInfoProvider);
    KhachHangModel khach = KhachHangModel(
      maKhach: txtMaKH.text,
      tenKH: txtTenKH.text,
      diaChi: txtDiaChi.text,
      dienThoai: txtDienThoai.text,
      diDong: txtDiDong.text,
      fax: txtFax.text,
      email: txtEmail.text,
      mst: txtMST.text,
      soTK: txtSoTK.text,
      nganHang: txtNganHang.text,
      ghiChu: txtGhiChu.text,
      maNhom: _nhomSelect ?? '',
      loaiKH: _loaiKhachSelect,
      theoDoi: _theoDoi,
    );
    if (widget.khach == null) {
      //Insert
      khach = khach.copyWith(createdBy: user!.userName);
      int id = await ref.read(khachHangProvider.notifier).addKhach(khach);
      if (id != 0) {
        clear();
        ref.read(khachHangProvider.notifier).getAll(theoDoi: ref.read(khachHangTheoDoiProvider).valueOther);
      }
    } else {
      //Update
      khach = khach.copyWith(updatedBy: user!.userName, updatedAt: Helper.sqlDateTimeNow());
      int result = await ref.read(khachHangProvider.notifier).updateKhach(khach, widget.khach!.maKhach);
      if (result != 0) {
        ref.read(khachHangProvider.notifier).getAll(theoDoi: ref.read(khachHangTheoDoiProvider).valueOther);
        if (mounted) Navigator.pop(context);
      }
    }
  }

  void clear() {
    txtMaKH.clear();
    txtTenKH.clear();
    txtDiaChi.clear();
    txtDienThoai.clear();
    txtDiDong.clear();
    txtFax.clear();
    txtEmail.clear();
    txtMST.clear();
    txtSoTK.clear();
    txtNganHang.clear();
    txtGhiChu.clear();
    setState(() {
      _loaiKhachSelect = null;
      _nhomSelect = null;
      _theoDoi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wNhomKhach = ref.watch(lstNhomKhachProvider);

    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            OutlinedContainer(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  SizedBox(
                    width: 300,
                    child: LabelTextfield(label: 'Mã khách hàng', spacing: 11, isUpperCase: true, controller: txtMaKH),
                  ),
                  LabelTextfield(label: 'Tên khách hàng', controller: txtTenKH),
                  LabelTextfield(label: 'Địa chỉ', spacing: 64, controller: txtDiaChi),
                  Row(
                    spacing: 25,
                    children: [
                      Expanded(child: LabelTextfield(label: 'Điện thoại', spacing: 42, controller: txtDienThoai)),
                      Expanded(child: LabelTextfield(label: 'Di động', spacing: 36, controller: txtDiDong)),
                    ],
                  ),
                  Row(
                    spacing: 25,

                    children: [
                      Expanded(child: LabelTextfield(label: 'Fax', spacing: 86, controller: txtFax)),
                      Expanded(child: LabelTextfield(label: 'Email', spacing: 53, controller: txtEmail)),
                    ],
                  ),
                  Row(
                    spacing: 25,
                    children: [
                      Expanded(child: LabelTextfield(label: 'Mã số thuế', spacing: 38, controller: txtMST)),
                      Expanded(child: LabelTextfield(label: 'Số tài khoản', controller: txtSoTK)),
                    ],
                  ),
                  LabelTextfield(label: 'Ngân hàng', spacing: 40, controller: txtNganHang),
                ],
              ),
            ),

            OutlinedContainer(
              padding: const EdgeInsets.all(10),
              child: Row(
                spacing: 25,
                children: [
                  Expanded(
                    child: LabelCombobox(
                      columnWidth: [50, 100],
                      readOnly: true,
                      items: [
                        ComboboxItem(value: 'KH', title: ['KH', 'Khách hàng']),
                        ComboboxItem(value: 'NC', title: ['NC', 'Nhà cung']),
                        ComboboxItem(value: 'CH', title: ['CH', 'Cả hai']),
                      ],
                      selected: _loaiKhachSelect,
                      onChanged: (val, o) {
                        setState(() {
                          _loaiKhachSelect = val;
                        });
                      },
                      label: 'Loại khách',
                      spacing: 42,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: LabelCombobox(
                            items:
                                !wNhomKhach.hasValue
                                    ? []
                                    : wNhomKhach.value!.map((e) {
                                      return ComboboxItem(value: e.maNhom, title: [e.maNhom, e.tenNhom]);
                                    }).toList(),
                            columnWidth: [60, 100],

                            selected: _nhomSelect,
                            onChanged: (val, o) {
                              setState(() {
                                _nhomSelect = val;
                              });
                            },
                            label: 'Nhóm',
                            spacing: 50,
                          ),
                        ),
                        IconButton.ghost(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () => _showDanhMucNhom(),
                          size: ButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            OutlinedContainer(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  LabelTextfield(label: 'Ghi chú', controller: txtGhiChu, spacing: 60),
                  Row(
                    children: [
                      Gap(100),
                      Checkbox(
                        state: _theoDoi ? CheckboxState.checked : CheckboxState.unchecked,
                        onChanged: (val) {
                          setState(() {
                            _theoDoi = val.index == 0;
                          });
                        },
                        trailing: Text('Khách đang theo dõi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(2),
            Button.primary(onPressed: _onSave, child: Text(widget.khach == null ? 'Thêm mới' : 'Cập nhật')),
          ],
        ),
      ),
    );
  }
}
