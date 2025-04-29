import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';

class BangTaiKhoanView extends ConsumerStatefulWidget {
  const BangTaiKhoanView({super.key});

  @override
  ConsumerState createState() => _BangTaiKhoanViewState();
}

class _BangTaiKhoanViewState extends ConsumerState<BangTaiKhoanView> {
  late TrinaGridStateManager _stateManager;
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  late BangTaiKhoanNotifier _bangTaiKhoanNotifier;

  @override
  void initState() {
    // TODO: implement initState
    _bangTaiKhoanNotifier = ref.read(bangTaiKhoanProvider.notifier);
    super.initState();
  }

  Map<String, List<dynamic>> filters = {
    BangTaiKhoanString.maTK: [],
    BangTaiKhoanString.tenTK: [],
    BangTaiKhoanString.tinhChat: [],
    BangTaiKhoanString.ghiChu: [],
    BangTaiKhoanString.maXL: [],
  };

  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool maTk =
          filters[BangTaiKhoanString.maTK]!.isEmpty ||
          filters[BangTaiKhoanString.maTK]!.contains(row.cells[BangTaiKhoanString.maTK]!.value);
      bool tenTk =
          filters[BangTaiKhoanString.tenTK]!.isEmpty ||
          filters[BangTaiKhoanString.tenTK]!.contains(row.cells[BangTaiKhoanString.tenTK]!.value);
      bool tC =
          filters[BangTaiKhoanString.tinhChat]!.isEmpty ||
          filters[BangTaiKhoanString.tinhChat]!.contains(row.cells[BangTaiKhoanString.tinhChat]!.value);
      bool ghiChu =
          filters[BangTaiKhoanString.ghiChu]!.isEmpty ||
          filters[BangTaiKhoanString.ghiChu]!.contains(row.cells[BangTaiKhoanString.ghiChu]!.value);
      bool nhom =
          filters[BangTaiKhoanString.maXL]!.isEmpty ||
          filters[BangTaiKhoanString.maXL]!.contains(row.cells[BangTaiKhoanString.maXL]!.value.toString());
      return maTk && tenTk && tC && ghiChu && nhom;
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
      enabelFilter: true,
    );
  }

  void _onChange(TrinaGridOnChangedEvent e) async {
    final id = e.row.cells['null']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert

      int id = await _bangTaiKhoanNotifier.add(field: field, value: e.value).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['null']!.value = id; //set id when insert
        _stateManager.appendRows([
          TrinaRow(
            cells: {
              'null': TrinaCell(value: ''),
              BangTaiKhoanString.maTK: TrinaCell(value: ''),
              BangTaiKhoanString.tenTK: TrinaCell(value: ''),
              BangTaiKhoanString.tinhChat: TrinaCell(value: ''),
              BangTaiKhoanString.ghiChu: TrinaCell(value: ''),
              BangTaiKhoanString.maXL: TrinaCell(value: 0),
            },
          )
        ]);
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _bangTaiKhoanNotifier.update(value: e.value, id: id, field: field);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangTaiKhoanProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: e.id),
                  BangTaiKhoanString.maTK: TrinaCell(value: e.maTK),
                  BangTaiKhoanString.tenTK: TrinaCell(value: e.tenTK),
                  BangTaiKhoanString.tinhChat: TrinaCell(value: e.tinhChat),
                  BangTaiKhoanString.ghiChu: TrinaCell(value: e.ghiChu),
                  BangTaiKhoanString.maXL: TrinaCell(value: e.maXL ? 1 : 0),
                },
              ),
            )
            .toList(),
      );
      _stateManager.appendRows([
        TrinaRow(
          cells: {
            'null': TrinaCell(value: ''),
            BangTaiKhoanString.maTK: TrinaCell(value: ''),
            BangTaiKhoanString.tenTK: TrinaCell(value: ''),
            BangTaiKhoanString.tinhChat: TrinaCell(value: ''),
            BangTaiKhoanString.ghiChu: TrinaCell(value: ''),
            BangTaiKhoanString.maXL: TrinaCell(value: 0),
          },
        )
      ]);
      _stateManager.notifyListeners();
    });
    return Scaffold(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              color: Colors.blue.shade900,
              padding: EdgeInsets.symmetric(vertical: 2),
              alignment: Alignment.center,
              width: double.infinity,
              height: 25,
              child: Text('Quyết định 46/2000 QD-BTC', style: TextStyle(color: Colors.white)).medium(),
            ),
            Expanded(
              child: DataGrid(
                // createFooter: (re) {
                //   return Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                //     child: Row(
                //       spacing: 5,
                //       children: [
                //         iconFirst(
                //           onPressed: () {
                //             re.moveScrollByRow(TrinaMoveDirection.up, 0);
                //           },
                //         ),
                //         iconLast(
                //           onPressed: () {
                //             re.moveScrollByRow(TrinaMoveDirection.down, re.rows.length);
                //           },
                //         ),
                //       ],
                //     ),
                //   );
                // },
                onLoaded: (e) => _stateManager = e.stateManager,
                onChanged: (e) => _onChange(e),
                rows: [],
                rowColorCallback: (re) {
                  if (re.row.cells[BangTaiKhoanString.maXL]!.value == 1) {
                    return Colors.gray.shade300;
                  }
                  return Colors.white;
                },
                columns: [
                  DataGridColumn(
                    title: '',
                    field: 'null',
                    type: TrinaColumnType.text(),
                    width: 25,
                    cellPadding: EdgeInsets.zero,
                    titleRenderer: (re) => DataGridTitle(title: ''),
                    renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
                  ),
                  DataGridColumn(
                    title: 'Mã TK',
                    width: 100,
                    titleRenderer: (re) => _buildTitle(re),
                    field: BangTaiKhoanString.maTK,
                    type: TrinaColumnType.text(),
                    enableEditingMode: true,
                  ),
                  DataGridColumn(
                    title: 'Mô tả',
                    titleRenderer: (re) => _buildTitle(re),
                    width: 350,
                    field: BangTaiKhoanString.tenTK,
                    type: TrinaColumnType.text(),
                    enableEditingMode: true,
                  ),
                  DataGridColumn(
                    title: 'TC',
                    titleRenderer: (re) => _buildTitle(re),
                    textAlign: TrinaColumnTextAlign.center,
                    width: 70,
                    field: BangTaiKhoanString.tinhChat,
                    type: TrinaColumnType.text(),
                    enableEditingMode: true,
                  ),
                  DataGridColumn(
                    title: 'Ghi chú',
                    width: 300,
                    titleRenderer: (re) => _buildTitle(re),
                    field: BangTaiKhoanString.ghiChu,
                    type: TrinaColumnType.text(),
                    enableEditingMode: true,
                  ),
                  DataGridColumn(
                    title: 'Nhóm',
                    titleRenderer: (re) => _buildTitle(re, isNummber: true),
                    width: 100,
                    textAlign: TrinaColumnTextAlign.center,
                    field: BangTaiKhoanString.maXL,
                    type: TrinaColumnType.text(),
                    enableEditingMode: true,
                    renderer: (re) {
                      return Center(
                        child: Text(
                          re.cell.value == ''
                              ? ''
                              : re.cell.value == 1
                              ? "Me"
                              : 'Con',
                          style: TextStyle(color: re.cell.value == 1 ? Colors.red : Colors.blue.shade900),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
