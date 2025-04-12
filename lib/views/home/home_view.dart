import 'dart:io';

import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  List<TreeNode<String>> treeItems = [
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
    TreeItem(
      data: MenuString.thuChi,
      children: [
        TreeItem(data: MenuString.phieuThu),
        TreeItem(data: MenuString.phieuChi),
        TreeItem(
          data: MenuString.baoCao,
          children: [
            TreeItem(data: MenuString.bangkePhieuThu),
            TreeItem(data: MenuString.bangkePhieuChi),
            TreeItem(data: MenuString.soTienMat),
            TreeItem(data: MenuString.soTienGui),
          ],
        ),
      ],
    ),
    TreeItem(
      data: MenuString.heThong,
      children: [
        TreeItem(data: MenuString.thongTinDoanhNghiep),
        TreeItem(data: MenuString.danhSachNguoiDung),
        TreeItem(data: MenuString.tuyChon),
      ],
    ),
    // Tree Root acts as a parent node with no data,
    // it will flatten the children into the parent node
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoProvider);
    final tenCTY = ref.watch(ttdnTenCTyProvider);
    final diaChiCTY = ref.watch(ttdnDiaChiProvider);
    return Scaffold(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedContainer(
            child: SizedBox(
              width: 250,
              height: double.infinity,
              child: TreeView(
                padding: EdgeInsets.zero,
                allowMultiSelect: false,
                expandIcon: true,
                shrinkWrap: true,
                recursiveSelection: true,
                nodes: treeItems,
                onSelectionChanged: TreeView.defaultSelectionHandler(treeItems, (value) {
                  setState(() {
                    treeItems = value;
                  });
                }),
                builder: (context, node) {
                  return TreeItemView(
                    onPressed: () {
                      switch (node.data) {
                        //DANH MUC
                        case MenuString.hangHoa:
                          showHangHoa(context);
                          break;
                        case MenuString.khachHang:
                          showKhachHang(context);
                          break;
                        case MenuString.nhanVien:
                          showNhanVien(context);
                          break;
                        case MenuString.maNghiepVu:
                          showMaNghiepVu(context);
                          break;

                        ///************************************
                        //MUA BAN
                        case MenuString.muaHang:
                          showMuaHang(context);
                          break;
                        case MenuString.banHang:
                          showBanHang(context);
                          break;
                        case MenuString.bangKeHoaDonBanRa:
                          showBaoCaoBanHang(context);
                          break;
                        case MenuString.bangKeHoaDonMuaVao:
                          showBaoCaoMuaHang(context);
                          break;

                        ///************************************
                        //THU CHI
                        case MenuString.phieuThu:
                          showPhieuThu(context);
                          break;
                        case MenuString.phieuChi:
                          showPhieuChi(context);
                          break;
                        case MenuString.bangkePhieuThu:
                          showBangKePhieuThu(context);
                          break;
                        case MenuString.bangkePhieuChi:
                          showBangKePhieuChi(context);
                          break;

                        ///************************************
                        //HỆ THỐNG
                        case MenuString.thongTinDoanhNghiep:
                          showThongTinDoanhNghiep(context);
                          break;
                        case MenuString.danhSachNguoiDung:
                          showDSNguoiDung(context);
                          break;
                        case MenuString.tuyChon:
                          showTuyChon(context);
                          break;
                      }
                    },
                    onExpand: TreeView.defaultItemExpandHandler(treeItems, node, (value) {
                      setState(() {
                        treeItems = value;
                      });
                    }),
                    child: Text(node.data),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/01.jpg'), fit: BoxFit.cover),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 700,
                  height: 250,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.background.withValues(alpha: .8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PHẦN MỀM KẾ TOÁN').h4(),
                      Text('PMN-KT Copyright by RBG - version 1.0').large(),
                      // TextButton(child: Text('Được xây dựng bởi www.rgb.com.vn'),onPressed: (){},),
                      Text('Tên: ${tenCTY.value}').medium(),
                      Gap(10),
                      Text('ĐC: ${diaChiCTY.value}').medium(),
                      Gap(10),
                      Text('Người dùng: ${user!.hoTen}').medium(),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrimaryButton(
                            child: Text('Đăng xuất'),
                            onPressed: () {
                              ref.read(userInfoProvider.notifier).state = null;
                            },
                          ),
                          PrimaryButton(
                            child: Text('Thoát phần mềm'),
                            onPressed: () {
                              exit(0);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
