import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../application/application.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';
import '../../banhang/component/danhsach_hanghoa.dart';
import 'danhsach_btk.dart';

class MuaHangCT extends ConsumerStatefulWidget {
  final PhieuNhapModel phieuNhap;
  final String userName;
  final PhieuNhapNotifier phieuNhapNotifier;

  const MuaHangCT({super.key, required this.phieuNhap, required this.userName, required this.phieuNhapNotifier});

  @override
  ConsumerState createState() => _MuaHangCTState();
}

class _MuaHangCTState extends ConsumerState<MuaHangCT> {
  late TrinaGridStateManager _stateManager;
  late PhieuNhapCTNotifier _phieuNhapCTNotifier;
  TrinaGridMode mode = TrinaGridMode.readOnly; // Mặc định là chế độ read

  @override
  void initState() {
    // TODO: implement initState
    _phieuNhapCTNotifier = ref.read(phieuNhapCTProvider.notifier);
    super.initState();
  }

  void _onDelete(TrinaColumnRendererContext re, WidgetRef ref) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'PXCT');
      if (btn == AlertButton.okButton) {
        int result = await _phieuNhapCTNotifier.deletePhieuNhapCT(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
          _phieuNhapCTNotifier.updateTongTien(
            userName: widget.userName,
            phieuNhap: widget.phieuNhap,
            phieuNhapNotifer: widget.phieuNhapNotifier,
          );
        }
      }
    }
  }

  void _onChange(TrinaGridOnChangedEvent e) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert

      int id = await _phieuNhapCTNotifier.addPhieuNhapCT(field, e.value, widget.phieuNhap.id!).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert

        _updateTK(field, e.rowIdx);

        _stateManager.appendNewRows();
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _phieuNhapCTNotifier.updatePhieuNhapCT(field, e.value, id);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
      }

      ///
      if (field == PhieuNhapCTString.soLg) {
        final donGia = e.row.cells[PhieuNhapCTString.donGia]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuNhapCTString.thanhTien]!.value = e.value * donGia;
        _phieuNhapCTNotifier.updatePhieuNhapCT(PhieuNhapCTString.thanhTien, e.value * donGia, id);
        _stateManager.notifyListeners();
      }

      if (field == PhieuNhapCTString.donGia) {
        final soLg = e.row.cells[PhieuNhapCTString.soLg]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuNhapCTString.thanhTien]!.value = e.value * soLg;
        _phieuNhapCTNotifier.updatePhieuNhapCT(PhieuNhapCTString.thanhTien, e.value * soLg, id);
        _stateManager.notifyListeners();
      }

      if (field == PhieuNhapCTString.thanhTien) {
        var soLg = e.row.cells[PhieuNhapCTString.soLg]!.value;

        if (soLg == 0) {
          soLg = 1;
          onSetValueTable(e.rowIdx, PhieuNhapCTString.soLg, 1);
          _phieuNhapCTNotifier.updatePhieuNhapCT(PhieuNhapCTString.soLg, 1, id);
        }
        // if(soLg!=0){
        onSetValueTable(e.rowIdx, PhieuNhapCTString.donGia, e.value / soLg);
        _stateManager.rows[e.rowIdx].cells[PhieuNhapCTString.donGia]!.value = e.value / soLg;
        _phieuNhapCTNotifier.updatePhieuNhapCT(PhieuNhapCTString.donGia, e.value / soLg, id);
        _stateManager.notifyListeners();
        // }
        // else{
        //   onSetValueTable(e.rowIdx, PhieuNhapCTString.thanhTien, 0);
        //   _stateManager.notifyListeners();
        //   CustomAlert().warning('Số lượng phải lớn hơn 0');
        // }
      }
    }
    _phieuNhapCTNotifier.updateTongTien(
      userName: widget.userName,
      phieuNhap: widget.phieuNhap,
      phieuNhapNotifer: widget.phieuNhapNotifier,
    );
  }

  void onChangeMaHang(TrinaGridOnChangedEvent e, {required HangHoaModel hangHoa}) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert
      int id = await _phieuNhapCTNotifier.addPhieuNhapCT(field, e.value, widget.phieuNhap.id!).catchError((e, t) => 0);

      if (id != 0) {
        onSetValueTable(e.rowIdx, 'delete', id); //set id when insert
        _phieuNhapCTNotifier.updateMaHang(id, hangHoa: hangHoa);
        _updateTK(field, e.rowIdx);
        _stateManager.appendNewRows();
      } else {
        onSetValueTable(e.rowIdx, field, ''); // set null if error
      }
    } else {
      ///Update
      int result = await _phieuNhapCTNotifier.updatePhieuNhapCT(field, e.value, id);
      if (result != 0) {
        final soLg = e.row.cells[PhieuNhapCTString.soLg]!.value;
        final donGia = e.row.cells[PhieuNhapCTString.donGia]!.value;
        _phieuNhapCTNotifier.updateMaHang(id, hangHoa: hangHoa);

        _phieuNhapCTNotifier.updatePhieuNhapCT(PhieuNhapCTString.thanhTien, donGia * soLg, id);
        onSetValueTable(e.rowIdx, PhieuNhapCTString.thanhTien, soLg * donGia);
      }
    }
    _phieuNhapCTNotifier.updateTongTien(
      userName: widget.userName,
      phieuNhap: widget.phieuNhap,
      phieuNhapNotifer: widget.phieuNhapNotifier,
    );
  }

  void _updateTK(String field, int index) {
    if (field != PhieuNhapCTString.tkKho) {
      _stateManager.rows[index].cells[PhieuNhapCTString.tkKho]!.value = '156';
      _stateManager.notifyListeners();
    }
  }

  void onChangSelect(TrinaColumnRendererContext re) {
    _stateManager.setKeepFocus(true);
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
  }

  void onSetValueTable(int index, String field, dynamic value) {
    _stateManager.rows[index].cells[field]!.value = value;
  }

  TrinaGridOnChangedEvent onChangeEvent(TrinaColumnRendererContext re, dynamic val) {
    return TrinaGridOnChangedEvent(
      columnIdx: 0,
      column: re.cell.column,
      rowIdx: re.rowIdx,
      row: re.cell.row,
      value: val,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wPhieuNhapCT = ref.watch(phieuNhapCTProvider);
    ref.listen(phieuNhapCTProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.setGridMode(widget.phieuNhap.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal);

      _stateManager.appendRows(
        List.generate(state.length, (index) {
          final x = state[index];
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: index),
              'delete': TrinaCell(value: x.id),
              PhieuNhapCTString.itemID: TrinaCell(value: x.maHH),
              PhieuNhapCTString.tenHH: TrinaCell(value: x.tenHH),
              PhieuNhapCTString.soLg: TrinaCell(value: x.soLg),
              PhieuNhapCTString.dvt: TrinaCell(value: x.dvt),
              PhieuNhapCTString.donGia: TrinaCell(value: x.donGia),
              PhieuNhapCTString.thanhTien: TrinaCell(value: x.thanhTien),
              PhieuNhapCTString.tkKho: TrinaCell(value: x.tkKho),
            },
          );
        }),
      );

      _stateManager.appendNewRows();
      _stateManager.notifyListeners();

    });

    ref.listen(phieuNhapProvider, (context, state) {
      if (state != null) {
        mode = state.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal;

      }
    });
    return DataGrid(
      onLoaded: (e) {
        _stateManager = e.stateManager;
        _stateManager.removeAllRows();
        e.stateManager.setGridMode(widget.phieuNhap.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal);

        _stateManager.appendRows(
          List.generate(wPhieuNhapCT.length, (index) {
            final x = wPhieuNhapCT[index];
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: index),
                'delete': TrinaCell(value: x.id),
                PhieuNhapCTString.itemID: TrinaCell(value: x.maHH),
                PhieuNhapCTString.tenHH: TrinaCell(value: x.tenHH),
                PhieuNhapCTString.soLg: TrinaCell(value: x.soLg),
                PhieuNhapCTString.dvt: TrinaCell(value: x.dvt),
                PhieuNhapCTString.donGia: TrinaCell(value: x.donGia),
                PhieuNhapCTString.thanhTien: TrinaCell(value: x.thanhTien),
                PhieuNhapCTString.tkKho: TrinaCell(value: x.tkKho),
              },
            );
          }),
        );

        _stateManager.appendNewRows();
        _stateManager.notifyListeners();
      },
      onChanged: (e) {
        _onChange(e);
      },
      mode: mode,

      rows: [],
      columns: [
        DataGridColumn(
          title: '',
          field: 'null',
          type: TrinaColumnType.text(),
          width: 20,
          renderer: (re) => DataGridContainer(),
          titleRenderer: (re) => DataGridTitle(title: ''),
          cellPadding: EdgeInsets.zero,
        ),
        DataGridColumn(
          title: '',
          field: 'delete',
          type: TrinaColumnType.text(),
          width: 25,
          titleRenderer: (re) => DataGridTitle(title: ''),
          renderer:
              (re) => DataGridDelete(
                enabled: _stateManager.mode.isEditableMode,
                onTap: () {
                  _onDelete(re, ref);
                },
              ),
          cellPadding: EdgeInsets.zero,
        ),
        DataGridColumn(
          title: 'Mã hàng',
          width: 120,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          cellPadding: EdgeInsets.zero,
          field: PhieuNhapCTString.itemID,
          renderer: (re) {
            return DataGridShowSelect(
              text: re.cell.value,
              enabled: _stateManager.mode.isEditableMode,
              onTap: () {
                onChangSelect(re);
                showCustomDialog(
                  context,
                  barrierDismissible: true,
                  title: 'Chọn hàng hóa',
                  width: 740,
                  height: 420,
                  child: DanhsachHanghoa(
                    isMuaHang: true,
                    maHH: re.cell.value,
                    onChanged: (val) {
                      onChangeMaHang(onChangeEvent(re, val!.id), hangHoa: val);
                      onSetValueTable(re.rowIdx, PhieuNhapCTString.itemID, val.maHH);
                      onSetValueTable(re.rowIdx, PhieuNhapCTString.tenHH, val.tenHH);
                      onSetValueTable(re.rowIdx, PhieuNhapCTString.dvt, val.donViTinh);
                      onSetValueTable(re.rowIdx, PhieuNhapCTString.donGia, val.giaMua);
                      _stateManager.notifyListeners();
                    },
                  ),
                  onClose: () {},
                );
              },
            );
          },
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          width: 300,
          title: 'Tên vật tư - hàng hóa',
          field: PhieuNhapCTString.tenHH,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          enableEditingMode: true,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'ĐVT',
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          enableEditingMode: true,
          width: 80,
          field: DVTString.dvt,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'Số lg',
          enableEditingMode: true,
          width: 80,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          field: PhieuNhapCTString.soLg,
          textAlign: TrinaColumnTextAlign.end,
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
        ),
        DataGridColumn(
          title: 'Đơn giá',
          field: PhieuNhapCTString.donGia,
          textAlign: TrinaColumnTextAlign.end,
          enableEditingMode: true,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
          width: 120,
        ),
        DataGridColumn(
          title: 'Thành tiền',
          field: PhieuNhapCTString.thanhTien,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          textAlign: TrinaColumnTextAlign.end,
          enableEditingMode: true,
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
          width: 120,
        ),
        DataGridColumn(
          title: 'TK Kho',
          width: 90,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          field: PhieuNhapCTString.tkKho,
          type: TrinaColumnType.text(),
          renderer: (re) {
            return DataGridShowSelect(
              enabled: _stateManager.mode.isEditableMode,

              showClear: true,
              onClear: () {
                onChangSelect(re);
                _onChange(onChangeEvent(re, ''));
                onSetValueTable(re.rowIdx, PhieuNhapCTString.tkKho, '');
                _stateManager.notifyListeners();
              },
              text: re.cell.value,
              onTap: () {
                onChangSelect(re);
                showCustomDialog(
                  context,
                  title: 'Chọn TK Nợ',
                  width: 400,
                  height: 300,
                  child: DanhSachBTK(
                    tkNo: true,
                    maTK: re.cell.value,
                    onChanged: (val) {
                      _onChange(onChangeEvent(re, val));
                      onSetValueTable(re.rowIdx, PhieuNhapCTString.tkKho, val);
                    },
                  ),
                  onClose: () {},
                );
              },
            );
          },
        ),
      ],
    );
  }
}
