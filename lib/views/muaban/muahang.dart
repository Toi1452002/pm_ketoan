import 'package:app_ketoan/widgets/datagird_combobox.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../data/data.dart';
import '../../widgets/widgets.dart';

class MuaHangView extends ConsumerStatefulWidget {
  const MuaHangView({super.key});

  @override
  ConsumerState createState() => _MuaHangViewState();
}

class _MuaHangViewState extends ConsumerState<MuaHangView> {
  late TrinaGridStateManager _stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [iconAdd(onPressed: () {}), iconDelete(onPressed: () {}), iconPrinter(onPressed: () {})],
          trailing: [
            SizedBox(width: 200, child: LabelTextfield(label: 'Người tạo')),
            PrimaryButton(child: Text('Khóa'), size: ButtonSize(.8)),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 5,
          children: [
            OutlinedContainer(
              borderColor: Colors.gray.shade300,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 170,
                        child: DateTextbox(onChanged: (val) {}, label: 'Ngày xuất', showClear: false),
                      ),
                      Gap(20),
                      SizedBox(
                        width: 200,
                        child: LabelTextfield(label: 'Số phiếu', textAlign: TextAlign.center, readOnly: true),
                      ),
                      Gap(20),
                      SizedBox(width: 200, child: LabelCombobox(items: [], onChanged: (val, o) {}, label: 'Kiểu xuất')),
                      Gap(20),
                      SizedBox(width: 250, child: LabelTextfield(label: 'Ký hiệu hóa đơn')),
                      SizedBox(width: 100, child: Combobox(items: [], onChanged: (val, o) {})),
                    ],
                  ),

                  Row(
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 200,
                        child: LabelCombobox(items: [], spacing: 8, label: 'Mã khách', onChanged: (val, o) {}),
                      ),
                      SizedBox(width: 440, child: LabelTextfield()),
                      Gap(20),
                      SizedBox(width: 250, child: LabelTextfield(label: 'Số hóa đơn', spacing: 40)),
                    ],
                  ),
                  Row(
                    spacing: 10,

                    children: [
                      SizedBox(width: 650, child: LabelTextfield(label: 'Diễn giải', spacing: 14)),
                      Gap(20),
                      SizedBox(
                        width: 250,
                        child: DateTextbox(
                          showClear: false,
                          label: 'Ngày hóa đơn',
                          spacing: 23,
                          onChanged: (DateTime? value) {},
                        ),
                      ),
                    ],
                  ),

                  /// Table chi tiết
                  SizedBox(
                    height: 300,
                    child: DataGrid(
                      onLoaded: (e) {
                        _stateManager = e.stateManager;
                        _stateManager.appendNewRows(count: 20);
                      },
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
                          renderer: (re) => DataGridDelete(onTap: () {}),
                          cellPadding: EdgeInsets.zero,
                        ),
                        DataGridColumn(
                          title: 'Mã hàng',
                          width: 120,
                          enableEditingMode: true,
                          cellPadding: EdgeInsets.zero,
                          field: HangHoaString.maHH,
                          // editCellRenderer: (defaultEditCellWidget, cell, controller, focusNode, handleSelected) {
                            // return DataGridCombobox(
                            //   items: List.generate(10, (i) {
                            //     return DataGridComboboxItem(value: 'item $i', title: ['item $i']);
                            //   }),
                            //   onChanged: (val, o) {},
                            //   controller: controller,
                            //   focusNode: focusNode,
                            // );
                            // return DataGridCombobox(
                            //   columnWidth: [119, 300],
                            //   menuWidth: 422,
                            //   items: List.generate(10, (i) {
                            //     return DataGridComboboxItem(value: 'item $i', title: ['item $i', 'item vip']);
                            //   }),
                            //   onChanged: (val) {},
                            //   isOpen: (b) {},
                            // );
                          // },
                          type: TrinaColumnType.text(),
                        ),
                        DataGridColumn(
                          width: 300,
                          title: 'Tên hàng hóa - vật tư',
                          field: PhieuXuatCTString.tenHH,
                          type: TrinaColumnType.text(),
                        ),
                        DataGridColumn(title: 'ĐVT', width: 80, field: DVTString.dvt, type: TrinaColumnType.text()),
                        DataGridColumn(
                          title: 'Số lg',
                          enableEditingMode: true,
                          width: 80,
                          field: PhieuXuatCTString.soLg,
                          textAlign: TrinaColumnTextAlign.end,
                          type: TrinaColumnType.number(),
                        ),
                        DataGridColumn(
                          title: 'Đơn giá',
                          field: PhieuXuatCTString.donGia,
                          textAlign: TrinaColumnTextAlign.end,

                          type: TrinaColumnType.number(),
                          width: 120,
                        ),
                        DataGridColumn(
                          title: 'Thành tiền',
                          field: PhieuXuatCTString.thanhTien,
                          textAlign: TrinaColumnTextAlign.end,
                          type: TrinaColumnType.number(),
                          width: 120,
                        ),
                        DataGridColumn(
                          title: 'TK Nợ',
                          width: 90,
                          field: PhieuXuatCTString.tkGV,
                          type: TrinaColumnType.text(),
                        ),
                        DataGridColumn(
                          title: 'TK Có',
                          width: 90,
                          field: PhieuXuatCTString.tkKho,
                          type: TrinaColumnType.text(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 868,
                    child: Row(
                      children: [
                        Gap(200),
                        SizedBox(
                          width: 150,
                          child: LabelCombobox(items: [], onChanged: (val, o) {}, label: 'TK Nợ/Có'),
                        ),
                        SizedBox(width: 85, child: Combobox(items: [], onChanged: (val, o) {})),
                        Gap(20),
                        Checkbox(
                          state: CheckboxState.unchecked,
                          onChanged: (val) {},
                          trailing: Text('Không chịu thuế').medium(),
                        ),
                        Spacer(),
                        SizedBox(width: 226, child: LabelTextfield(label: 'Cộng tiền hàng', isNumber: true)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 868,
                    child: Row(
                      children: [
                        Gap(200),
                        SizedBox(
                          width: 150,
                          child: LabelCombobox(items: [], onChanged: (val, o) {}, label: 'TK VAT', spacing: 22),
                        ),
                        SizedBox(width: 85, child: Combobox(items: [], onChanged: (val, o) {})),
                        Gap(30),
                        SizedBox(width: 120, child: LabelTextfield(label: 'Thuế suất')),
                        Spacer(),
                        SizedBox(width: 225, child: LabelTextfield(label: 'Tiền thuế GTGT', isNumber: true)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 868,
                    child: Row(
                      children: [
                        Spacer(),
                        SizedBox(width: 260, child: LabelTextfield(isNumber: true, label: 'Tổng tiền thanh toán')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GroupButtonNumberPage(text: 'null', last: () {}, next: () {}, back: () {}, first: () {}),
          ],
        ),
      ),
    );
  }
}
