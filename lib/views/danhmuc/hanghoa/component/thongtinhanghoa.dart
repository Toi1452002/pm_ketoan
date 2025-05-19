import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/danhmuc/hanghoa/component/dvt.dart';
import 'package:app_ketoan/views/danhmuc/hanghoa/component/nhomhang.dart';
import 'package:app_ketoan/widgets/combobox/combobox.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../../../core/core.dart';
import '../../../../widgets/dialog_windows/dialog_windows.dart';

class ThongTinHangHoaView extends ConsumerStatefulWidget {
  final HangHoaModel? hangHoa;

  const ThongTinHangHoaView({super.key, this.hangHoa});

  @override
  ConsumerState createState() => _ThongTinHangHoaState();
}

class _ThongTinHangHoaState extends ConsumerState<ThongTinHangHoaView> {
  ComboboxItem? _selectLoaiHang;
  ComboboxItem? _selectDonViTinh;
  ComboboxItem? _selectNhomHang;
  String? _selectNhaCung;
  String _selectKhoNgamDinh = '156';

  bool tinhToanTonKho = true;
  bool matHangTheoDoi = true;

  final txtMaHang = TextEditingController();
  final txtTenHang = TextEditingController();
  final txtGiaMua = TextEditingController();
  final txtGiaBan = TextEditingController();
  final txtGhiChu = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.hangHoa != null) {
      final hangHoa = widget.hangHoa;
      txtMaHang.text = hangHoa!.maHH;
      txtTenHang.text = hangHoa.tenHH;
      txtGiaMua.text = Helper.numFormat(hangHoa.giaMua)!;
      txtGiaBan.text = Helper.numFormat(hangHoa.giaBan)!;
      txtGhiChu.text = hangHoa.ghiChu;
      tinhToanTonKho = hangHoa.tinhTon;
      matHangTheoDoi = hangHoa.theoDoi;

      _selectDonViTinh = ComboboxItem(value: hangHoa.donViTinh!, title: [], valueOther: hangHoa.dvtID);
      _selectNhomHang = ComboboxItem(value: hangHoa.nhomHang!, title: [], valueOther: hangHoa.nhomID);
      _selectLoaiHang = ComboboxItem(value: hangHoa.loaiHang!, title: [], valueOther: hangHoa.loaiHHID);
      _selectKhoNgamDinh = hangHoa.tkKho;
      _selectNhaCung = hangHoa.maNC;
    }
    super.initState();
  }

  void _showDonViTinh() {
    showCustomDialog(
      context,
      title: 'ĐƠN VỊ TÍNH',
      width: 290,
      height: 500,
      child: const DVTView(),
      onClose: () async {
        await Future.delayed(const Duration(milliseconds: 300), () {
          ref.refresh(lstDonViTinhProvider);
        });
      },
    );
  }

  void _showNhomHang() {
    showCustomDialog(
      context,
      title: 'NHÓM HÀNG',
      width: 290,
      height: 500,
      child: const NhomHangView(),
      onClose: () async {
        await Future.delayed(const Duration(milliseconds: 300), () => ref.refresh(lstNhomHangProvider));
      },
    );
  }

  void _onSave() async {
    final user = ref.read(userInfoProvider);
    HangHoaModel hangHoa = HangHoaModel(
        maHH: txtMaHang.text,
        tenHH: txtTenHang.text,
        dvtID: _selectDonViTinh?.valueOther == '' ? null : _selectDonViTinh?.valueOther,
        loaiHHID: _selectLoaiHang?.valueOther == '' ? null : _selectLoaiHang?.valueOther,
        nhomID: _selectNhomHang?.valueOther == '' ? null : _selectNhomHang?.valueOther,
        giaMua: Helper.numFormatToDouble(txtGiaMua.text),
        giaBan: Helper.numFormatToDouble(txtGiaBan.text),
        maNC: _selectNhaCung != null && _selectNhaCung!.isEmpty ? null : _selectNhaCung,
        ghiChu: txtGhiChu.text,
        tinhTon: tinhToanTonKho,
        theoDoi: matHangTheoDoi,
        tkKho: _selectKhoNgamDinh);

    if (widget.hangHoa == null) {
      hangHoa = hangHoa.copyWith(createdBy: user?.userName);
      int id = await ref.read(hangHoaProvider.notifier).add(hangHoa);
      if (id != 0) {
        clear();
        // ref.read(hangHoaProvider.notifier).getHangHoa(theoDoi: ref.read(hangHoaTheoiDoiProvider).valueOther,filter: ref.read(hangHoaFilterProvider));
        ref.read(hangHoaProvider.notifier).getHangHoa(theoDoi: ref.read(hangHoaTheoiDoiProvider).valueOther);
      }
    } else {
      hangHoa =
          hangHoa.copyWith(updatedAt: Helper.sqlDateTimeNow(), updatedBy: user?.userName, id: widget.hangHoa!.id!);
      int result = await ref.read(hangHoaProvider.notifier).update(hangHoa, widget.hangHoa!.id!);
      if (result != 0) {
        ref.read(hangHoaProvider.notifier).getHangHoa(theoDoi: ref.read(hangHoaTheoiDoiProvider).valueOther);
        // ref.read(hangHoaFilterProvider.notifier).clearFilter();
        if (mounted) Navigator.pop(context);
      }
    }
  }


  void clear() {
    setState(() {
      _selectLoaiHang = null;
      _selectDonViTinh = null;
      _selectNhomHang = null;
      _selectNhaCung = null;
      _selectKhoNgamDinh = '156';
      tinhToanTonKho = true;
      matHangTheoDoi = true;
    });

    txtMaHang.clear();
    txtTenHang.clear();
    txtGhiChu.clear();
    txtGiaBan.clear();
    txtGiaMua.clear();
  }

  @override
  Widget build(BuildContext context) {
    final lstLoaiHang = ref.watch(lstLoaiHangProvider);
    final lstDVT = ref.watch(lstDonViTinhProvider);
    final lstNhomhang = ref.watch(lstNhomHangProvider);
    final lstNhaCung = ref.watch(lstNhaCungProvider);
    final lstBangTaiKhoan = ref.watch(lstBangTaiKhoan15Provider);

    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            OutlinedContainer(
              padding: EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(child: LabelTextfield(label: 'Mã hàng', spacing: 18,controller: txtMaHang,)),
                      Expanded(
                        child: LabelCombobox(
                          label: 'Loại hàng',
                          spacing: 15,
                          selected: _selectLoaiHang?.value,
                          items:
                              lstLoaiHang.hasValue
                                  ? lstLoaiHang.value!.map((e) {
                                    return ComboboxItem(value: e.loaiHang, title: [e.loaiHang], valueOther: e.id);
                                  }).toList()
                                  : [],
                          onChanged: (String? val, o) {
                            setState(() {
                              _selectLoaiHang = ComboboxItem(value: val ?? '', title: [], valueOther: o);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  LabelTextfield(label: 'Tên hàng', spacing: 17,controller: txtTenHang,),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: LabelCombobox(
                                selected: _selectDonViTinh?.value,
                                items:
                                    lstDVT.hasValue
                                        ? lstDVT.value!.map((e) {
                                          return ComboboxItem(value: e.dvt, title: [e.dvt], valueOther: e.id);
                                        }).toList()
                                        : [],
                                onChanged: (val, o) {
                                  setState(() {
                                    _selectDonViTinh = ComboboxItem(value: val??'', title: [], valueOther: o);
                                  });
                                },
                                label: 'Đơn vị tính',
                              ),
                            ),
                            IconButton.ghost(
                              icon: Icon(Icons.play_arrow),
                              onPressed: _showDonViTinh,
                              size: ButtonSize.small,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: LabelCombobox(
                                selected: _selectNhomHang?.value,

                                items:
                                    lstNhomhang.hasValue
                                        ? lstNhomhang.value!.map((e) {
                                          return ComboboxItem(value: e.nhomHang, title: [e.nhomHang], valueOther: e.id);
                                        }).toList()
                                        : [],
                                onChanged: (val, o) {
                                  setState(() {
                                    _selectNhomHang = ComboboxItem(value: val!, title: [], valueOther: o);
                                  });
                                },
                                label: 'Nhóm hàng',
                              ),
                            ),
                            IconButton.ghost(
                              icon: Icon(Icons.play_arrow),
                              onPressed: _showNhomHang,
                              size: ButtonSize.small,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 25,

                    children: [
                      LabelCombobox(
                        selected: _selectNhaCung,
                        menuWidth: 300,
                        columnWidth: const [100, 198],
                        items:
                            lstNhaCung.hasValue
                                ? lstNhaCung.value!.map((e) {
                                  return ComboboxItem(value: e.maKhach, title: [e.maKhach, e.tenKH]);
                                }).toList()
                                : [],
                        onChanged: (val, o) {
                          setState(() {
                            _selectNhaCung = val??'';
                          });
                        },
                        label: 'Nhà cung',
                        spacing: 15,
                        width: 170,
                      ),
                      Expanded(
                        child: LabelCombobox(
                          columnWidth: const [50, 198],
                          menuWidth: 250,
                          selected: _selectKhoNgamDinh,
                          items:
                              lstBangTaiKhoan.hasValue
                                  ? lstBangTaiKhoan.value!.map((e) {
                                    return ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]);
                                  }).toList()
                                  : [],
                          onChanged: (val, o) {
                            setState(() {
                              _selectKhoNgamDinh = val??'';
                            });
                          },
                          label: 'Kho ngầm định',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 65,
                    children: [
                      Expanded(
                        child: Focus(
                          onFocusChange: (b) {
                            if (!b && txtGiaMua.text.isNotEmpty) {
                              txtGiaMua.text = Helper.numFormat(txtGiaMua.text)!;
                            }
                          },
                          child: LabelTextfield(label: 'Giá mua', controller: txtGiaMua,textAlign: TextAlign.end, spacing: 24, isNumber: true),
                        ),
                      ),
                      Expanded(
                        child: Focus(
                          onFocusChange: (b) {
                            if (!b && txtGiaBan.text.isNotEmpty) {
                              txtGiaBan.text = Helper.numFormat(txtGiaBan.text)!;
                            }
                          },
                          child: LabelTextfield(label: 'Giá bán', controller: txtGiaBan,textAlign: TextAlign.end, isNumber: true),
                        ),
                      ),
                    ],
                  ),
                  LabelTextfield(label: 'Ghi chú', spacing: 28,controller: txtGhiChu,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(state: tinhToanTonKho? CheckboxState.checked:CheckboxState.unchecked, onChanged: (val) {
                        setState(() {
                          tinhToanTonKho = val.index==0;
                        });
                      }, trailing: Text('Tính toán tồn kho')),
                      Checkbox(
                        state:matHangTheoDoi? CheckboxState.checked: CheckboxState.unchecked,
                        onChanged: (val) {
                          setState(() {
                            matHangTheoDoi = val.index == 0;
                          });
                        },
                        trailing: Text('Mặc hàng đang theo dõi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(20),
            Button.primary(onPressed: _onSave, child: Text(widget.hangHoa==null?'Thêm mới':'Cập nhật')),
          ],
        ),
      ),
    );
  }
}
