import 'package:expenso/bindings/general_binding.dart';
import 'package:expenso/core/constants/colors.dart';
import 'package:expenso/repositories/auth_repository.dart';

import 'package:expenso/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );

  // WidgetsFlutterBinding.ensureInitialized();
  //* GetX local Storage
  await GetStorage.init();

  //*  preserve Splash until item Load...
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Get.put(AuthRepository());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //* This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) => GetMaterialApp(
        title: 'Editora AI',
        // themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialBinding: GeneralBindings(),
        // getPages: AppPages.pages,
        home: const Scaffold(
          backgroundColor: TColors.secondary,
          body: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
    );
    // home: const VideoListingScreen()),
  }
}
