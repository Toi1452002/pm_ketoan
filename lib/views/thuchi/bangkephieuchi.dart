import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../application/application.dart';
import '../../core/core.dart';
import '../../data/data.dart';
import '../../widgets/widgets.dart';
import 'component/pdf_bangkephieuchi.dart';

class BangKePhieuChiView extends ConsumerStatefulWidget {
  const BangKePhieuChiView({super.key});

  @override
  BangKePhieuChiViewState createState() => BangKePhieuChiViewState();
}

class BangKePhieuChiViewState extends ConsumerState<BangKePhieuChiView> {
  late TrinaGridStateManager _stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String strTuNgay = Helper.dateFormatDMY(DateTime.now().copyWith(day: 1));
  String strDenNgay = Helper.dateFormatDMY(DateTime.now());
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;

  Map<String, List<dynamic>> filters = {
    PhieuChiString.ngay: [],
    PhieuChiString.phieu: [],
    PhieuChiString.maTC: [],
    PhieuChiString.maKhach: [],
    PhieuChiString.tenKhach: [],
    PhieuChiString.pttt: [],
    PhieuChiString.noiDung: [],
    PhieuChiString.soTien: [],
    PhieuChiString.tkNo: [],
    PhieuChiString.tkCo: [],
  };

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
      PhieuChiString.ngay: [],
      PhieuChiString.phieu: [],
      PhieuChiString.maTC: [],
      PhieuChiString.maKhach: [],
      PhieuChiString.tenKhach: [],
      PhieuChiString.pttt: [],
      PhieuChiString.noiDung: [],
      PhieuChiString.soTien: [],
      PhieuChiString.tkNo: [],
      PhieuChiString.tkCo: [],
    };
    _applyFilters();
  }

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[PhieuChiString.ngay]!.isEmpty ||
          filters[PhieuChiString.ngay]!.contains(row.cells[PhieuChiString.ngay]!.value);
      bool phieu =
          filters[PhieuChiString.phieu]!.isEmpty ||
          filters[PhieuChiString.phieu]!.contains(row.cells[PhieuChiString.phieu]!.value);
      bool maTC =
          filters[PhieuChiString.maTC]!.isEmpty ||
          filters[PhieuChiString.maTC]!.contains(row.cells[PhieuChiString.maTC]!.value);
      bool maKH =
          filters[PhieuChiString.maKhach]!.isEmpty ||
          filters[PhieuChiString.maKhach]!.contains(row.cells[PhieuChiString.maKhach]!.value);
      bool tenKH =
          filters[PhieuChiString.tenKhach]!.isEmpty ||
          filters[PhieuChiString.tenKhach]!.contains(row.cells[PhieuChiString.tenKhach]!.value);
      bool pttt =
          filters[PhieuChiString.pttt]!.isEmpty ||
          filters[PhieuChiString.pttt]!.contains(row.cells[PhieuChiString.pttt]!.value);
      bool noiDung =
          filters[PhieuChiString.noiDung]!.isEmpty ||
          filters[PhieuChiString.noiDung]!.contains(row.cells[PhieuChiString.noiDung]!.value);
      bool soTien =
          filters[PhieuChiString.soTien]!.isEmpty ||
          filters[PhieuChiString.soTien]!.contains(row.cells[PhieuChiString.soTien]!.value);
      bool tkNo =
          filters[PhieuChiString.tkNo]!.isEmpty ||
          filters[PhieuChiString.tkNo]!.contains(row.cells[PhieuChiString.tkNo]!.value);
      bool tkCo =
          filters[PhieuChiString.tkCo]!.isEmpty ||
          filters[PhieuChiString.tkCo]!.contains(row.cells[PhieuChiString.tkCo]!.value);

      return ngay && phieu && maTC && maKH && tenKH && pttt && noiDung && soTien && tkNo && tkCo;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangKePhieuChiProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        _stateManager.appendRows(
          List.generate(state.length, (index) {
            final x = state[index];
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: x.stt),
                PhieuChiString.ngay: TrinaCell(value: Helper.stringFormatDMY(x.ngay)),
                PhieuChiString.phieu: TrinaCell(value: x.phieu),
                PhieuChiString.maTC: TrinaCell(value: x.maTC),
                PhieuChiString.maKhach: TrinaCell(value: x.maKhach),
                PhieuChiString.tenKhach: TrinaCell(value: x.tenKhach),
                PhieuChiString.pttt: TrinaCell(value: x.pttt),
                PhieuChiString.noiDung: TrinaCell(value: x.noiDung),
                PhieuChiString.soTien: TrinaCell(value: x.soTien),
                PhieuChiString.tkNo: TrinaCell(value: x.tkNo),
                PhieuChiString.tkCo: TrinaCell(value: x.tkCo),
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
            IconPrinter(onPressed: () {
              final qlXBC =
                  ref.read(tuyChonProvider).firstWhere((e) => e.nhom == 'qlXBC').giaTri ==
                      1; //Nếu bằng 1 thi xem bc truoc khi in

              if (qlXBC) {
                showViewPrinter(
                  context,
                  PdfBangKePhieuChiView(tuNgay: strTuNgay, denNgay: strDenNgay, stateManager: _stateManager),
                );
              } else {
                PdfWidget().onPrint(
                  onLayout: pdfBangKePhieuChi(
                    tN: strTuNgay,
                    dN: strDenNgay,
                    dateNow: Helper.dateNowDMY(),
                    stateManager: _stateManager,
                  ),
                );
              }
            }),
            IconExcel(onPressed: () {
              excelBangKePhieuChi(_stateManager);
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
            Gap(40),
            SizedBox(
              width: 150,
              child: DateTextbox(
                onChanged: (val) {
                  tuNgay = val!;
                  setState(() {});
                },
                initialDate: tuNgay,
                label: 'Từ ngày',
                showClear: false,
              ),
            ),
            Gap(10),
            SizedBox(
              width: 160,
              child: DateTextbox(
                onChanged: (val) {
                  denNgay = val!;
                  setState(() {});
                },
                initialDate: denNgay,
                label: 'Đến ngày',
                showClear: false,
              ),
            ),
            PrimaryButton(
              size: ButtonSize(.8),
              child: Text('Thực hiện'),
              onPressed: () {
                ref
                    .read(bangKePhieuChiProvider.notifier)
                    .getBangKePhieuChi(tN: Helper.dateFormatYMD(tuNgay), dN: Helper.dateFormatYMD(denNgay));

                setState(() {
                  strTuNgay = Helper.dateFormatDMY(tuNgay);
                  strDenNgay = Helper.dateFormatDMY(denNgay);
                  filters = {
                    PhieuChiString.ngay: [],
                    PhieuChiString.phieu: [],
                    PhieuChiString.maTC: [],
                    PhieuChiString.maKhach: [],
                    PhieuChiString.tenKhach: [],
                    PhieuChiString.pttt: [],
                    PhieuChiString.noiDung: [],
                    PhieuChiString.soTien: [],
                    PhieuChiString.tkNo: [],
                    PhieuChiString.tkCo: [],
                  };
                });
              },
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) async {
            if (event.cell.column.field == PhieuChiString.phieu) {
              showPhieuChi(context, stt: event.row.cells['null']!.value);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              width: 25,
              titleRenderer: (re) => DataGridTitle(title: ''),
              cellPadding: EdgeInsets.zero,
              renderer: (re) => DataGridContainer(text: "${re.rowIdx+1}",),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(
              title: 'Ngày',

              titleRenderer: (re)=>_buildTitle(re,isNgay: true),
              field: PhieuChiString.ngay,
              type: TrinaColumnType.text(),
              width: 80,
            ),
            DataGridColumn(
              title: 'Phiếu',
              field: PhieuChiString.phieu,
              titleRenderer: (re)=>_buildTitle(re),

              type: TrinaColumnType.text(),
              width: 70,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red, fontSize: 13.5)),
            ),
            DataGridColumn(
              title: 'Kiểu thu',
              field: PhieuChiString.maTC,
              type: TrinaColumnType.text(),
              titleRenderer: (re)=>_buildTitle(re),
              width: 90,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'Mã KH',
              titleRenderer: (re)=>_buildTitle(re),
              field: PhieuChiString.maKhach,
              type: TrinaColumnType.text(),
              width: 80,
            ),
            DataGridColumn(
              title: 'Tên khách',
              field: PhieuChiString.tenKhach,
              type: TrinaColumnType.text(),
              width: 300,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'PTTT',
              field: PhieuChiString.pttt,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Lý do thu',
              field: PhieuChiString.noiDung,
              type: TrinaColumnType.text(),
              width: 280,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Số tiền',
              field: PhieuChiString.soTien,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re)=>_buildTitle(re,isNummber: true),
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  type: TrinaAggregateColumnType.sum,
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.centerRight,
                );
              },
            ),
            DataGridColumn(
              title: 'TK nợ',
              field: PhieuChiString.tkNo,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'TK có',
              field: PhieuChiString.tkCo,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re)=>_buildTitle(re),
            ),
          ],
        ),
      ),
    );
  }
}
