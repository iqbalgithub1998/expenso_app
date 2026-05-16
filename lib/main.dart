import 'package:expenso/bindings/general_binding.dart';
import 'package:expenso/repositories/auth_repository.dart';
import 'package:expenso/screens/auth/auth_screen.dart';
import 'package:expenso/screens/dashboard/dashboard_screen.dart';
import 'package:expenso/utils/theme/theme.dart';
import 'package:expenso/utils/supabase_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
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

  //* Initialize Supabase
  final supabaseResult = await initializeSupabase();

  if (!supabaseResult.success) {
    runApp(ErrorApp(errorMessage: supabaseResult.errorMessage));
    return;
  }

  Get.put(AuthRepository());

  //* Check if user is logged in
  final session = Supabase.instance.client.auth.currentSession;
  Widget homeScreen;
  if (session != null) {
    homeScreen = const DashboardScreen();
  } else {
    homeScreen = const AuthScreen();
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(MyApp(homeScreen: homeScreen));
  });
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  const MyApp({super.key, required this.homeScreen});

  //* This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) => GetMaterialApp(
        title: 'Expenso',
        // themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialBinding: GeneralBindings(),
        // getPages: AppPages.pages,
        home: homeScreen,
      ),
    );
    // home: const VideoListingScreen()),
  }
}

class ErrorApp extends StatelessWidget {
  final String? errorMessage;

  const ErrorApp({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connection Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unable to connect to the server.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.orange.shade50,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(color: Colors.orange.shade200),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         'Developer Info:',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.orange,
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         errorMessage ?? 'Unknown error',
                //         style: const TextStyle(
                //           fontSize: 12,
                //           fontFamily: 'monospace',
                //           color: Colors.black87,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
