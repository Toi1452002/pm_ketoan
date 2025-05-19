import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/custom_title_datagrid/datagrid_title.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:app_ketoan/widgets/date_textbox.dart';
import 'package:app_ketoan/widgets/icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class TongHopCongNoView extends ConsumerStatefulWidget {
  const TongHopCongNoView({super.key});

  @override
  ConsumerState createState() => _TongHopCongNoViewState();
}

class _TongHopCongNoViewState extends ConsumerState<TongHopCongNoView> {
  DateTime _ngay = DateTime.now();
  late TrinaGridStateManager _stateManager;

  @override
  void initState() {
    // TODO: implement initState
    ref.read(tongHopCongNoProvider.notifier).getTongHopCongNo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(tongHopCongNoProvider, (context, state){
      _stateManager.removeAllRows();
      _stateManager.appendRows(state.map((e){
        return TrinaRow(cells: {
          'null':TrinaCell(value: ''),
          'MaKhach': TrinaCell(value: e['MaKhach']),
          'TenKH': TrinaCell(value: e['TenKH']),
          'PhaiThu': TrinaCell(value: e['PhaiThu']),
          'PhaiTra': TrinaCell(value: e['PhaiTra']),
        });
      }).toList());
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
          leading: [
            IconPrinter(onPressed: (){}),
            IconExcel(onPressed: (){})
          ],
          trailing: [
            SizedBox(width: 120,child: DateTextbox(initialDate: _ngay,onChanged: (val){
              setState(() {
                _ngay = val!;
              });
            },showClear: false,)),
            PrimaryButton(onPressed: (){
              ref.read(tongHopCongNoProvider.notifier).getTongHopCongNo(ngay: _ngay);
            },size: ButtonSize.small,child: Text('Thuc hien'),)
          ],
        )
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e)=>_stateManager = e.stateManager,
          rows: [],
          onRowDoubleTap: (re){
            if(re.cell.column.field =='MaKhach'){
              // showKhachHang(context)
            }
          },
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnTypeText(),
              width: 25,
              cellPadding: EdgeInsets.zero,
              titleRenderer: (re) => DataGridTitle(title:''),
              renderer: (re)=>DataGridContainer(text: "${re.rowIdx+1}",)
            ),
            DataGridColumn(
              title: 'Mã KH',
              field: 'MaKhach',
              type: TrinaColumnTypeText(),
              width: 100,
              renderer: (re)=>Text(re.cell.value,style: TextStyle(color: Colors.red),),
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              field: 'TenKH',
              type: TrinaColumnTypeText(),
              width: 250,
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
            ),
            DataGridColumn(
              title: 'Phải thu',
              field: 'PhaiThu',
              type: TrinaColumnType.number(),
              width: 120,
                footerRenderer: (re)=>DataGridFooter(re),
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
              textAlign: TrinaColumnTextAlign.end
            ),
            DataGridColumn(
              title: 'Phải trả',
              field: 'PhaiTra',
              type: TrinaColumnType.number(),
              width: 120,
              footerRenderer: (re)=>DataGridFooter(re),
              titleRenderer: (re) => DataGridTitle(title: re.column.title),
                textAlign: TrinaColumnTextAlign.end
            ),
          ],
          columnGroups: [
            TrinaColumnGroup(title: 'Khách hàng', backgroundColor: Colors.blue.shade300, fields: ['MaKhach', 'TenKH']),
            // TrinaColumnGroup(title: 'MaKH',fields: ['MaKH'],expandedColumn: true),
            // TrinaColumnGroup(title: 'TenKH',fields: ['TenKH'],expandedColumn: true),
            TrinaColumnGroup(
              title: 'Số dư cuối kỳ',
              backgroundColor: Colors.blue.shade300,
              fields: ['PhaiThu', 'PhaiTra'],
            ),
          ],
        ),
      ),
    );
  }
}
