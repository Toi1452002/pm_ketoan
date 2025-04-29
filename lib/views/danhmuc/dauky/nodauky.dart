import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

class NoDauKyView extends ConsumerWidget {
  const NoDauKyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(child: DataGrid(rows: [], columns: [
      DataGridColumn(title: 'Ngày', field: 'Ngay', type: TrinaColumnType.text()),
    ]));
  }
}
