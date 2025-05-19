import 'package:app_ketoan/application/providers/dauky_provider.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../core/utils/custom_alert.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class DauKyTaiKhoanView extends ConsumerStatefulWidget {
  const DauKyTaiKhoanView({super.key});

  @override
  ConsumerState createState() => _DauKyTaiKhoanViewState();
}

class _DauKyTaiKhoanViewState extends ConsumerState<DauKyTaiKhoanView> {
  late TrinaGridStateManager _stateManager;

  String _selectThang = DateTime.now().month.toString();
  final txtNam = TextEditingController(text: DateTime.now().year.toString());

  void onCapNhatDauKy() async {
    _stateManager.setCurrentCell(_stateManager.firstCell, 0);
    _stateManager.setKeepFocus(false);
    final x = _stateManager.rows.where(
      (e) => e.cells[DauKyTaiKhoanString.dkNo]!.value != 0 || e.cells[DauKyTaiKhoanString.dkCo]!.value != 0,
    );
    _stateManager.setFilter((row) {
      return row.cells[DauKyTaiKhoanString.dkNo]!.value != 0 || row.cells[DauKyTaiKhoanString.dkCo]!.value != 0;
    });
    final btn = await CustomAlert().question(
      'Danh sách trên sẽ được cập nhật vào SỔ ĐẦU KỲ ($_selectThang-${txtNam.text})',
      title: 'DAU KY TAI KHOAN',
    );
    if (btn == AlertButton.okButton) {
      final lst =
          x.map((row) {
            final a = DateTime(int.tryParse(txtNam.text) ?? 0, int.parse(_selectThang));
            final b = DateFormat('yyyy-MM').format(DateTime(a.year, a.month - 1));
            return DauKyTaiKhoangModel(
              maTK: row.cells[DauKyTaiKhoanString.maTK]!.value,
              dkNo: double.parse(row.cells[DauKyTaiKhoanString.dkNo]!.value.toString()),
              dkCo: double.parse(row.cells[DauKyTaiKhoanString.dkCo]!.value.toString()),
              thang: b,
            );
          }).toList();
      final result = await ref.read(dkyTaiKhoanProvider.notifier).capNhatDauKyTK(lst);
      if (result) {
        CustomAlert().success('Cập nhật thành công');
        ref
            .read(dkyTaiKhoanProvider.notifier)
            .getDKyTaiKhoan(val: DateTime(int.tryParse(txtNam.text) ?? 0, int.parse(_selectThang)));
      } else {
        CustomAlert().error('Cập nhật thất bại');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dkyTaiKhoanProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: ''),
              DauKyTaiKhoanString.maTK: TrinaCell(value: e.maTK),
              DauKyTaiKhoanString.tenTK: TrinaCell(value: e.tenTK),
              DauKyTaiKhoanString.tc: TrinaCell(value: e.tc),
              DauKyTaiKhoanString.dkNo: TrinaCell(value: e.dkNo),
              DauKyTaiKhoanString.dkCo: TrinaCell(value: e.dkCo),
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
            SizedBox(
              width: 110,
              child: LabelCombobox(
                items: List.generate(12, (i) => ComboboxItem(value: "${i + 1}", title: ["${i + 1}"])),
                selected: _selectThang,
                onChanged: (val, o) {
                  setState(() {
                    _selectThang = val!;
                  });
                },
                label: 'Tháng',
              ),
            ),
            SizedBox(width: 100, child: LabelTextfield(label: 'Năm', controller: txtNam, textAlign: TextAlign.center)),
            PrimaryButton(
              size: ButtonSize.small,
              onPressed: () {
                ref
                    .read(dkyTaiKhoanProvider.notifier)
                    .getDKyTaiKhoan(val: DateTime(int.tryParse(txtNam.text) ?? 0, int.parse(_selectThang)));
              },
              child: Text('Thực hiện'),
            ),
          ],
          trailing: [TextButton(onPressed: onCapNhatDauKy, size: ButtonSize.normal, child: Text('Lưu đầu kỳ'))],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) {
            _stateManager = e.stateManager;
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnType.text(),
              titleRenderer: (re) => DataGridTitle(title: ''),
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
              width: 25,
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(
              title: 'Mã TK',
              field: DauKyTaiKhoanString.maTK,
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
              type: TrinaColumnType.text(),
              width: 80,
            ),
            DataGridColumn(
              title: 'Mô tả tài khoản',
              width: 280,
              field: DauKyTaiKhoanString.tenTK,
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(
              title: 'TC',
              field: DauKyTaiKhoanString.tc,
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
              type: TrinaColumnType.text(),
              textAlign: TrinaColumnTextAlign.center,
              width: 50,
            ),
            DataGridColumn(
              title: 'Đầu kỳ nợ',
              field: DauKyTaiKhoanString.dkNo,
              textAlign: TrinaColumnTextAlign.end,
              type: TrinaColumnType.number(format: '#,###.##'),
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
              enableEditingMode: true,
              width: 130,
              footerRenderer: (re) => DataGridFooter(re),
            ),
            DataGridColumn(
              title: 'Đầu kỳ có',
              field: DauKyTaiKhoanString.dkCo,
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
              textAlign: TrinaColumnTextAlign.end,
              type: TrinaColumnType.number(format: '#,###.##'),
              width: 130,
              enableEditingMode: true,
              footerRenderer: (re) => DataGridFooter(re),
            ),
          ],
        ),
      ),
    );
  }
}
