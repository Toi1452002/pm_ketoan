import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import 'component/thongtinhanghoa.dart';

class HangHoaView extends ConsumerWidget {
  HangHoaView({super.key});

  late TrinaGridStateManager _stateManager;
  List<HangHoaModel> lstHangHoa = [];

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(hangHoaProvider, (context, state) {
      // if (state.isNotEmpty) {
      lstHangHoa = state;
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        List.generate(state.length, (i) {
          final x = state[i];
          return TrinaRow(
            cells: {
              'null': TrinaCell(
                value: i + 1,
                renderer: (re) {
                  return DataGridContainer();
                },
              ),
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
            },
          );
        }),
      );
      // }
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconButton.outline(
              icon: Icon(Icons.add),
              onPressed: () => _showThongTinHangHoa(context),
              size: ButtonSize.normal,
            ),
            IconButton.outline(icon: Icon(PhosphorIcons.printer()), onPressed: () {}, size: ButtonSize.normal),
            IconButton.outline(
              icon: Icon(PhosphorIcons.microsoftExcelLogo()),
              onPressed: () {},
              size: ButtonSize.normal,
            ),
          ],
          trailing: [
            SizedBox(
              width: 300,
              child: Combobox(
                selected: ref.watch(hangHoaTheoiDoiProvider).value,

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
                },
              ),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Positioned(
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
                    width: 20,
                  ),
                  DataGridColumn(
                    title: '',
                    field: 'delete',
                    cellPadding: EdgeInsets.zero,
                    type: TrinaColumnTypeText(),
                    width: 25,
                    renderer:
                        (re) => DataGridDelete(
                          onTap: () {
                            _onDelete(re, ref);
                          },
                        ),
                  ),
                  DataGridColumn(title: 'Mã', field: HangHoaString.maHH, type: TrinaColumnTypeText(), width: 150),
                  DataGridColumn(
                    title: 'Tên vật tư-hàng hóa',
                    field: HangHoaString.tenHH,
                    type: TrinaColumnTypeText(),
                    width: 300,
                  ),
                  DataGridColumn(title: 'Đơn vị tính', field: DVTString.dvt, type: TrinaColumnTypeText(), width: 100),
                  DataGridColumn(
                    title: 'Giá mua',
                    field: HangHoaString.giaMua,
                    type: TrinaColumnType.number(),
                    textAlign: TrinaColumnTextAlign.end,
                    enableSorting: true,
                    width: 150,
                  ),
                  DataGridColumn(
                    title: 'Giá bán',
                    field: HangHoaString.giaBan,
                    type: TrinaColumnType.number(),
                    textAlign: TrinaColumnTextAlign.end,
                    enableSorting: true,
                    width: 150,
                  ),
                  DataGridColumn(
                    title: 'Loại hàng',
                    field: LoaiHangString.loaiHang,
                    type: TrinaColumnTypeText(),
                    width: 100,
                  ),
                  DataGridColumn(
                    title: 'Nhóm hàng',
                    field: NhomHangString.nhomHang,
                    type: TrinaColumnTypeText(),
                    width: 100,
                  ),
                  DataGridColumn(title: 'Nhà cung', field: HangHoaString.maNC, type: TrinaColumnTypeText(), width: 100),
                ],
              ),
            ),
            Positioned(
              child: Row(
                children: [
                  Gap(170),
                  IconButton.secondary(
                    icon: Icon(Icons.arrow_drop_down),
                    size: ButtonSize(.7),
                    onPressed: () {
                      showPopover(
                        context: context,
                        alignment: Alignment.bottomLeft,
                        offset: const Offset(0, 8),
                        // Unless you have full opacity surface,
                        // you should explicitly set the overlay barrier.
                        // overlayBarrier: OverlayBarrier(
                        //   borderRadius: theme.borderRadiusLg,
                        // ),
                        builder: (context) {
                          return ModalContainer(child: SizedBox(width: 300, height: 400));
                        },
                      );
                    },
                  ),
                  Gap(275),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                  Gap(70),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                  Gap(130),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                  Gap(120),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                  Gap(70),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                  Gap(80),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                  Gap(70),
                  IconButton.secondary(icon: Icon(Icons.arrow_drop_down, size: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
