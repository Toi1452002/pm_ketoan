import 'package:app_ketoan/application/application.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../data/data.dart';
import '../../widgets/widgets.dart';


class ThongTinDoanhNghiepView extends ConsumerStatefulWidget {
  const ThongTinDoanhNghiepView({super.key});

  @override
  ConsumerState createState() => _ThongTinDoanhNghiepViewState();
}

class _ThongTinDoanhNghiepViewState extends ConsumerState<ThongTinDoanhNghiepView> {
  late TrinaGridStateManager _stateManager;
  late ThongTinDoanhNghiepNotifier _notifier;
  void _onChanged(TrinaGridOnChangedEvent e, WidgetRef ref) {
    _notifier.updateTTDN(int.parse(e.row.cells['null']!.value), e.column.field, e.value);
  }
  @override
  void initState() {
    // TODO: implement initState
    _notifier = ref.read(ttdnProvider.notifier);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(ttdnProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        _stateManager.appendRows(state.map((e) {
          return TrinaRow(cells: {
            'null': TrinaCell(value: e.id.toString(),renderer: (context){
              return DataGridContainer();
            }),
            TTDNString.tieuDe: TrinaCell(value: e.tieuDe,renderer: (context){
              return Text(context.cell.value).medium();
            }),
            TTDNString.noiDung: TrinaCell(value: e.noiDung)
          });
        }).toList());
      }
    });
    return  DataGrid(onLoaded: (e)=>_stateManager = e.stateManager,onChanged: (e) => _onChanged(e, ref),rows: [], columns: [
      DataGridColumn(title: '', field: 'null',width: 25, type: TrinaColumnTypeText(),cellPadding: EdgeInsets.zero),
      DataGridColumn(title: 'Tiêu đề', field: 'TieuDe', type: TrinaColumnTypeText(),width: 300),
      DataGridColumn(title: 'Nội dung', field: 'NoiDung', type: TrinaColumnTypeText(),enableEditingMode: true,width: 700),
    ]);
  }
}
