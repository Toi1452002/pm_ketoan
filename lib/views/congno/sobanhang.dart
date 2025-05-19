import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';

class SoBanHangView extends ConsumerStatefulWidget {
  const SoBanHangView({super.key});

  @override
  ConsumerState createState() => _SoBanHangViewState();
}

class _SoBanHangViewState extends ConsumerState<SoBanHangView> {
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  KhachHangModel? _selectKhach;
  String strTuNgay = Helper.dateFormatDMY(DateTime.now().copyWith(day: 1));
  String strDenNgay = Helper.dateFormatDMY(DateTime.now());
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  late TrinaGridStateManager _stateManager;
  bool enabelFilter = false;

  final txtNoDauKy = TextEditingController();
  final txtNoCuoiKy = TextEditingController();

  Future<void> getTon() async{
    final sqlRepository = SqlRepository(tableName: '');
    if(_selectKhach!=null){
      final noDauKy = await sqlRepository.getCustomData(
        '''SELECT ${DauKyKhachHangString.soDuNo} No FROM ${TableName.dauKyKhachHang}  WHERE ${DauKyKhachHangString.maKhach} = '${_selectKhach?.maKhach}' ''',
      );
      if(noDauKy.isEmpty) {
        txtNoDauKy.text = '';
        txtNoCuoiKy.text = '';
       return;
      }
      double numDauKy = double.tryParse(noDauKy.first['No'].toString()) ?? 0;
      if(numDauKy!=0){
        final ton = await sqlRepository.getCustomData(
          "SELECT SUM(No)-SUM(Co) as No FROM ${ViewName.vbcSoBanHang} WHERE Ngay < '${Helper.dateFormatYMD(tuNgay)}' AND ${DauKyKhachHangString.maKhach} = '${_selectKhach?.maKhach}'",
        );
        final tonHienTai = await sqlRepository.getCustomData(
          "SELECT SUM(No)-SUM(Co) as No FROM ${ViewName.vbcSoBanHang} WHERE Ngay BETWEEN '${Helper.dateFormatYMD(tuNgay)}' AND '${Helper.dateFormatYMD(denNgay)}'AND ${DauKyKhachHangString.maKhach} = '${_selectKhach?.maKhach}'",
        );
        double numCuoiKy = double.tryParse(ton.first['No'].toString()) ?? 0;
        double numHienTai = double.tryParse(tonHienTai.first['No'].toString()) ?? 0;
        final result = numDauKy + numCuoiKy;
        txtNoDauKy.text = Helper.numFormat(result)!;
        txtNoCuoiKy.text = Helper.numFormat(result + numHienTai)!;
      }

    }

  }

  Map<String, List<dynamic>> filters = {
    SoMBHangString.ngay: [],
    SoMBHangString.phieu: [],
    SoMBHangString.tenHH: [],
    SoMBHangString.dvt: [],
    SoMBHangString.soLg: [],
    SoMBHangString.donGia: [],
    SoMBHangString.no: [],
    SoMBHangString.co: [],
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

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[SoMBHangString.ngay]!.isEmpty ||
              filters[SoMBHangString.ngay]!.contains(row.cells[SoMBHangString.ngay]!.value);
      bool phieu =
          filters[SoMBHangString.phieu]!.isEmpty ||
              filters[SoMBHangString.phieu]!.contains(row.cells[SoMBHangString.phieu]!.value);
      bool tenHH =
          filters[SoMBHangString.tenHH]!.isEmpty ||
              filters[SoMBHangString.tenHH]!.contains(row.cells[SoMBHangString.tenHH]!.value);
      bool dvt =
          filters[SoMBHangString.dvt]!.isEmpty ||
              filters[SoMBHangString.dvt]!.contains(row.cells[SoMBHangString.dvt]!.value);
      bool soLg =
          filters[SoMBHangString.soLg]!.isEmpty ||
              filters[SoMBHangString.soLg]!.contains(row.cells[SoMBHangString.soLg]!.value.toString());
      bool donGia =
          filters[SoMBHangString.donGia]!.isEmpty ||
              filters[SoMBHangString.donGia]!.contains(row.cells[SoMBHangString.donGia]!.value.toString());
      bool no =
          filters[SoMBHangString.no]!.isEmpty ||
              filters[SoMBHangString.no]!.contains(row.cells[SoMBHangString.no]!.value.toString());
      bool co =
          filters[SoMBHangString.co]!.isEmpty ||
              filters[SoMBHangString.co]!.contains(row.cells[SoMBHangString.co]!.value.toString());
      return ngay && phieu && dvt && soLg && tenHH && donGia && no && co;
    });
    setState(() {});
  }

  clearFilter() {
    filters = {
      SoMBHangString.ngay: [],
      SoMBHangString.phieu: [],
      SoMBHangString.tenHH: [],
      SoMBHangString.dvt: [],
      SoMBHangString.soLg: [],
      SoMBHangString.donGia: [],
      SoMBHangString.no: [],
      SoMBHangString.co: [],
    };
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final wKhach = ref.watch(lstKhachProvider);
    ref.listen(congNoProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              SoMBHangString.ngay: TrinaCell(value: Helper.stringFormatDMY(e.ngay)),
              SoMBHangString.phieu: TrinaCell(value: e.phieu),
              SoMBHangString.tenHH: TrinaCell(value: e.tenHH),
              SoMBHangString.dvt: TrinaCell(value: e.dvt),
              SoMBHangString.soLg: TrinaCell(value: e.soLg),
              SoMBHangString.donGia: TrinaCell(value: e.donGia),
              SoMBHangString.no: TrinaCell(value: e.no),
              SoMBHangString.co: TrinaCell(value: e.co),
            },
          );
        }).toList(),
      );
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            IconPrinter(onPressed: () {}),
            IconExcel(onPressed: () {}),
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
                    .read(congNoProvider.notifier)
                    .getSoBanHang(tN: tuNgay, dN: denNgay, maKhach: _selectKhach == null ? '' : _selectKhach!.maKhach);
                getTon();
              },
            ),
          ],
        ),
        Row(
          children: [
            Gap(175),
            SizedBox(
              width: 150,
              child: LabelCombobox(
                columnWidth: [100, 290],
                menuWidth: 400,
                selected: _selectKhach?.maKhach,
                items:
                wKhach.hasValue
                    ? wKhach.value!
                    .map(
                      (e) => ComboboxItem(value: e.maKhach, title: [e.maKhach, e.tenKH], valueOther: e.tenKH),
                )
                    .toList()
                    : [],
                isChangeEmpty: false,
                onChanged: (val, o) {
                  ref
                      .read(congNoProvider.notifier)
                      .getSoBanHang(tN: tuNgay, dN: denNgay, maKhach: val??'');

                  setState(() {
                    _selectKhach = KhachHangModel(maKhach: val!, tenKH: o);
                  });

                  getTon();
                },
                label: 'Mã KH',
              ),
            ),
            Gap(5),
            SizedBox(
              width: 300,
              child: LabelTextfield(readOnly: true, controller: TextEditingController(text: _selectKhach?.tenKH)),
            ),
            Spacer(),
            SizedBox(
              width: 200,
              child: LabelTextfield(
                readOnly: true,
                label: 'Nợ đầu kỳ',
                textAlign: TextAlign.end,
                controller: txtNoDauKy,
                // controller: txtTonDauKy,
                style: TextStyle(fontWeight: FontWeight.bold),
                color: Colors.blue.shade100,
              ),
            ),
            Gap(20),
          ],
        ),
      ],
      footers: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Spacer(),
              SizedBox(
                width: 200,
                child: LabelTextfield(
                  readOnly: true,
                  label: 'Nợ cuối kỳ',
                  textAlign: TextAlign.end,
                  controller: txtNoCuoiKy,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  color: Colors.blue.shade100,
                ),
              ),
              Gap(20),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          rows: [],
          onRowDoubleTap: (re) {
            if (re.cell.column.field == SoTienString.phieu) {
              if (re.cell.value[0] == 'C') {
                showPhieuChi(context, stt: re.row.cells['null']!.value);
              } else if (re.cell.value[0] == 'T') {
                showPhieuThu(context, stt: re.row.cells['null']!.value);
              } else if (re.cell.value[0] == 'N') {
                showMuaHang(context, stt: re.row.cells['null']!.value);
              } else if (re.cell.value[0] == 'X') {
                showBanHang(context, stt: re.row.cells['null']!.value);
              }
            }
          },
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnType.text(),
              width: 25,
              cellPadding: EdgeInsets.zero,
              renderer: (re) => DataGridContainer(text: '${re.rowIdx + 1}'),
              titleRenderer: (re) => DataGridTitle(title: ''),
            ),
            DataGridColumn(
              title: 'Ngày',
              field: SoMBHangString.ngay,
              type: TrinaColumnType.text(),
              width: 90,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re) => _buildTitle(re, isNgay: true),
            ),
            DataGridColumn(
              title: 'Phiếu',
              field: SoMBHangString.phieu,
              type: TrinaColumnType.text(),
              width: 90,
              textAlign: TrinaColumnTextAlign.center,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Tên hàng hóa',
              field: SoMBHangString.tenHH,
              type: TrinaColumnType.text(),
              width: 250,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'ĐVT',
              field: SoMBHangString.dvt,
              type: TrinaColumnType.text(),
              width: 80,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Số lg',
              field: SoMBHangString.soLg,
              type: TrinaColumnType.number(),
              width: 80,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
            ),
            DataGridColumn(
              title: 'Đơn giá',
              field: SoMBHangString.donGia,
              type: TrinaColumnType.number(),
              width: 120,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
            ),
            DataGridColumn(
              title: 'Thành tiền',
              field: SoMBHangString.no,
              type: TrinaColumnType.number(),
              width: 120,
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) => DataGridFooter(re),
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
            ),
            DataGridColumn(
              title: 'Thanh toán',
              field: SoMBHangString.co,
              type: TrinaColumnType.number(),
              width: 120,
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) => DataGridFooter(re),
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
            ),
          ],
        ),
      ),
    );
  }
}
