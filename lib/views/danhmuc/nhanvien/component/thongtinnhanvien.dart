import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:app_ketoan/widgets/date_textbox.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../application/application.dart';
import '../../../../core/core.dart';
import '../../../../widgets/widgets.dart';

class ThongTinNhanVienView extends ConsumerStatefulWidget {
  final NhanVienModel? nhanVien;

  const ThongTinNhanVienView({super.key, this.nhanVien});

  @override
  ConsumerState createState() => _ThongTinNhanVienViewState();
}

class _ThongTinNhanVienViewState extends ConsumerState<ThongTinNhanVienView> {
  late TrinaGridStateManager _stateManager;
  late NhanVienNotifier _nhanVienNotifier;
  late PCvaGTNotifier _pCvaGTNotifier;

  // final List<PCvaGTModel> _lstPCvaGT = [];
  final _txtMaNV = TextEditingController();
  final _txtHoTen = TextEditingController();
  final _txtDienThoai = TextEditingController();
  final _txtCCCD = TextEditingController();
  final _txtMST = TextEditingController();
  final _txtDiaChi = TextEditingController();
  final _txtGhiChu = TextEditingController();

  final _txtChucDanh = TextEditingController();
  final _txtTrinhDo = TextEditingController();
  final _txtChuyenMon = TextEditingController();
  final _txtLuongCB = TextEditingController(text: '0');

  bool _gioiTinh = false;
  bool _thoiVu = true;
  bool _khongCuTru = true;
  bool _coCamKet = false;
  bool _theoDoi = true;
  DateTime? _ngaySinh;
  DateTime? _ngayVaoLam;
  int indexTab = 0;

  void onSave() async {
    // if(_stateManager != null){
    _stateManager.setCurrentCell(_stateManager.firstCell, 0);
    // }
    NhanVienModel nv = NhanVienModel(
      maNV: _txtMaNV.text.trim(),
      hoTen: _txtHoTen.text.trim(),
      phai: _gioiTinh,
      ngaySinh: Helper.dateFormatYMD(_ngaySinh),
      cccd: _txtCCCD.text.trim(),
      mst: _txtMST.text.trim(),
      diaChi: _txtDiaChi.text.trim(),
      dienThoai: _txtDienThoai.text.trim(),
      trinhDo: _txtTrinhDo.text.trim(),
      chuyenMon: _txtChuyenMon.text.trim(),
      ngayVao: Helper.dateFormatYMD(_ngayVaoLam),
      chucDanh: _txtChucDanh.text.trim(),
      luongCB: Helper.numFormatToDouble(_txtLuongCB.text),
      thoiVu: _thoiVu,
      khongCuTru: _khongCuTru,
      coCk: _coCamKet,
      ghiChu: _txtGhiChu.text,
      theoDoi: _theoDoi,
    );

    if (widget.nhanVien == null) {
      final id = await _nhanVienNotifier.addNhanVien(nv);
      if (id != 0 && mounted) {
        // _nhanVienNotifier.getListNhanVien(filter: ref.read(nvFilterProvider));
        _nhanVienNotifier.getListNhanVien();
        Navigator.pop(context);
        await _pCvaGTNotifier.addData(_txtMaNV.text.trim());
      }
    } else {
      nv = nv.copyWith(id: widget.nhanVien!.id, maNV: _txtMaNV.text.trim());
      final result = await _nhanVienNotifier.updateNhanVien(nv);
      if (result != 0 && mounted) {
        _nhanVienNotifier.getListNhanVien();
        // ref.read(nvFilterProvider.notifier).clearFilter();
        Navigator.pop(context);
        await _pCvaGTNotifier.addData(_txtMaNV.text.trim());
      }
    }
  }

  @override
  void initState() {
    _nhanVienNotifier = ref.read(nhanVienProvider.notifier);
    _pCvaGTNotifier = ref.read(pcvagtProvider.notifier);
    if (widget.nhanVien != null) {
      final nv = widget.nhanVien;
      _txtMaNV.text = nv!.maNV;
      _txtHoTen.text = nv.hoTen;
      _ngaySinh = Helper.stringToDate(nv.ngaySinh);
      _gioiTinh = nv.phai;
      _txtDienThoai.text = nv.dienThoai;
      _txtCCCD.text = nv.cccd;
      _txtMST.text = nv.mst;
      _txtDiaChi.text = nv.diaChi;
      _txtGhiChu.text = nv.ghiChu;
      _ngayVaoLam = Helper.stringToDate(nv.ngayVao);
      _txtChucDanh.text = nv.chucDanh;
      _txtTrinhDo.text = nv.trinhDo;
      _txtChuyenMon.text = nv.chuyenMon;
      _thoiVu = nv.thoiVu;
      _khongCuTru = nv.khongCuTru;
      _coCamKet = nv.coCk;
      _theoDoi = nv.theoDoi;
      _txtLuongCB.text = Helper.numFormat(nv.luongCB)!;
      _pCvaGTNotifier.getPCGT(maNV: nv.maNV);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final lstMoTaPCGT = ref.watch(pcvagtProvider);

    ref.listen(pcvagtProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.maPC),
              MoTaPCGTTLString.moTa: TrinaCell(value: e.moTa),
              PCvaGTString.soTieuChuan: TrinaCell(value: e.soTieuChuan),
            },
          );
        }).toList(),
      );
    });

    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 10,
          children: [
            OutlinedContainer(
              padding: EdgeInsets.all(10),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(flex: 2, child: LabelTextfield(label: 'Mã nhân viên', controller: _txtMaNV)),
                  Expanded(flex: 3, child: LabelTextfield(label: 'Họ và tên', controller: _txtHoTen)),
                ],
              ),
            ),
            Gap(20),
            Tabs(
              index: indexTab,
              onChanged: (val) {
                setState(() {
                  indexTab = val;
                });
              },
              children: [
                TabItem(child: Text('Thông tin cá nhân')),
                TabItem(child: Text('Thông tin công ty')),
                TabItem(child: Text('Phụ cấp + giảm trừ')),
              ],
            ),
            IndexedStack(
              index: indexTab,
              children: [
                // Thông tin cá nhân
                OutlinedContainer(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 320,
                            child: DateTextbox(
                              onChanged: (val) {
                                setState(() {
                                  _ngaySinh = val;
                                });
                              },
                              label: 'Ngày sinh',
                              spacing: 12,
                              initialDate: _ngaySinh,
                            ),
                          ),
                          Gap(20),
                          Text('Giới tính'),
                          Checkbox(
                            state: _gioiTinh ? CheckboxState.checked : CheckboxState.unchecked,
                            onChanged: (val) {
                              setState(() {
                                _gioiTinh = val.index == 0;
                              });
                            },
                            trailing: Text('Nữ'),
                          ),
                        ],
                      ),
                      LabelTextfield(label: 'Điện thoại', controller: _txtDienThoai),
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(child: LabelTextfield(label: 'CCCD', controller: _txtCCCD, spacing: 40)),
                          Expanded(child: LabelTextfield(label: 'MST', controller: _txtMST)),
                        ],
                      ),
                      LabelTextfield(label: 'Địa chỉ', controller: _txtDiaChi, spacing: 32),
                      LabelTextfield(label: 'Ghi chú', maxLines: 2, controller: _txtGhiChu, spacing: 28),
                    ],
                  ),
                ),

                //Thông tin công ty
                OutlinedContainer(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                            child: DateTextbox(
                              onChanged: (val) {
                                setState(() {
                                  _ngayVaoLam = val;
                                });
                              },
                              label: 'Ngày vào làm',
                              initialDate: _ngayVaoLam,
                            ),
                          ),
                          Expanded(child: LabelTextfield(label: 'Chức danh', controller: _txtChucDanh, spacing: 22)),
                        ],
                      ),
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(child: LabelTextfield(label: 'Trình độ', controller: _txtTrinhDo, spacing: 39)),
                          Expanded(child: LabelTextfield(label: 'Chuyên môn', controller: _txtChuyenMon)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Checkbox(
                              state: _thoiVu ? CheckboxState.checked : CheckboxState.unchecked,
                              onChanged: (val) {
                                setState(() {
                                  _thoiVu = val.index == 0;
                                });
                              },
                              leading: Text('Thời vụ'),
                            ),
                          ),
                          Expanded(
                            child: Visibility(
                              visible: _thoiVu,
                              child: Checkbox(
                                state: _khongCuTru ? CheckboxState.checked : CheckboxState.unchecked,
                                onChanged: (val) {
                                  setState(() {
                                    _khongCuTru = val.index == 0;
                                    _coCamKet = !(val.index == 0);
                                  });
                                },
                                leading: Text('Không cư trú'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Visibility(
                              visible: !_khongCuTru && _thoiVu,
                              child: Checkbox(
                                state: _coCamKet ? CheckboxState.checked : CheckboxState.unchecked,
                                onChanged: (val) {
                                  setState(() {
                                    _coCamKet = val.index == 0;
                                  });
                                },
                                leading: Text('Có cam kết 08'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Phụ cấp + Giảm trừ
                OutlinedContainer(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Focus(
                        onFocusChange: (b) {
                          if (!b && _txtLuongCB.text.isNotEmpty) {
                            _txtLuongCB.text = Helper.numFormat(_txtLuongCB.text)!;
                          }
                        },
                        child: SizedBox(
                          width: 300,
                          child: LabelTextfield(label: 'Lương cơ bản', controller: _txtLuongCB, isNumber: true),
                        ),
                      ),
                      Expanded(
                        child: DataGrid(
                          onChanged: (e) {
                            _pCvaGTNotifier.updateData(e.row.cells['null']!.value, double.parse(e.value.toString()));
                          },
                          onLoaded: (event) {
                            _stateManager = event.stateManager;
                          },
                          rows: [],
                          columns: [
                            DataGridColumn(
                              title: '',
                              field: 'null',
                              type: TrinaColumnType.text(),
                              width: 20,
                              renderer: (re) => const DataGridContainer(),
                              titleRenderer: (re) => DataGridTitle(title: ''),
                              cellPadding: EdgeInsets.zero,
                            ),
                            DataGridColumn(
                              title: 'Mô tả',
                              titleRenderer: (re) => DataGridTitle(title: re.column.title),
                              field: MoTaPCGTTLString.moTa,
                              type: TrinaColumnType.text(),
                            ),
                            DataGridColumn(
                              title: 'Tiêu chuẩn',
                              textAlign: TrinaColumnTextAlign.end,
                              field: PCvaGTString.soTieuChuan,
                              titleRenderer: (re) => DataGridTitle(title: re.column.title),
                              type: TrinaColumnType.number(),
                              enableEditingMode: true,
                              footerRenderer: (e) {
                                return TrinaAggregateColumnFooter(
                                  rendererContext: e,
                                  alignment: Alignment.centerRight,
                                  type: TrinaAggregateColumnType.sum,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).sized(height: 400),
            Gap(10),
            Row(
              children: [
                const Gap(280),
                PrimaryButton(onPressed: onSave, child: Text(widget.nhanVien == null ? 'Thêm mới' : 'Cập nhật')),
                const Spacer(),
                Checkbox(
                  state: _theoDoi ? CheckboxState.checked : CheckboxState.unchecked,
                  onChanged: (val) {
                    setState(() {
                      _theoDoi = val.index == 0;
                    });
                  },
                  leading: Text('Đang làm việc'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
