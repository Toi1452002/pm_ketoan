import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class TuyChonView extends ConsumerStatefulWidget {
  const TuyChonView({super.key});

  @override
  ConsumerState createState() => _TuyChonViewState();
}

class _TuyChonViewState extends ConsumerState<TuyChonView> {
  List<TuyChonModel> _lstData = [];
  bool qlXBC = false;
  bool qlKPC = false;

  @override
  void initState() {
    // TODO: implement initState
    _lstData = ref.read(tuyChonProvider);
    qlXBC = _lstData.firstWhere((e) => e.nhom == 'qlXBC').giaTri == 1;
    qlKPC = _lstData.firstWhere((e) => e.nhom == 'qlKPC').giaTri == 1;
    setState(() {});
    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _lstData.clear();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            OutlinedContainer(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    state: qlKPC ? CheckboxState.checked : CheckboxState.unchecked,
                    onChanged: (val) {
                      setState(() {
                        qlKPC = val.index == 0;
                      });
                    },
                    trailing: Text('Khóa phiếu Nhập Xuất Thu Chi khi thêm phiếu'),
                  ),
                  Checkbox(
                    state: qlXBC ? CheckboxState.checked : CheckboxState.unchecked,
                    onChanged: (val) {
                      setState(() {
                        qlXBC = val.index == 0;
                      });
                    },
                    trailing: Text('Xem báo cáo trước khi in'),
                  ),
                ],
              ),
            ),
            Gap(15),
            PrimaryButton(child: Text('Cập nhật'), onPressed: () async{
              final x = await ref.read(tuyChonProvider.notifier).updateTuyChon(xBC: qlXBC, kPC: qlKPC);
              if(x){
                CustomAlert().success('Cập nhật thành công');
              }
            }),
          ],
        ),
      ),
    );
  }
}
