import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../widgets/widgets.dart';

class DanhSachBTK extends ConsumerStatefulWidget {
  final String? maTK;
  final bool tkNo;
  final bool tkCo;
  final void Function(String? val)? onChanged;

  const DanhSachBTK({super.key, this.maTK, this.tkNo = false, this.tkCo = false, this.onChanged});

  @override
  ConsumerState createState() => _DanhSachBTKState();
}

class _DanhSachBTKState extends ConsumerState<DanhSachBTK> {
  List<BangTaiKhoanModel> lstTaiKhoan = [];
  late TrinaGridStateManager _stateManager;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.tkCo) {
      getTkCo();
    }
    if (widget.tkNo) {
      getTKNo();
    }

    super.initState();
  }

  void getTkCo() async {
    lstTaiKhoan = await ref.read(lstBangTaiKhoanBHTKCoProvider.future);
    setTable();
  }

  void getTKNo() async {
    lstTaiKhoan = await ref.read(lstBangTaiKhoanBHTKNoProvider.future);
    setTable();
  }

  void setTable() {
    _stateManager.appendRows(
      lstTaiKhoan.map((e) {
        return TrinaRow(
          cells: {
            'null': TrinaCell(value: ''),
            BangTaiKhoanString.maTK: TrinaCell(value: e.maTK),
            BangTaiKhoanString.tenTK: TrinaCell(value: e.tenTK),
          },
        );
      }).toList(),
    );
    final index = lstTaiKhoan.indexWhere((e) => e.maTK == widget.maTK);
    if (index != -1) {
      _stateManager.moveScrollByRow(TrinaMoveDirection.down, index);
      _stateManager.setCurrentCell(_stateManager.rows[index].cells[BangTaiKhoanString.maTK], index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataGrid(
      onLoaded: (e) {
        _stateManager = e.stateManager;
        _stateManager.setShowColumnFilter(true);
        _stateManager.setKeepFocus(true);
      },
      rows: [],
      columns: [
        DataGridColumn(
          title: '',
          field: 'null',
          enableFilterMenuItem: false,
          type: TrinaColumnTypeText(),
          titleRenderer: (re) => DataGridTitle(title: ''),
          width: 20,
          renderer: (re) => DataGridContainer(),
          cellPadding: EdgeInsets.zero,
        ),
        DataGridColumn(
          title: 'Mã TK',
          width: 80,
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          renderer: (re) {
            return InkWell(
              onTap: () {
                final data = lstTaiKhoan.firstWhere((e) => e.maTK == re.cell.value);
                widget.onChanged?.call(data.maTK);
                Navigator.pop(context);
              },
              child: Text(re.cell.value, style: TextStyle(color: Colors.red)),
            );
          },
          field: BangTaiKhoanString.maTK,
          type: TrinaColumnTypeText(),
        ),
        DataGridColumn(
          title: 'Mô tả',
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          width: 290,
          field: BangTaiKhoanString.tenTK,
          type: TrinaColumnTypeText(),
        ),
      ],
    );
  }
}
