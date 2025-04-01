import 'package:flutter_platform_alert/flutter_platform_alert.dart';

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