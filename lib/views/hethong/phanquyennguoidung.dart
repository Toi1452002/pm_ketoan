import 'package:app_ketoan/application/application.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/constants/constants.dart';
import '../../data/data.dart';

final pqDPSDProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

class PhanQuyenNguoiDungView extends ConsumerStatefulWidget {
  const PhanQuyenNguoiDungView({super.key});

  @override
  ConsumerState createState() => _PhanQuyenNguoiDungViewState();
}

class _PhanQuyenNguoiDungViewState extends ConsumerState<PhanQuyenNguoiDungView> {
  int selectedID = 0;
  String selectNodeData = '';
  List<TreeNode<String>> listMenu = [
    TreeItem(
      data: MenuString.danhMuc,
      children: [
        TreeItem(data: MenuString.hangHoa),
        TreeItem(data: MenuString.khachHang),
        TreeItem(data: MenuString.nhanVien),
        TreeItem(data: MenuString.maNghiepVu),
        TreeItem(data: MenuString.bangTaiKhoan),
        TreeItem(
          data: MenuString.dauKy,
          children: [
            TreeItem(data: MenuString.noDauKy),
            TreeItem(data: MenuString.tonDauKy),
            TreeItem(data: MenuString.dauKyTaiKhoan),
          ],
        ),
      ],
    ),

    TreeItem(
      data: MenuString.muaBan,
      children: [
        TreeItem(data: MenuString.muaHang),
        TreeItem(data: MenuString.banHang),
        TreeItem(
          data: MenuString.baoCao,
          children: [
            TreeItem(data: MenuString.bangKeHoaDonMuaVao),
            TreeItem(data: MenuString.bangKeHoaDonBanRa),
            TreeItem(data: MenuString.bangKeHangBan),
          ],
        ),
      ],
    ),

    ///THU CHI
    TreeItem(
      data: MenuString.thuChi,
      children: [
        TreeItem(data: MenuString.phieuThu),
        TreeItem(data: MenuString.phieuChi),
        TreeItem(
          data: MenuString.baoCaoThuChi,
          children: [
            TreeItem(data: MenuString.bangkePhieuThu),
            TreeItem(data: MenuString.bangkePhieuChi),
            TreeItem(data: MenuString.soTienMat),
            TreeItem(data: MenuString.soTienGui),
          ],
        ),
      ],
    ),

    ///CONG NO
    TreeItem(
      data: MenuString.congNO,
      children: [
        TreeItem(data: MenuString.soMuaHang),
        TreeItem(data: MenuString.soBanHang),
        TreeItem(data: MenuString.tongHopCongNo),
      ],
    ),

    ///KHO HANG
    TreeItem(
      data: MenuString.khoHang,
      children: [
        TreeItem(data: MenuString.bangKeHangNhap),
        TreeItem(data: MenuString.bangKeHangXuat),
        TreeItem(data: MenuString.nhapXuatTonKho),
      ],
    ),

    ///GIA THANH
    TreeItem(
      data: MenuString.giaThanh,
      children: [
        TreeItem(data: MenuString.tinhToanGiaVon),
        TreeItem(data: MenuString.dinhMucSanXuat),
        TreeItem(data: MenuString.bangTinhGiaThanh),
        TreeItem(data: MenuString.theTinhGiaThanh),
        TreeItem(data: MenuString.soChiPhiSXKD),
      ],
    ),

    ///TIEN LUONG
    TreeItem(
      data: MenuString.tienLuong,
      children: [TreeItem(data: MenuString.bangChamCong), TreeItem(data: MenuString.bangThanhToanLuong)],
    ),

    ///TAI SAN
    TreeItem(
      data: MenuString.taiSan,
      children: [TreeItem(data: MenuString.bangKhauHaoTSCD), TreeItem(data: MenuString.bangPhanBoCDCC)],
    ),

    ///SO KE TOAN
    TreeItem(
      data: MenuString.soKeToan,
      children: [
        TreeItem(
          data: MenuString.nhatKy,
          children: [
            TreeItem(data: MenuString.soNhatKyChung),
            TreeItem(data: MenuString.soCaiTaiKhoan),
            TreeItem(data: MenuString.soChiTietTaiKhoan),
          ],
        ),
        TreeItem(
          data: MenuString.baoCaoTaiChinh,
          children: [
            TreeItem(data: MenuString.bangCanDoiPhatSinh),
            TreeItem(data: MenuString.bangCanDoiKeToan),
            TreeItem(data: MenuString.baoCaoKQKD),
            TreeItem(data: MenuString.baoCaoLCTT),
            TreeItem(data: MenuString.thuyetMinhBCTC),
          ],
        ),
        TreeItem(
          data: MenuString.baoCaoThue,
          children: [
            TreeItem(data: MenuString.thueTamTinh),
            TreeItem(data: MenuString.chuyenLo),
            TreeItem(data: MenuString.thueTNDN),
            TreeItem(data: MenuString.thueTNCN),
            TreeItem(data: MenuString.soThue),
          ],
        ),
      ],
    ),

    ///HE THONG
    TreeItem(
      data: MenuString.heThong,
      children: [
        TreeItem(data: MenuString.thongTinDoanhNghiep),
        TreeItem(data: MenuString.danhSachNguoiDung),
        TreeItem(data: MenuString.phanQuyenNguoiDung),
        TreeItem(data: MenuString.tuyChon),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final wUser = ref.watch(userProvider);
    wUser.removeWhere((e)=>e.id==1);

    return Scaffold(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Expanded(
                child: OutlinedContainer(
                  width: 170,
                  backgroundColor: Colors.gray.shade300,
                  padding: EdgeInsets.all(10),
                  child: RadioGroup(
                    value: selectedID,
                    onChanged: (val) async {
                      setState(() {
                        selectedID = val;
                      });

                      if (selectNodeData != '') {
                        final ma = mDanhMuc[selectNodeData]!.ma;
                        final tableName = mDanhMuc[selectNodeData]!.tableName;
                        final userName = wUser
                            .firstWhere((e) => e.id == selectedID)
                            .userName;
                        String field = 'TenForm';
                        if (tableName == TableName.nhomMC1) field = 'MaC1';
                        if (tableName == TableName.nhomMC2) field = 'MaC2';

                        final result = await ref
                            .read(hangMucProvider.notifier)
                            .getChoPhep(tableName, field, ma, userName);
                        if (result != null) {
                          ref
                              .read(pqDPSDProvider.notifier)
                              .state = result;
                        }
                      }
                    },
                    child: ListView(
                      children: wUser
                          .map((e) => RadioCard(value: e.id!, child: SizedBox(width: 120, child: Text(e.userName))))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    enabled: selectNodeData != '' && selectedID != 0,
                    state: ref.watch(pqDPSDProvider) ? CheckboxState.checked : CheckboxState.unchecked,
                    onChanged: (val) {
                      ref
                          .read(pqDPSDProvider.notifier)
                          .state = val.index == 0;
                      final ma = mDanhMuc[selectNodeData]!.ma;
                      final tableName = mDanhMuc[selectNodeData]!.tableName;
                      final userName = wUser
                          .firstWhere((e) => e.id == selectedID)
                          .userName;
                      String field = 'TenForm';
                      if (tableName == TableName.nhomMC1) field = 'MaC1';
                      if (tableName == TableName.nhomMC2) field = 'MaC2';

                      ref.read(hangMucProvider.notifier).updateChoPhep(
                          tableName, field, val.index == 1 ? 0 : 1, userName, field, ma);
                    },
                    trailing: Text('Được phép sử dụng'),
                  ),
                  Gap(5),
                  Divider(),
                  Expanded(
                    child: TreeView(
                      padding: EdgeInsets.zero,
                      allowMultiSelect: false,
                      expandIcon: true,
                      shrinkWrap: true,
                      recursiveSelection: true,
                      onSelectionChanged: TreeView.defaultSelectionHandler(listMenu, (value) {
                        setState(() {
                          listMenu = value;
                        });
                      }),

                      nodes: listMenu,
                      builder: (context, node) {
                        return TreeItemView(
                          onPressed: () async {
                            selectNodeData = node.data;
                            if (selectedID != 0) {
                              final ma = mDanhMuc[node.data]!.ma;
                              final tableName = mDanhMuc[node.data]!.tableName;
                              final userName = wUser
                                  .firstWhere((e) => e.id == selectedID)
                                  .userName;
                              String field = 'TenForm';
                              if (tableName == TableName.nhomMC1) field = 'MaC1';
                              if (tableName == TableName.nhomMC2) field = 'MaC2';

                              final result = await ref
                                  .read(hangMucProvider.notifier)
                                  .getChoPhep(tableName, field, ma, userName);
                              if (result != null) {
                                ref
                                    .read(pqDPSDProvider.notifier)
                                    .state = result;
                              }
                            }
                          },
                          onExpand: TreeView.defaultItemExpandHandler(listMenu, node, (value) {
                            setState(() {
                              listMenu = value;
                            });
                          }),
                          child: Text(node.data),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
