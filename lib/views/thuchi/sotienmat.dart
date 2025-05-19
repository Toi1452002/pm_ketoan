import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/thuchi/component/pdf_sotienmat.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';

class SoTienMatView extends ConsumerStatefulWidget {
  const SoTienMatView({super.key});

  @override
  ConsumerState createState() => _SoTienMatViewState();
}

class _SoTienMatViewState extends ConsumerState<SoTienMatView> {
  late TrinaGridStateManager _stateManager;
  final txtTonDauKy = TextEditingController();
  final txtTonCuoiKy = TextEditingController();
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String strTuNgay = Helper.dateFormatDMY(DateTime.now().copyWith(day: 1));
  String strDenNgay = Helper.dateFormatDMY(DateTime.now());
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;
  Map<String, List<dynamic>> filters = {
    SoTienString.ngay: [],
    SoTienString.phieu: [],
    SoTienString.noiDung: [],
    SoTienString.kieu: [],
    SoTienString.pttt: [],
    SoTienString.soCT: [],
    SoTienString.tkDU: [],
    SoTienString.thu: [],
    SoTienString.chi: [],
  };

  @override
  void initState() {
    // TODO: implement initState
    getTon();
    super.initState();
  }

  Future<void> getTon() async {
    final sqlRepository = SqlRepository(tableName: '');
    final dKyTaiKhoan = await sqlRepository.getCustomData(
      '''SELECT SUM(a.DKNo) DKNo FROM TDM_DKyTaiKhoan a WHERE a.MaTK LIKE '111%' AND a.DKy = 1''',
    );
    final ton = await sqlRepository.getCustomData(
      "SELECT SUM(Thu)-SUM(Chi) as Ton FROM VTC_SoTienMat WHERE Ngay < '${Helper.dateFormatYMD(tuNgay)}'",
    );
    final tonHienTai = await sqlRepository.getCustomData(
      "SELECT SUM(Thu)-SUM(Chi) as Ton FROM VTC_SoTienMat WHERE Ngay BETWEEN '${Helper.dateFormatYMD(tuNgay)}' AND '${Helper.dateFormatYMD(denNgay)}'",
    );
    double numDauKy = double.tryParse(dKyTaiKhoan.first['DKNo'].toString()) ?? 0;
    double numTonCuoiKy = double.tryParse(ton.first['Ton'].toString()) ?? 0;
    double numTonHienTai = double.tryParse(tonHienTai.first['Ton'].toString()) ?? 0;

    final result = numDauKy + numTonCuoiKy;
    txtTonDauKy.text = Helper.numFormat(result)!;
    txtTonCuoiKy.text = Helper.numFormat(result + numTonHienTai)!;
  }

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[SoTienString.ngay]!.isEmpty ||
          filters[SoTienString.ngay]!.contains(row.cells[SoTienString.ngay]!.value);
      bool phieu =
          filters[SoTienString.phieu]!.isEmpty ||
          filters[SoTienString.phieu]!.contains(row.cells[SoTienString.phieu]!.value);
      bool noiDung =
          filters[SoTienString.noiDung]!.isEmpty ||
          filters[SoTienString.noiDung]!.contains(row.cells[SoTienString.noiDung]!.value);
      bool kieu =
          filters[SoTienString.kieu]!.isEmpty ||
          filters[SoTienString.kieu]!.contains(row.cells[SoTienString.kieu]!.value);
      bool pttt =
          filters[SoTienString.pttt]!.isEmpty ||
          filters[SoTienString.pttt]!.contains(row.cells[SoTienString.pttt]!.value);
      bool soCT =
          filters[SoTienString.soCT]!.isEmpty ||
          filters[SoTienString.soCT]!.contains(row.cells[SoTienString.soCT]!.value);
      bool tkDU =
          filters[SoTienString.tkDU]!.isEmpty ||
          filters[SoTienString.tkDU]!.contains(row.cells[SoTienString.tkDU]!.value);
      bool thu =
          filters[SoTienString.thu]!.isEmpty ||
          filters[SoTienString.thu]!.contains(row.cells[SoTienString.thu]!.value.toString());
      bool chi =
          filters[SoTienString.chi]!.isEmpty ||
          filters[SoTienString.chi]!.contains(row.cells[SoTienString.chi]!.value.toString());
      return ngay && phieu && kieu && pttt && noiDung && soCT && tkDU && thu && chi;
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

  clearFilter() {
    filters = {
      SoTienString.ngay: [],
      SoTienString.phieu: [],
      SoTienString.noiDung: [],
      SoTienString.kieu: [],
      SoTienString.pttt: [],
      SoTienString.soCT: [],
      SoTienString.tkDU: [],
      SoTienString.thu: [],
      SoTienString.chi: [],
    };
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(soTienMatProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: e.stt),
                  SoTienString.ngay: TrinaCell(value: Helper.stringFormatDMY(e.ngay)),
                  SoTienString.phieu: TrinaCell(value: e.phieu),
                  SoTienString.noiDung: TrinaCell(value: e.noiDung),
                  SoTienString.kieu: TrinaCell(value: e.kieu),
                  SoTienString.pttt: TrinaCell(value: e.pttt),
                  SoTienString.soCT: TrinaCell(value: e.soCT),
                  SoTienString.tkDU: TrinaCell(value: e.tkdu),
                  SoTienString.thu: TrinaCell(value: e.thu),
                  SoTienString.chi: TrinaCell(value: e.chi),
                },
              ),
            )
            .toList(),
      );
    });
    final qlXBC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlXBC).giaTri ==
        1; //Nếu bằng 1 thi xem bc truoc khi in
    return Scaffold(
      footers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          trailing: [
            SizedBox(
              width: 250,
              child: LabelTextfield(
                label: 'Tồn cuối kỳ',
                textAlign: TextAlign.end,
                controller: txtTonCuoiKy,
                style: TextStyle(fontWeight: FontWeight.bold),
                color: Colors.blue.shade100,
                readOnly: true,
              ),
            ),
            Gap(15),
          ],
        ),
      ],
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          leading: [
            IconPrinter(
              onPressed: () async {
                final sqlRepository = SqlRepository(tableName: TableName.ttdn);
                final diaChiCTY =
                    await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'DC'") ?? '';
                final tenCTY =
                    await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'TCT'") ??
                    '';
                if (qlXBC) {
                  showViewPrinter(
                    context,
                    PdfSoTienMatView(
                      tuNgay: strTuNgay,
                      denNgay: strDenNgay,
                      stateManager: _stateManager,
                      tenCTY: tenCTY,
                      diaChi: diaChiCTY,
                      sdDK: txtTonDauKy.text,
                      sdCK: txtTonCuoiKy.text,
                    ),
                    isPortrait: false,
                  );
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfSoTienMat(
                      tN: strTuNgay,
                      dN: strDenNgay,
                      dateNow: Helper.dateNowDMY(),
                      tenCTy: tenCTY,
                      diaChi: diaChiCTY,
                      sdDK: txtTonDauKy.text,
                      sdCK: txtTonCuoiKy.text,
                      stateManager: _stateManager,
                    ),
                  );
                }
              },
            ),
            IconExcel(onPressed: ()=>excelSoTienMat(_stateManager)),
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
                    .read(soTienMatProvider.notifier)
                    .getSoTienMat(tN: Helper.dateFormatYMD(tuNgay), dN: Helper.dateFormatYMD(denNgay));
                getTon();
                setState(() {
                  strTuNgay = Helper.dateFormatDMY(tuNgay);
                  strDenNgay = Helper.dateFormatDMY(denNgay);
                  clearFilter();
                });
              },
            ),
          ],
          trailing: [
            SizedBox(
              width: 250,
              child: LabelTextfield(
                readOnly: true,
                label: 'Tồn đầu kỳ',
                textAlign: TextAlign.end,
                controller: txtTonDauKy,
                style: TextStyle(fontWeight: FontWeight.bold),
                color: Colors.blue.shade100,
              ),
            ),
            Gap(15),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (re) {
            if (re.cell.column.field == SoTienString.phieu) {
              if (re.cell.value[0] == 'C') {
                showPhieuChi(context, stt: re.row.cells['null']!.value);
              } else if(re.cell.value[0] == 'T'){
                showPhieuThu(context, stt: re.row.cells['null']!.value);
              }else if(re.cell.value[0] == 'N'){
                showMuaHang(context,stt: re.row.cells['null']!.value);
              }else if(re.cell.value[0] == 'X'){
                showBanHang(context,stt: re.row.cells['null']!.value);
              }
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
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(
              title: 'Ngày',
              field: SoTienString.ngay,
              titleRenderer: (re) => _buildTitle(re, isNgay: true),
              type: TrinaColumnType.text(),
              width: 90,
            ),
            DataGridColumn(
              title: 'Phiếu',
              field: SoTienString.phieu,
              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
              width: 90,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red, fontSize: 13.5)),
            ),
            DataGridColumn(
              title: 'Lý do',
              field: SoTienString.noiDung,
              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
              width: 250,
            ),
            DataGridColumn(
              title: 'Kiểu',
              field: SoTienString.kieu,
              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
              width: 100,
            ),
            DataGridColumn(
              title: 'PTTT',
              field: SoTienString.pttt,
              titleRenderer: (re) => _buildTitle(re),
              textAlign: TrinaColumnTextAlign.center,
              type: TrinaColumnType.text(),
              width: 80,
            ),
            DataGridColumn(
              title: 'Số CT',
              field: SoTienString.soCT,
              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
              width: 90,
            ),
            DataGridColumn(
              title: 'TKDƯ',
              field: SoTienString.tkDU,
              titleRenderer: (re) => _buildTitle(re),
              textAlign: TrinaColumnTextAlign.center,
              type: TrinaColumnType.text(),
              width: 80,
            ),
            DataGridColumn(
              title: 'Thu',
              field: SoTienString.thu,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              type: TrinaColumnType.number(),
              textAlign: TrinaColumnTextAlign.end,
              width: 120,
              footerRenderer: (re) => DataGridFooter(re),
            ),
            DataGridColumn(
              title: 'Chi',
              field: SoTienString.chi,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              type: TrinaColumnType.number(),
              textAlign: TrinaColumnTextAlign.end,
              width: 120,
              footerRenderer: (re) => DataGridFooter(re),
            ),
          ],
        ),
      ),
    );
  }
}
