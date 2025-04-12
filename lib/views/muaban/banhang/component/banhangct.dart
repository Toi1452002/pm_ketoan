import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/views/muaban/banhang/component/danhsach_btk.dart';
import 'package:app_ketoan/views/muaban/banhang/component/danhsach_hanghoa.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../core/core.dart';
import '../../../../data/data.dart';

class BanHangCT extends ConsumerStatefulWidget {
  final PhieuXuatModel phieuXuatModel;
  final String userName;
  final PhieuXuatNotifier phieuXuatNotifier;

  const BanHangCT({
    super.key,
    required this.phieuXuatModel,
    required this.userName,
    required this.phieuXuatNotifier
  });

  @override
  BanHangCTState createState() => BanHangCTState();
}

class BanHangCTState extends ConsumerState<BanHangCT> {
  late TrinaGridStateManager _stateManager;
  late PhieuXuatCTNotifier _phieuXuatCTNotifier;
  TrinaGridMode mode = TrinaGridMode.readOnly; // Mặc định là chế độ nhập liệu

  @override
  void initState() {
    // TODO: implement initState
    _phieuXuatCTNotifier = ref.read(phieuXuatCTProvider.notifier);
    super.initState();
  }


  void _onDelete(TrinaColumnRendererContext re, WidgetRef ref) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'PXCT');
      if (btn == AlertButton.okButton) {
        int result = await _phieuXuatCTNotifier.deletePhieuXuatCT(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
          _phieuXuatCTNotifier.updateTongTien(
              phieuXuat: widget.phieuXuatModel,
              userName: widget.userName,
              phieuXuatNotifier: widget.phieuXuatNotifier

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

      int id = await _phieuXuatCTNotifier.addPhieuXuatCT(field, e.value, widget.phieuXuatModel.id!).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert

        _updateTK(field, e.rowIdx);

        _stateManager.appendNewRows();
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _phieuXuatCTNotifier.updatePhieuXuatCT(field, e.value, id);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
      }

      ///
      if (field == PhieuXuatCTString.soLg) {
        final donGia = e.row.cells[PhieuXuatCTString.donGia]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuXuatCTString.thanhTien]!.value = e.value * donGia;
        _phieuXuatCTNotifier.updatePhieuXuatCT(PhieuXuatCTString.thanhTien, e.value * donGia, id);
        _stateManager.notifyListeners();
      }

      if (field == PhieuXuatCTString.donGia) {
        final soLg = e.row.cells[PhieuXuatCTString.soLg]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuXuatCTString.thanhTien]!.value = e.value * soLg;
        _phieuXuatCTNotifier.updatePhieuXuatCT(PhieuXuatCTString.thanhTien, e.value * soLg, id);
        _stateManager.notifyListeners();
      }

      if (field == PhieuXuatCTString.thanhTien) {
        var soLg = e.row.cells[PhieuXuatCTString.soLg]!.value;
        if (soLg == 0) {
          soLg = 1;
          onSetValueTable(e.rowIdx, PhieuXuatCTString.soLg, 1);
          _phieuXuatCTNotifier.updatePhieuXuatCT(PhieuXuatCTString.soLg, 1, id);
        }
        onSetValueTable(e.rowIdx, PhieuXuatCTString.donGia, e.value / soLg);
        _stateManager.rows[e.rowIdx].cells[PhieuXuatCTString.donGia]!.value = e.value / soLg;
        _phieuXuatCTNotifier.updatePhieuXuatCT(PhieuXuatCTString.donGia, e.value / soLg, id);
        _stateManager.notifyListeners();
      }
    }
    _phieuXuatCTNotifier.updateTongTien(
        phieuXuat: widget.phieuXuatModel,
        userName: widget.userName,
        phieuXuatNotifier: widget.phieuXuatNotifier

    );
  }

  void onChangeMaHang(TrinaGridOnChangedEvent e, {required HangHoaModel hangHoa}) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert
      int id = await _phieuXuatCTNotifier.addPhieuXuatCT(field, e.value, widget.phieuXuatModel.id!).catchError((e, t) => 0);

      if (id != 0) {
        onSetValueTable(e.rowIdx, 'delete', id); //set id when insert
        _phieuXuatCTNotifier.updateMaHang(id, hangHoa: hangHoa);
        _updateTK(field, e.rowIdx);
        _stateManager.appendNewRows();
      } else {
        onSetValueTable(e.rowIdx, field, ''); // set null if error
      }
    } else {
      ///Update
      int result = await _phieuXuatCTNotifier.updatePhieuXuatCT(field, e.value, id);
      if (result != 0) {
        final soLg = e.row.cells[PhieuXuatCTString.soLg]!.value;
        final donGia = e.row.cells[PhieuXuatCTString.donGia]!.value;
        _phieuXuatCTNotifier.updateMaHang(id, hangHoa: hangHoa);

        _phieuXuatCTNotifier.updatePhieuXuatCT(PhieuXuatCTString.thanhTien, donGia * soLg, id);
        onSetValueTable(e.rowIdx, PhieuXuatCTString.thanhTien, soLg * donGia);
      }
    }
    _phieuXuatCTNotifier.updateTongTien(
      phieuXuat: widget.phieuXuatModel,
      userName: widget.userName,
        phieuXuatNotifier: widget.phieuXuatNotifier

    );
  }

  void _updateTK(String field, int index) {
    if (field != PhieuXuatCTString.tkGV && field != PhieuXuatCTString.tkKho) {
      _stateManager.rows[index].cells[PhieuXuatCTString.tkGV]!.value = '632';
      _stateManager.rows[index].cells[PhieuXuatCTString.tkKho]!.value = '156';
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
    final wPhieuXuatCT = ref.watch(phieuXuatCTProvider);
    ref.listen(phieuXuatCTProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        List.generate(state.length, (index) {
          final x = state[index];
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: index),
              'delete': TrinaCell(value: x.id),
              PhieuXuatCTString.itemID: TrinaCell(value: x.maHH),
              PhieuXuatCTString.tenHH: TrinaCell(value: x.tenHH),
              PhieuXuatCTString.soLg: TrinaCell(value: x.soLg),
              PhieuXuatCTString.dvt: TrinaCell(value: x.dvt),
              PhieuXuatCTString.donGia: TrinaCell(value: x.donGia),
              PhieuXuatCTString.thanhTien: TrinaCell(value: x.thanhTien),
              PhieuXuatCTString.tkGV: TrinaCell(value: x.tkGV),
              PhieuXuatCTString.tkKho: TrinaCell(value: x.tkKho),
            },
          );
        }),
      );

      _stateManager.appendNewRows();
    });

    ref.listen(phieuXuatProvider, (context, state) {
      if (state != null) {
        mode = state.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal;
      }
    });

    return DataGrid(
      onLoaded: (e) {
        _stateManager = e.stateManager;
        _stateManager.removeAllRows();
        e.stateManager.setGridMode(widget.phieuXuatModel.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal);

        _stateManager.appendRows(
          List.generate(wPhieuXuatCT.length, (index) {
            final x = wPhieuXuatCT[index];
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: index),
                'delete': TrinaCell(value: x.id),
                PhieuXuatCTString.itemID: TrinaCell(value: x.maHH),
                PhieuXuatCTString.tenHH: TrinaCell(value: x.tenHH),
                PhieuXuatCTString.soLg: TrinaCell(value: x.soLg),
                PhieuXuatCTString.dvt: TrinaCell(value: x.dvt),
                PhieuXuatCTString.donGia: TrinaCell(value: x.donGia),
                PhieuXuatCTString.thanhTien: TrinaCell(value: x.thanhTien),
                PhieuXuatCTString.tkGV: TrinaCell(value: x.tkGV),
                PhieuXuatCTString.tkKho: TrinaCell(value: x.tkKho),
              },
            );
          }),
        );

        _stateManager.appendNewRows();
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
          titleRenderer: (re)=>DataGridTitle(title: ''),
          cellPadding: EdgeInsets.zero,
        ),
        DataGridColumn(
          title: '',
          field: 'delete',
          type: TrinaColumnType.text(),
          width: 25,
          titleRenderer: (re)=>DataGridTitle(title: ''),
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
          field: PhieuXuatCTString.itemID,
          cellPadding: EdgeInsets.zero,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
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
                    maHH: re.cell.value,
                    onChanged: (val) {
                      onChangeMaHang(onChangeEvent(re, val!.id), hangHoa: val);
                      onSetValueTable(re.rowIdx, PhieuXuatCTString.itemID, val.maHH);
                      onSetValueTable(re.rowIdx, PhieuXuatCTString.tenHH, val.tenHH);
                      onSetValueTable(re.rowIdx, PhieuXuatCTString.dvt, val.donViTinh);
                      onSetValueTable(re.rowIdx, PhieuXuatCTString.donGia, val.giaBan);
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
          field: PhieuXuatCTString.tenHH,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          enableEditingMode: true,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'ĐVT',
          width: 80,
          enableEditingMode: true,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          field: DVTString.dvt,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'Số lg',
          width: 80,
          field: PhieuXuatCTString.soLg,
          enableEditingMode: true,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          textAlign: TrinaColumnTextAlign.end,
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
        ),
        DataGridColumn(
          title: 'Đơn giá',
          enableEditingMode: true,
          field: PhieuXuatCTString.donGia,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          textAlign: TrinaColumnTextAlign.end,

          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
          width: 120,
        ),
        DataGridColumn(
          title: 'Thành tiền',
          field: PhieuXuatCTString.thanhTien,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          textAlign: TrinaColumnTextAlign.end,
          enableEditingMode: true,
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
          width: 120,
        ),
        DataGridColumn(
          title: 'TK Nợ',
          width: 90,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          renderer: (re) {
            return DataGridShowSelect(
              enabled: _stateManager.mode.isEditableMode,

              showClear: true,
              onClear: () {
                onChangSelect(re);
                _onChange(onChangeEvent(re, ''));
                onSetValueTable(re.rowIdx, PhieuXuatCTString.tkGV, '');
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
                      onSetValueTable(re.rowIdx, PhieuXuatCTString.tkGV, val);
                    },
                  ),
                  onClose: () {},
                );
              },
            );
          },
          field: PhieuXuatCTString.tkGV,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'TK Có',
          width: 90,
          titleRenderer: (re)=>DataGridTitle(title: re.column.title),
          renderer: (re) {
            return DataGridShowSelect(
              enabled: _stateManager.mode.isEditableMode,

              showClear: true,
              onClear: () {
                onChangSelect(re);
                onChangeEvent(re, '');
                onSetValueTable(re.rowIdx, PhieuXuatCTString.tkKho, '');
                _stateManager.notifyListeners();
              },
              text: re.cell.value,
              onTap: () {
                onChangSelect(re);
                showCustomDialog(
                  context,
                  title: 'Chọn TK Có',
                  width: 400,
                  height: 300,
                  child: DanhSachBTK(
                    onChanged: (val) {
                      _onChange(onChangeEvent(re, val));
                      onSetValueTable(re.rowIdx, PhieuXuatCTString.tkKho, val);
                    },
                    tkCo: true,
                    maTK: re.cell.value,
                  ),
                  onClose: () {},
                );
              },
            );
          },
          field: PhieuXuatCTString.tkKho,
          type: TrinaColumnType.text(),
        ),
      ],
    );
  }
}
