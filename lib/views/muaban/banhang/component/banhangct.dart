import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/views/muaban/banhang/component/danhsach_hanghoa.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../core/core.dart';
import '../../../../data/data.dart';

class BanHangCT extends ConsumerStatefulWidget {
  final int maID;
  final bool? khoa;

  const BanHangCT({super.key, required this.maID, this.khoa});

  @override
  BanHangCTState createState() => BanHangCTState();
}

class BanHangCTState extends ConsumerState<BanHangCT> {
  late TrinaGridStateManager _stateManager;
  late PhieuXuatCTNotifier _phieuXuatCTNotifier;
  TrinaGridMode mode = TrinaGridMode.normal; // Mặc định là chế độ nhập liệu

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
        }
      }
    }
  }

  void _onChange(TrinaGridOnChangedEvent e) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert

      int id = await _phieuXuatCTNotifier.addPhieuXuatCT(field, e.value, widget.maID).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert
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
      if(field == PhieuXuatCTString.soLg){
        final donGia =  e.row.cells[PhieuXuatCTString.donGia]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuXuatCTString.thanhTien]!.value = e.value * donGia;
        _stateManager.notifyListeners();
      }

      if(field == PhieuXuatCTString.donGia){
        final soLg =  e.row.cells[PhieuXuatCTString.soLg]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuXuatCTString.thanhTien]!.value = e.value * soLg;
        _stateManager.notifyListeners();
      }

      if(field == PhieuXuatCTString.thanhTien){
        final soLg =  e.row.cells[PhieuXuatCTString.soLg]!.value;
        _stateManager.rows[e.rowIdx].cells[PhieuXuatCTString.donGia]!.value = e.value / soLg;
        _stateManager.notifyListeners();
      }
    }
  }

  void onChangeMaHang(TrinaGridOnChangedEvent e, {required HangHoaModel hangHoa}) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert
      int id = await _phieuXuatCTNotifier.addPhieuXuatCT(field, e.value, widget.maID).catchError((e, t) => 0);

      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert
        _phieuXuatCTNotifier.updateMaHang(id, hangHoa: hangHoa);
        _stateManager.appendNewRows();
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _phieuXuatCTNotifier.updatePhieuXuatCT(field, e.value, id);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
        _phieuXuatCTNotifier.updateMaHang(id, hangHoa: hangHoa);
      }



    }
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
        e.stateManager.setGridMode(widget.khoa! ? TrinaGridMode.readOnly : TrinaGridMode.normal);
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
          cellPadding: EdgeInsets.zero,
        ),
        DataGridColumn(
          title: '',
          field: 'delete',
          type: TrinaColumnType.text(),
          width: 25,
          renderer:
              (re) => DataGridDelete(
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
          renderer: (re) {
            return mt.InkWell(
              child: Row(
                children: [
                  Expanded(child: Text(re.cell.value,overflow: TextOverflow.ellipsis,softWrap:  false, style: TextStyle(color: Colors.red))),
                  Icon(PhosphorIcons.caretRight(), color: Colors.red, size: 15),
                ],
              ),
              onTap: () {
                _stateManager.setKeepFocus(true);
                _stateManager.setCurrentCell(re.cell, re.rowIdx);
                showCustomDialog(
                  context,
                  barrierDismissible: true,
                  title: 'Chọn hàng hóa',
                  width: 740,
                  height: 420,
                  child: DanhsachHanghoa(
                    maHH: re.cell.value,
                    onChanged: (val) {
                      onChangeMaHang(
                        TrinaGridOnChangedEvent(
                          columnIdx: 0,
                          column: re.cell.column,
                          rowIdx: re.rowIdx,
                          row: re.cell.row,
                          value: val!.id,
                        ),
                        hangHoa: val,
                      );
                      _stateManager.rows[re.rowIdx].cells[PhieuXuatCTString.itemID]!.value = val.maHH;
                      _stateManager.rows[re.rowIdx].cells[PhieuXuatCTString.tenHH]!.value = val.tenHH;
                      _stateManager.rows[re.rowIdx].cells[PhieuXuatCTString.dvt]!.value = val.donViTinh;
                      _stateManager.rows[re.rowIdx].cells[PhieuXuatCTString.donGia]!.value = val.giaBan;
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
          enableEditingMode: true,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'ĐVT',
          width: 80,
          enableEditingMode: true,
          field: DVTString.dvt,
          type: TrinaColumnType.text(),
        ),
        DataGridColumn(
          title: 'Số lg',
          width: 80,
          field: PhieuXuatCTString.soLg,
          enableEditingMode: true,
          textAlign: TrinaColumnTextAlign.end,
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
        ),
        DataGridColumn(
          title: 'Đơn giá',
          enableEditingMode: true,
          field: PhieuXuatCTString.donGia,
          textAlign: TrinaColumnTextAlign.end,

          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
          width: 120,
        ),
        DataGridColumn(
          title: 'Thành tiền',
          field: PhieuXuatCTString.thanhTien,
          textAlign: TrinaColumnTextAlign.end,
          enableEditingMode: true,
          type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
          width: 120,
        ),
        DataGridColumn(title: 'TK Nợ', width: 90, field: PhieuXuatCTString.tkGV, type: TrinaColumnType.text()),
        DataGridColumn(title: 'TK Có', width: 90, field: PhieuXuatCTString.tkKho, type: TrinaColumnType.text()),
      ],
    );
  }
}
