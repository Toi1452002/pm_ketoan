import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/thuchi/component/phieuchichitiet.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../application/application.dart';
import '../../data/data.dart';
import '../../widgets/widgets.dart';
import 'component/pdf_phieuchi.dart';

class PhieuChiView extends ConsumerStatefulWidget {
  final int? stt;

  const PhieuChiView({super.key, this.stt});

  @override
  ConsumerState createState() => _PhieuChiViewState();
}

class _PhieuChiViewState extends ConsumerState<PhieuChiView> {
  Map<String, String> pttt = {'TM': 'Tiền mặt', 'NH': 'Chuyển khoản'};
  dynamic soTien;

  @override
  void initState() {
    if (widget.stt == null) {
      ref.read(phieuChiProvider.notifier).getLastPhieuChi(ref: ref);
    } else {
      ref.read(phieuChiProvider.notifier).onMovePhieuChi(widget.stt!, ref: ref);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lstKieuChi = ref.watch(mnvLstChiProvider);
    final lstNhanVien = ref.watch(nvListAllProvider);
    final lstNhaCung = ref.watch(lstNhaCungProvider);
    final lstBangTaiKhoan = ref.watch(btkListAllProvider);

    final wPhieuChi = ref.watch(phieuChiProvider);
    final rPhieuChi = ref.read(phieuChiProvider.notifier);
    final qlXBC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlXBC).giaTri ==
        1; //Nếu bằng 1 thi xem bc truoc khi in
    final qlKPC = ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlKPC).giaTri == 1;

    List<ComboboxItem> lstComboboxItem = [];

    if (wPhieuChi?.maTC == 'CNC') {
      if (lstNhanVien.hasValue) {
        lstComboboxItem = lstNhanVien.value!.map((e) => ComboboxItem(value: e.maNV, title: [e.maNV, e.hoTen])).toList();
      }
    } else if (wPhieuChi?.maTC == 'CTN') {
      if (lstNhaCung.hasValue) {
        lstComboboxItem =
            lstNhaCung.value!.map((e) => ComboboxItem(value: e.maKhach, title: [e.maKhach, e.tenKH])).toList();
      }
    }
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconAdd(
              onPressed: () {
                final user = ref.read(userInfoProvider);
                if (qlKPC && !wPhieuChi!.khoa) {
                  rPhieuChi.updatePhieuChi(PhieuThuString.khoa, 1, wPhieuChi.phieu);
                }
                rPhieuChi.addPhieuChi(user!, ref);
              },
            ),
            IconDelete(
              enabled: !(wPhieuChi == null || wPhieuChi.khoa),
              onPressed: () async {
                final btn = await CustomAlert().warning(AppString.delete, title: 'PHIẾU CHI');
                if (btn == AlertButton.okButton) {
                  rPhieuChi.deletePhieuChi(wPhieuChi!.id!, ref: ref);
                }
              },
            ),
            IconPrinter(
              onPressed: () async {
                if (!wPhieuChi!.khoa) {
                  rPhieuChi.updatePhieuChi(PhieuThuString.khoa, 1, wPhieuChi.phieu);
                }
                final sqlRepository = SqlRepository(tableName: TableName.ttdn);
                final diaChiCTY =
                    await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'DC'") ?? '';
                final tenCTY =
                    await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'TCT'") ??
                    '';
                if (qlXBC) {
                  showViewPrinter(context, PdfPhieuChiView(diaChi: diaChiCTY, tenCTY: tenCTY, phieuChi: wPhieuChi));
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfPhieuChi(
                      dateNow: Helper.dateNowDMY(),
                      tenCTy: tenCTY,
                      diaChi: diaChiCTY,
                      phieuChi: wPhieuChi,
                    ),
                  );
                }
              },
            ),
          ],
          trailing: [
            SizedBox(
              width: 200,
              child: LabelTextfield(
                label: 'Người tạo',
                controller: TextEditingController(text: wPhieuChi?.createdBy),
                enabled: false,
              ),
            ),
            PrimaryButton(
              enabled: !(wPhieuChi == null),
              onPressed: () {
                rPhieuChi.updatePhieuChi(PhieuChiString.khoa, !wPhieuChi!.khoa ? 1 : 0, wPhieuChi.phieu);
              },
              size: ButtonSize(.8),
              child: Text(wPhieuChi != null && wPhieuChi.khoa ? 'Sửa' : 'Khóa'),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(10),
        child:
            wPhieuChi == null
                ? null
                : Column(
                  children: [
                    Expanded(
                      child: OutlinedContainer(
                        borderColor: Colors.gray.shade300,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: DateTextbox(
                                    initialDate: Helper.stringToDate(wPhieuChi.ngay),
                                    onChanged: (val) {
                                      rPhieuChi.updatePhieuChi(
                                        PhieuChiString.ngay,
                                        Helper.dateFormatYMD(val),
                                        wPhieuChi.phieu,
                                      );
                                    },
                                    enabled: !wPhieuChi.khoa,
                                    label: 'Ngày chi',
                                    spacing: 56,
                                    showClear: false,
                                  ),
                                ),
                                Expanded(
                                  child: LabelTextfield(
                                    controller: TextEditingController(text: wPhieuChi.phieu),
                                    label: 'Số phiếu',
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: LabelCombobox(
                                    items:
                                        lstKieuChi.hasValue
                                            ? lstKieuChi.value!
                                                .map(
                                                  (e) => ComboboxItem(
                                                    value: e.moTa!,
                                                    title: [e.moTa!],
                                                    valueOther: e.maNghiepVu,
                                                  ),
                                                )
                                                .toList()
                                            : [],
                                    onChanged: (val, o) {
                                      rPhieuChi.updateKieuChi(o, wPhieuChi.phieu);
                                    },
                                    enabled: !wPhieuChi.khoa,
                                    selected:
                                        lstKieuChi.value!
                                            .firstWhere(
                                              (e) => e.maNghiepVu == wPhieuChi.maTC,
                                              orElse: () => const MaNghiepVuModel(maNghiepVu: '', moTa: null),
                                            )
                                            .moTa,
                                    // isChangeEmpty: false,
                                    label: 'Kiểu chi',
                                    spacing: 61,
                                  ),
                                ),
                                Expanded(
                                  child:
                                      ['CNC', 'CTN'].contains(wPhieuChi.maTC)
                                          ? LabelCombobox(
                                            spacing: wPhieuChi.maTC == 'CNC' ? 25 : 5,
                                            menuWidth: 300,
                                            enabled: !wPhieuChi.khoa,
                                            columnWidth: const [90, 200],
                                            selected: wPhieuChi.maTC == 'CNC' ? wPhieuChi.maNV : wPhieuChi.maKhach,
                                            // isChangeEmpty: false,
                                            items: lstComboboxItem,
                                            onChanged: (val, o) {
                                              if (wPhieuChi.maTC == 'CNC') {
                                                //Chi nhân công
                                                final nv = lstNhanVien.value!.firstWhere(
                                                  (e) => e.maNV == val,
                                                  orElse:
                                                      () => const NhanVienModel(
                                                        maNV: '',
                                                        hoTen: '',
                                                        thoiVu: false,
                                                        khongCuTru: false,
                                                        coCk: false,
                                                      ),
                                                );
                                                rPhieuChi.updateNhanVien(val, wPhieuChi.phieu, nv);
                                              } else {
                                                //Chi trả nợ(Nhà cung)
                                                final khach = lstNhaCung.value!.firstWhere(
                                                  (e) => e.maKhach == val,
                                                  orElse: () => const KhachHangModel(maKhach: '', tenKH: ''),
                                                );
                                                rPhieuChi.updateNhaCung(val, wPhieuChi.phieu, khach);
                                              }
                                            },
                                            label: wPhieuChi.maTC == 'CNC' ? 'MaNV' : 'Mã khách',
                                          )
                                          : SizedBox(),
                                ),
                              ],
                            ),
                            LabelTextfield(
                              label: 'Tên khách',
                              enabled: !wPhieuChi.khoa,
                              spacing: 48,
                              controller: TextEditingController(text: wPhieuChi.tenKhach),
                              onChanged: (val) {
                                rPhieuChi.updatePhieuChi(PhieuChiString.tenKhach, val, wPhieuChi.phieu);
                              },
                            ),
                            LabelTextfield(
                              enabled: !wPhieuChi.khoa,
                              controller: TextEditingController(text: wPhieuChi.diaChi),
                              label: 'Địa chỉ',
                              spacing: 68,
                              onChanged: (val) {
                                rPhieuChi.updatePhieuChi(PhieuChiString.diaChi, val, wPhieuChi.phieu);
                              },
                            ),
                            LabelTextfield(
                              label: 'Người nhận tiền',
                              enabled: !wPhieuChi.khoa,
                              controller: TextEditingController(text: wPhieuChi.nguoiNhan),
                              onChanged: (val) {
                                rPhieuChi.updatePhieuChi(PhieuChiString.nguoiNhan, val, wPhieuChi.phieu);
                              },
                            ),
                            LabelTextfield(
                              label: 'Người chi tiền',
                              enabled: !wPhieuChi.khoa,
                              controller: TextEditingController(text: wPhieuChi.nguoiChi),
                              onChanged: (val) {
                                rPhieuChi.updatePhieuChi(PhieuChiString.nguoiChi, val, wPhieuChi.phieu);
                              },
                              spacing: 23,
                            ),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Focus(
                                    onFocusChange: (b) {
                                      if (!b) {
                                        rPhieuChi.formatSoTien(soTien);
                                      }
                                    },
                                    child: LabelTextfield(
                                      label: 'Số tiền',
                                      spacing: 68,
                                      isNumber: true,
                                      enabled: !wPhieuChi.khoa,
                                      controller: TextEditingController(text: Helper.numFormat(wPhieuChi.soTien)),
                                      onChanged: (val) {
                                        soTien = Helper.numFormatToDouble(val);
                                        rPhieuChi.updatePhieuChi(PhieuChiString.soTien, soTien, wPhieuChi.phieu);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: LabelCombobox(
                                    enabled: !wPhieuChi.khoa,
                                    menuWidth: 350,
                                    selected: wPhieuChi.tkNo,
                                    columnWidth: const [65, 270],
                                    items:
                                        !lstBangTaiKhoan.hasValue
                                            ? []
                                            : lstBangTaiKhoan.value!
                                                .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                                .toList(),
                                    onChanged: (val, o) {
                                      rPhieuChi.updatePhieuChi(PhieuChiString.tkNo, val, wPhieuChi.phieu);
                                    },
                                    label: 'Nợ',
                                  ),
                                ),
                                Expanded(
                                  child: LabelCombobox(
                                    enabled: !wPhieuChi.khoa,
                                    selected: wPhieuChi.tkCo,
                                    menuWidth: 350,
                                    columnWidth: const [65, 270],
                                    items:
                                        !lstBangTaiKhoan.hasValue
                                            ? []
                                            : lstBangTaiKhoan.value!
                                                .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                                .toList(),
                                    onChanged: (val, o) {
                                      rPhieuChi.updatePhieuChi(PhieuChiString.tkCo, val, wPhieuChi.phieu);
                                    },
                                    label: 'Có',
                                  ),
                                ),
                              ],
                            ),
                            LabelTextfield(
                              label: 'Lý do nộp',
                              spacing: 50,
                              enabled: !wPhieuChi.khoa,
                              controller: TextEditingController(text: wPhieuChi.noiDung),
                              onChanged: (val) {
                                rPhieuChi.updatePhieuChi(PhieuChiString.noiDung, val, wPhieuChi.phieu);
                              },
                            ),
                            Row(
                              spacing: 30,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: LabelTextfield(
                                    label: 'Số chứng từ',
                                    spacing: 36,
                                    enabled: !wPhieuChi.khoa,
                                    controller: TextEditingController(text: wPhieuChi.soCT),
                                    onChanged: (val) {
                                      rPhieuChi.updatePhieuChi(PhieuChiString.soCT, val, wPhieuChi.phieu);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: LabelCombobox(
                                    enabled: !wPhieuChi.khoa,
                                    selected: pttt[wPhieuChi.pttt],
                                    readOnly: true,
                                    items: [
                                      ComboboxItem(value: 'Tiền mặt', title: ['Tiền mặt'], valueOther: 'TM'),
                                      ComboboxItem(value: 'Chuyển khoản', title: ['Chuyển khoản'], valueOther: 'NH'),
                                    ],
                                    onChanged: (val, o) {
                                      rPhieuChi.updatePhieuChi(PhieuChiString.pttt, o, wPhieuChi.phieu);
                                    },
                                    label: 'PTTT',
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: PhieuChiCTView(maID: wPhieuChi.id!,khoa: wPhieuChi.khoa,)),
                          ],
                        ),
                      ),
                    ),
                    Gap(5),

                    Row(
                      spacing: 5,
                      children: [
                        GroupButtonNumberPage(
                          text: "${wPhieuChi.stt}/${wPhieuChi.countRow}",
                          first: () {
                            if (wPhieuChi.stt != 1) {
                              rPhieuChi.onMovePhieuChi(1, ref: ref);
                            }
                          },
                          back: () {
                            if (wPhieuChi.stt != 1) {
                              rPhieuChi.onMovePhieuChi(wPhieuChi.stt! - 1, ref: ref);
                            }
                          },
                          next: () {
                            if (wPhieuChi.stt.toString() != wPhieuChi.countRow) {
                              rPhieuChi.onMovePhieuChi(wPhieuChi.stt! + 1, ref: ref);
                            }
                          },
                          last: () {
                            if (wPhieuChi.stt.toString() != wPhieuChi.countRow) {
                              rPhieuChi.getLastPhieuChi(ref: ref);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
