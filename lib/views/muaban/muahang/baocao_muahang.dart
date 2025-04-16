import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/muaban/muahang/component/pdf_bcmuahang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/providers/phieunhap_provider.dart';
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';

class BaoCaoMuaHangView extends ConsumerStatefulWidget {
  const BaoCaoMuaHangView({super.key});

  @override
  ConsumerState createState() => _BaoCaoMuaHangViewState();
}

class _BaoCaoMuaHangViewState extends ConsumerState<BaoCaoMuaHangView> {
  late TrinaGridStateManager _stateManager;
  String selected = "Quý";
  String quy = Helper.getQuarterNow();
  String thang = DateTime.now().month.toString();
  final txtNam = TextEditingController(text: DateTime.now().year.toString());
    final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
    bool enabelFilter = false;

  Map<String, String> _mapThucHien = {
    'Select': 'Quý',
    'Quy': Helper.getQuarterNow(),
    'Thang': DateTime.now().month.toString(),
    'Nam': DateTime.now().year.toString(),
  };
  Map<String, List<dynamic>> filters = {
    PhieuNhapString.kyHieu: [],
    PhieuNhapString.ngayCT: [],
    PhieuNhapString.soCT: [],
    KhachHangString.tenKH: [],
    KhachHangString.mst: [],
    PhieuNhapString.congTien: [],
    PhieuNhapString.tienThue: [],
    PhieuNhapString.dienGiai: [],
  };


  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((TrinaRow row) {
      bool kyHieu =
          filters[PhieuNhapString.kyHieu]!.isEmpty ||
          filters[PhieuNhapString.kyHieu]!.contains(row.cells[PhieuNhapString.kyHieu]!.value);
      bool ngayCT =
          filters[PhieuNhapString.ngayCT]!.isEmpty ||
          filters[PhieuNhapString.ngayCT]!.contains(row.cells[PhieuNhapString.ngayCT]!.value);
      bool soHD =
          filters[PhieuNhapString.soCT]!.isEmpty ||
          filters[PhieuNhapString.soCT]!.contains(row.cells[PhieuNhapString.soCT]!.value);
      bool tenKH =
          filters[KhachHangString.tenKH]!.isEmpty ||
          filters[KhachHangString.tenKH]!.contains(row.cells[KhachHangString.tenKH]!.value);
      bool mst =
          filters[KhachHangString.mst]!.isEmpty ||
          filters[KhachHangString.mst]!.contains(row.cells[KhachHangString.mst]!.value);
      bool congTien =
          filters[PhieuNhapString.congTien]!.isEmpty ||
          filters[PhieuNhapString.congTien]!.contains(row.cells[PhieuNhapString.congTien]!.value);
      bool tienThue =
          filters[PhieuNhapString.tienThue]!.isEmpty ||
          filters[PhieuNhapString.tienThue]!.contains(row.cells[PhieuNhapString.tienThue]!.value);
      bool ghiChu =
          filters[PhieuNhapString.dienGiai]!.isEmpty ||
          filters[PhieuNhapString.dienGiai]!.contains(row.cells[PhieuNhapString.dienGiai]!.value);
      return kyHieu && ngayCT && soHD && tenKH && mst && congTien && tienThue && ghiChu;
    });
    setState(() {});
  }
  Widget _buildTitle(TrinaColumnTitleRendererContext render, {bool isNgay = false, bool isNummber = false}) {
    return trinaGridFuntion.builTitle(
      render,
      filters,
      _applyFilters,
      isNgay: isNgay,
      isNummber: isNummber,
      enabelFilter: enabelFilter,
    );
  }
  void clearFilter() {
    filters = {
      PhieuNhapString.kyHieu: [],
      PhieuNhapString.ngayCT: [],
      PhieuNhapString.soCT: [],
      KhachHangString.tenKH: [],
      KhachHangString.mst: [],
      PhieuNhapString.congTien: [],
      PhieuNhapString.tienThue: [],
      PhieuNhapString.dienGiai: [],
    };
    _applyFilters();
  }
  @override
  Widget build(BuildContext context) {
    final qlXBC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == 'qlXBC').giaTri == 1; //Nếu bằng 1 thi xem bc truoc khi in
    ref.listen(bcPhieuNhapProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              PhieuNhapString.kyHieu: TrinaCell(value: e.kyHieu),
              PhieuNhapString.soCT: TrinaCell(value: e.soCT),
              PhieuNhapString.ngayCT: TrinaCell(value: e.ngayCT),
              KhachHangString.tenKH: TrinaCell(value: e.tenKH),
              KhachHangString.mst: TrinaCell(value: e.mst),
              PhieuNhapString.congTien: TrinaCell(value: e.congTien),
              PhieuNhapString.tienThue: TrinaCell(value: e.tienThue),
              PhieuNhapString.dienGiai: TrinaCell(value: e.dienGiai),
            },
          );
        }).toList(),
      );
    });
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          leading: [
            IconPrinter(
              onPressed: () async {
                if (qlXBC) {
                  showViewPrinter(context, PdfBCMuaHang(
                    stateManager: _stateManager,
                    dateNow: Helper.dateNowDMY(),
                    mapThucHien: _mapThucHien,
                  ),isPortrait: false);
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfBCMuaHang(
                      stateManager: _stateManager,
                      dateNow: Helper.dateNowDMY(),
                      mapThucHien: _mapThucHien,
                    ),
                    format: PdfPageFormat.a4.landscape,
                  );
                }
              },
            ),
            IconExcel(
              onPressed: () {
                excelBCMuaHang(_stateManager);
              },
            ),
            IconFilter(
              onPressed: () {
                enabelFilter = !enabelFilter;
                if (!enabelFilter) {
                  clearFilter();
                }
                setState(() {});
              },
              isFilter: enabelFilter,
            ),
            Gap(30),
            SizedBox(
              width: 130,
              child: LabelCombobox(
                selected: selected,
                items: [
                  ComboboxItem(value: 'Tháng', title: ['Tháng']),
                  ComboboxItem(value: 'Quý', title: ['Quý']),
                  ComboboxItem(value: 'Năm', title: ['Năm']),
                ],
                label: 'Chọn',
                readOnly: true,
                onChanged: (val, o) {
                  setState(() {
                    selected = val!;
                    quy = Helper.getQuarterNow();
                    thang = DateTime.now().month.toString();
                  });
                },
              ),
            ),
            Gap(10),
            SizedBox(
              width: 100,
              child:
                  !['Quý', 'Tháng'].contains(selected)
                      ? null
                      : LabelCombobox(
                        selected: selected == 'Quý' ? quy : thang,
                        items: List.generate(selected == 'Quý' ? 4 : 12, (index) {
                          return ComboboxItem(value: '${index + 1}', title: ['${index + 1}']);
                        }),
                        label: selected,
                        readOnly: false,
                        onChanged: (val, o) {
                          if (selected == "Quý") {
                            quy = val!;
                          } else {
                            thang = val!;
                          }
                          setState(() {});
                        },
                      ),
            ),
            Gap(10),
            SizedBox(width: 100, child: LabelTextfield(label: 'Năm', controller: txtNam, isNumber: true)),
            PrimaryButton(
              onPressed: () {
                ref
                    .read(bcPhieuNhapProvider.notifier)
                    .getBCPhieuNhap(
                      nam: txtNam.text,
                      thang: selected == 'Tháng' ? thang : null,
                      quy: selected == 'Quý' ? quy : null,
                    );
                setState(() {
                  filters = {
                    PhieuNhapString.kyHieu: [],
                    PhieuNhapString.ngayCT: [],
                    PhieuNhapString.soCT: [],
                    KhachHangString.tenKH: [],
                    KhachHangString.mst: [],
                    PhieuNhapString.congTien: [],
                    PhieuNhapString.tienThue: [],
                    PhieuNhapString.dienGiai: [],
                  };
                });

                _mapThucHien = {'Select': selected, 'Thang': thang, 'Quy': quy, 'Nam': txtNam.text};
              },
              size: ButtonSize(.8),
              child: Text('Thực hiện'),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onRowDoubleTap: (event) {
            if (event.cell.column.field == PhieuNhapString.soCT) {
              showMuaHang(context, stt: event.row.cells['null']!.value);
            }
          },
          onLoaded: (e) {
            _stateManager = e.stateManager;
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              titleRenderer: (re) => DataGridTitle(title: ''),
              type: TrinaColumnTypeText(),
              width: 25,
              renderer: (re) {
                return DataGridContainer(text: "${re.rowIdx+1}",);
              },
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(
              title: 'Ký hiệu',
              width: 80,
              field: PhieuNhapString.kyHieu,
              type: TrinaColumnTypeText(),
              titleRenderer: (re)=>_buildTitle(re)
            ),
            DataGridColumn(
              title: 'Số HD',
              width: 80,
              field: PhieuNhapString.soCT,
              type: TrinaColumnTypeText(),
              titleRenderer: (re)=>_buildTitle(re),
              renderer: (re) {
                return Text(re.cell.value, style: TextStyle(color: Colors.red));
              },
            ),
            DataGridColumn(
              title: 'Ngày HD',
              width: 100,
              field: PhieuNhapString.ngayCT,
              type: TrinaColumnType.date(format: 'dd/MM/yyyy'),
              titleRenderer: (re)=>_buildTitle(re,isNgay: true),
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              width: 300,
              field: KhachHangString.tenKH,
              titleRenderer: (re)=>_buildTitle(re),
              type: TrinaColumnTypeText(),
            ),
            DataGridColumn(
              title: 'Mã số thuế',
              width: 120,
              titleRenderer: (re)=>_buildTitle(re),
              field: KhachHangString.mst,
              type: TrinaColumnTypeText(),
            ),
            DataGridColumn(
              title: 'Tiền chưa VAT',
              width: 120,
              field: PhieuNhapString.congTien,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re)=>_buildTitle(re),
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  type: TrinaAggregateColumnType.sum,
                  alignment: Alignment.centerRight,
                  titleSpanBuilder: (text) {
                    return [
                      TextSpan(text: text, style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ];
                  },
                );
              },
              type: TrinaColumnType.number(),
            ),
            DataGridColumn(
              title: 'Tiền thuế',
              width: 120,
              titleRenderer: (re)=>_buildTitle(re),
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  type: TrinaAggregateColumnType.sum,
                  alignment: Alignment.centerRight,
                  titleSpanBuilder: (text) {
                    return [
                      TextSpan(text: text, style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ];
                  },
                );
              },
              field: PhieuNhapString.tienThue,
              type: TrinaColumnType.number(),
            ),
            DataGridColumn(
              title: 'Ghi chú',
              titleRenderer: (re)=>_buildTitle(re),
              width: 245,
              field: PhieuNhapString.dienGiai,
              type: TrinaColumnTypeText(),
            ),
          ],
        ),
      ),
    );
  }
}
