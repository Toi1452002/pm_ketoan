import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/views/views.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // Init ffi loader if needed.
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await GetStorage.init();

  WindowOptions windowOptions = const WindowOptions(
    // size: Size(850, 600),
    minimumSize: Size(850, 600),
    center: true,
    title: 'KETOAN',
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userInfoProvider);
    return ShadcnApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorSchemes.lightBlue(),

        typography: Typography.geist(base: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Arial'),medium: TextStyle(
          fontSize: 13,fontWeight: FontWeight.w500
        )),
        radius: .2,
        platform: TargetPlatform.windows,
      ),
      home: user != null ? HomeView() : LoginView(),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('vi', '')],
    );
  }
}
