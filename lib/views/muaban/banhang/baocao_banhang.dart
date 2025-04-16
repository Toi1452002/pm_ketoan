import 'package:app_ketoan/application/providers/phieuxuat_provider.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/muaban/banhang/component/pdf_bcbanhang.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class BaoCaoBanHangView extends ConsumerStatefulWidget {
  const BaoCaoBanHangView({super.key});

  @override
  ConsumerState createState() => _BaoCaoBanHangViewState();
}

class _BaoCaoBanHangViewState extends ConsumerState<BaoCaoBanHangView> {
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
    PhieuXuatString.kyHieu: [],
    PhieuXuatString.ngayCT: [],
    PhieuXuatString.soHD: [],
    KhachHangString.tenKH: [],
    KhachHangString.mst: [],
    PhieuXuatString.congTien: [],
    PhieuXuatString.tienThue: [],
    PhieuXuatString.dienGiai: [],
  };


  // Áp dụng bộ lọc cho tất cả cột
    void _applyFilters() {
    _stateManager.setFilter((TrinaRow row) {
      bool kyHieu =
          filters[PhieuXuatString.kyHieu]!.isEmpty ||
          filters[PhieuXuatString.kyHieu]!.contains(row.cells[PhieuXuatString.kyHieu]!.value);
      bool ngayCT =
          filters[PhieuXuatString.ngayCT]!.isEmpty ||
          filters[PhieuXuatString.ngayCT]!.contains(row.cells[PhieuXuatString.ngayCT]!.value);
      bool soHD =
          filters[PhieuXuatString.soHD]!.isEmpty ||
          filters[PhieuXuatString.soHD]!.contains(row.cells[PhieuXuatString.soHD]!.value);
      bool tenKH =
          filters[KhachHangString.tenKH]!.isEmpty ||
          filters[KhachHangString.tenKH]!.contains(row.cells[KhachHangString.tenKH]!.value);
      bool mst =
          filters[KhachHangString.mst]!.isEmpty ||
          filters[KhachHangString.mst]!.contains(row.cells[KhachHangString.mst]!.value);
      bool congTien =
          filters[PhieuXuatString.congTien]!.isEmpty ||
          filters[PhieuXuatString.congTien]!.contains(row.cells[PhieuXuatString.congTien]!.value);
      bool tienThue =
          filters[PhieuXuatString.tienThue]!.isEmpty ||
          filters[PhieuXuatString.tienThue]!.contains(row.cells[PhieuXuatString.tienThue]!.value);
      bool ghiChu =
          filters[PhieuXuatString.dienGiai]!.isEmpty ||
          filters[PhieuXuatString.dienGiai]!.contains(row.cells[PhieuXuatString.dienGiai]!.value);
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
      PhieuXuatString.kyHieu: [],
      PhieuXuatString.ngayCT: [],
      PhieuXuatString.soHD: [],
      KhachHangString.tenKH: [],
      KhachHangString.mst: [],
      PhieuXuatString.congTien: [],
      PhieuXuatString.tienThue: [],
      PhieuXuatString.dienGiai: [],
    };
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final qlXBC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='qlXBC').giaTri==1;//Nếu bằng 1 thi xem bc truoc khi in

    ref.listen(bcPhieuXuatProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              PhieuXuatString.kyHieu: TrinaCell(value: e.kyHieu),
              PhieuXuatString.soHD: TrinaCell(value: e.soHD),
              PhieuXuatString.ngayCT: TrinaCell(value: e.ngayCT),
              KhachHangString.tenKH: TrinaCell(value: e.tenKH),
              KhachHangString.mst: TrinaCell(value: e.mst),
              PhieuXuatString.congTien: TrinaCell(value: e.congTien),
              PhieuXuatString.tienThue: TrinaCell(value: e.tienThue),
              PhieuXuatString.dienGiai: TrinaCell(value: e.dienGiai),
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
                if(qlXBC){
                  showViewPrinter(context, PdfBCBanHang(
                    stateManager: _stateManager,
                    dateNow: Helper.dateNowDMY(),
                    mapThucHien: _mapThucHien,
                  ),isPortrait: false);
                }else{
                  PdfWidget().onPrint(onLayout: pdfBCBanHang(
                    stateManager: _stateManager,
                    dateNow: Helper.dateNowDMY(),
                    mapThucHien: _mapThucHien,
                  ),format: PdfPageFormat.a4.landscape);
                }


              },
            ),
            IconExcel(onPressed: () {
              excelBCBanHang(_stateManager);
            }),
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
                    .read(bcPhieuXuatProvider.notifier)
                    .getBCPhieuXuat(
                      nam: txtNam.text,
                      thang: selected == 'Tháng' ? thang : null,
                      quy: selected == 'Quý' ? quy : null,
                    );
                setState(() {
                  filters = {
                    PhieuXuatString.kyHieu: [],
                    PhieuXuatString.ngayCT: [],
                    PhieuXuatString.soHD: [],
                    KhachHangString.tenKH: [],
                    KhachHangString.mst: [],
                    PhieuXuatString.congTien: [],
                    PhieuXuatString.tienThue: [],
                    PhieuXuatString.dienGiai: [],
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
            if (event.cell.column.field == PhieuXuatString.soHD) {
              showBanHang(context, stt: event.row.cells['null']!.value);
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
              type: TrinaColumnTypeText(),
              width: 25,
              renderer: (re) => DataGridContainer(text: "${re.rowIdx+1}",),
              titleRenderer: (re) => DataGridTitle(title: ''),
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(
              title: 'Ký hiệu',
              width: 80,
              field: PhieuXuatString.kyHieu,
              type: TrinaColumnTypeText(),
              titleRenderer: (re)=>_buildTitle(re)
            ),
            DataGridColumn(
              title: 'Số HD',
              width: 80,
              field: PhieuXuatString.soHD,
              type: TrinaColumnTypeText(),
              renderer: (re) {
                return Text(re.cell.value, style: TextStyle(color: Colors.red));
              },
                titleRenderer: (re)=>_buildTitle(re)
            ),
            DataGridColumn(
              title: 'Ngày HD',
              width: 100,
              field: PhieuXuatString.ngayCT,
              type: TrinaColumnType.date(format: 'dd/MM/yyyy'),
                titleRenderer: (re)=>_buildTitle(re,isNgay: true)
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              width: 300,
              field: KhachHangString.tenKH,
              type: TrinaColumnTypeText(),
                titleRenderer: (re)=>_buildTitle(re)
            ),
            DataGridColumn(
              title: 'Mã số thuế',
              width: 120,
              field: KhachHangString.mst,
              type: TrinaColumnTypeText(),
                titleRenderer: (re)=>_buildTitle(re)
            ),
            DataGridColumn(
              title: 'Tiền chưa VAT',
              width: 120,
              field: PhieuXuatString.congTien,
              textAlign: TrinaColumnTextAlign.end,
                titleRenderer: (re)=>_buildTitle(re,isNummber: true),
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
              field: PhieuXuatString.tienThue,
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
              titleRenderer: (re)=>_buildTitle(re,isNummber: true),
              type: TrinaColumnType.number(),
            ),
            DataGridColumn(
              title: 'Ghi chú',
              width: 240,
              field: PhieuXuatString.dienGiai,
              type: TrinaColumnTypeText(),
              titleRenderer: (re)=>_buildTitle(re),
            ),
          ],
        ),
      ),
    );
  }
}
