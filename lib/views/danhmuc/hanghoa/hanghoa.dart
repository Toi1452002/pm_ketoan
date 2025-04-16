import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/danhmuc/hanghoa/component/pdf_hanghoa.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import 'component/thongtinhanghoa.dart';

export 'component/thongtinhanghoa.dart';

class HangHoaView extends ConsumerStatefulWidget {
  const HangHoaView({super.key});

  @override
  HangHoaViewState createState() => HangHoaViewState();
}

class HangHoaViewState extends ConsumerState<HangHoaView> {
  late TrinaGridStateManager _stateManager;
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;
  List<HangHoaModel> lstHangHoa = [];


  Map<String, List<dynamic>> filters = {
    HangHoaString.maHH: [],
    HangHoaString.tenHH: [],
    DVTString.dvt: [],
    HangHoaString.giaMua: [],
    HangHoaString.giaBan: [],
    LoaiHangString.loaiHang: [],
    NhomHangString.nhomHang: [],
    HangHoaString.maNC: [],
  };

  void _showThongTinHangHoa(BuildContext context, {HangHoaModel? hangHoa}) {
    showCustomDialog(
      context,
      title: 'THÔNG TIN HÀNG HÓA',
      width: 600,
      height: 390,
      child: ThongTinHangHoaView(hangHoa: hangHoa),
      onClose: () {},
    );
  }

  void _onDelete(TrinaColumnRendererContext re, WidgetRef ref) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'HÀNG HÓA');
      if (btn == AlertButton.okButton) {
        int result = await ref.read(hangHoaProvider.notifier).delete(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }

  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool maHH =
          filters[HangHoaString.maHH]!.isEmpty ||
          filters[HangHoaString.maHH]!.contains(row.cells[HangHoaString.maHH]!.value);
      bool tenHH =
          filters[HangHoaString.tenHH]!.isEmpty ||
          filters[HangHoaString.tenHH]!.contains(row.cells[HangHoaString.tenHH]!.value);
      bool dvt = filters[DVTString.dvt]!.isEmpty || filters[DVTString.dvt]!.contains(row.cells[DVTString.dvt]!.value);
      bool giaMua =
          filters[HangHoaString.giaMua]!.isEmpty ||
          filters[HangHoaString.giaMua]!.contains(row.cells[HangHoaString.giaMua]!.value);
      bool giaBan =
          filters[HangHoaString.giaBan]!.isEmpty ||
          filters[HangHoaString.giaBan]!.contains(row.cells[HangHoaString.giaBan]!.value);
      bool loaiHang =
          filters[LoaiHangString.loaiHang]!.isEmpty ||
          filters[LoaiHangString.loaiHang]!.contains(row.cells[LoaiHangString.loaiHang]!.value);
      bool nhomHang =
          filters[NhomHangString.nhomHang]!.isEmpty ||
          filters[NhomHangString.nhomHang]!.contains(row.cells[NhomHangString.nhomHang]!.value);
      bool maNC =
          filters[HangHoaString.maNC]!.isEmpty ||
          filters[HangHoaString.maNC]!.contains(row.cells[HangHoaString.maNC]!.value);

      return maHH && tenHH && dvt && giaMua && giaBan && loaiHang && nhomHang && maNC;
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
      HangHoaString.maHH: [],
      HangHoaString.tenHH: [],
      DVTString.dvt: [],
      HangHoaString.giaMua: [],
      HangHoaString.giaBan: [],
      LoaiHangString.loaiHang: [],
      NhomHangString.nhomHang: [],
      HangHoaString.maNC: [],
    };
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(hangHoaProvider, (context, state) {
      lstHangHoa = state;
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        List.generate(state.length, (i) {
          final x = state[i];
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: ''),
              'delete': TrinaCell(value: x.id),
              HangHoaString.maHH: TrinaCell(
                value: x.maHH,
                renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red)).small(),
              ),
              HangHoaString.tenHH: TrinaCell(value: x.tenHH),
              DVTString.dvt: TrinaCell(value: x.donViTinh),
              HangHoaString.giaMua: TrinaCell(value: x.giaMua),
              HangHoaString.giaBan: TrinaCell(value: x.giaBan),
              LoaiHangString.loaiHang: TrinaCell(value: x.loaiHang),
              NhomHangString.nhomHang: TrinaCell(value: x.nhomHang),
              HangHoaString.maNC: TrinaCell(value: x.maNC),
              HangHoaString.ghiChu: TrinaCell(value: x.ghiChu),
            },
          );
        }),
      );
      _stateManager.notifyListeners();
    });

    final qlXBC = ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlXBC).giaTri == 1;

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconAdd(onPressed: () => _showThongTinHangHoa(context)),
            IconPrinter(
              onPressed: () {
                if (qlXBC) {
                  showViewPrinter(context, PdfHangHoaView(stateManager: _stateManager));
                } else {
                  PdfWidget().onPrint(onLayout: pdfHangHoa(dateNow: Helper.dateNowDMY(), stateManager: _stateManager));
                }
              },
            ),
            IconExcel(
              onPressed: () {
                excelHangHoa(_stateManager);
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
          ],
          trailing: [
            SizedBox(
              width: 300,
              child: Combobox(
                selected: ref.watch(hangHoaTheoiDoiProvider).value,
                isChangeEmpty: false,
                items: [
                  ComboboxItem(
                    value: 'Danh sách hàng hóa đang theo dõi',
                    title: ['Danh sách hàng hóa đang theo dõi'],
                    valueOther: 1,
                  ),
                  ComboboxItem(
                    value: 'Danh sách hàng hóa ngưng theo dõi',
                    title: ['Danh sách hàng hóa ngưng theo dõi'],
                    valueOther: 0,
                  ),
                  ComboboxItem(value: 'Tất cả', title: ['Tất cả'], valueOther: 2),
                ],
                onChanged: (val, o) {
                  ref.read(hangHoaTheoiDoiProvider.notifier).state = ComboboxItem(
                    value: val!,
                    title: [],
                    valueOther: o,
                  );
                  ref.read(hangHoaProvider.notifier).getHangHoa(theoDoi: o);
                  setState(() {
                    clearFilter();
                  });
                },
              ),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) {
            if (event.cell.column.field == HangHoaString.maHH) {
              final hh = lstHangHoa.firstWhere((e) => e.maHH == event.cell.value);
              _showThongTinHangHoa(context, hangHoa: hh);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnTypeText(),
              width: 25,
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
              titleRenderer: (re) => DataGridTitle(title: ''),
            ),
            DataGridColumn(
              title: '',
              field: 'delete',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) => DataGridTitle(title: ''),
              width: 25,
              renderer:
                  (re) => DataGridDelete(
                    onTap: () {
                      _onDelete(re, ref);
                    },
                  ),
            ),
            DataGridColumn(
              title: 'Mã',
              titleRenderer: (re) => _buildTitle(re),
              field: HangHoaString.maHH,
              type: TrinaColumnTypeText(),
              width: 145,
            ),
            DataGridColumn(
              title: 'Tên vật tư-hàng hóa',
              titleRenderer: (re) => _buildTitle(re),
              field: HangHoaString.tenHH,
              type: TrinaColumnTypeText(),
              width: 300,
            ),
            DataGridColumn(
              title: 'Đơn vị tính',
              titleRenderer: (re) => _buildTitle(re),
              field: DVTString.dvt,
              type: TrinaColumnTypeText(),
              width: 100,
            ),
            DataGridColumn(
              title: 'Giá mua',
              field: HangHoaString.giaMua,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              type: TrinaColumnType.number(),
              textAlign: TrinaColumnTextAlign.end,
              enableSorting: true,
              width: 150,
            ),
            DataGridColumn(
              title: 'Giá bán',
              field: HangHoaString.giaBan,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              type: TrinaColumnType.number(),
              textAlign: TrinaColumnTextAlign.end,
              enableSorting: true,
              width: 150,
            ),
            DataGridColumn(
              title: 'Loại hàng',
              field: LoaiHangString.loaiHang,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) => _buildTitle(re),
              width: 100,
            ),
            DataGridColumn(
              title: 'Nhóm hàng',
              field: NhomHangString.nhomHang,
              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnTypeText(),
              width: 105,
            ),
            DataGridColumn(
              title: 'Nhà cung',
              titleRenderer: (re) => _buildTitle(re),
              field: HangHoaString.maNC,
              type: TrinaColumnTypeText(),
              width: 95,
            ),
            DataGridColumn(title: 'Ghi chu', field: HangHoaString.ghiChu, type: TrinaColumnTypeText(), hide: true),
          ],
        ),
      ),
    );
  }
}
