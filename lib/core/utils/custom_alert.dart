import 'package:app_ketoan/core/core.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CustomAlert{
  Future<AlertButton> error(String text, {String title = 'Error'}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: title,
      text: text,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.error,
    );
  }

  Future<AlertButton> success(String text, {String title = 'Success'}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: 'Success',
      text: text,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.none,
    );
  }

  Future<AlertButton> warning(String text, {String title = 'Warning'}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: title,
      text: text,
      alertStyle: AlertButtonStyle.okCancel,
      iconStyle: IconStyle.warning,
    );
  }
}

void showDeleteSuccess(BuildContext context) async{
  showToast(context: context, builder: (context, overlay){
    return SurfaceCard(
      fillColor: Colors.green,
      filled: true,
      // borderColor: Colors.green,

      child: Basic(

        mainAxisAlignment: MainAxisAlignment.center,
        leading: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),color: Colors.white,),
        title: const Text('Xóa thành công',style: TextStyle(color: Colors.white),),
        trailingAlignment: Alignment.center,

        // content: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),color: Colors.white,),
        leadingAlignment: Alignment.center,
        trailing: IconButton.ghost(icon: Icon(Icons.close,color: Colors.white,), onPressed: () {
          overlay.close();
        }, size: ButtonSize.small),
      ),
    );
  }, location: ToastLocation.topRight);

}