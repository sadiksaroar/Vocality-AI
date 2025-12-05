// import 'package:flutter/material.dart';
// import 'package:vocality_ai/screen/splash_onboarding/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

/*
void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);
*/
/*
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocality_ai/screen/auth/forget_password.dart';
import 'package:vocality_ai/screen/auth/log_in.dart';
import 'package:vocality_ai/screen/auth/otp_verify.dart';
import 'package:vocality_ai/screen/auth/password_chnage.dart';
import 'package:vocality_ai/screen/auth/sign_in.dart';
import 'package:vocality_ai/screen/splash_onboarding/micrio_phone_acces.dart';
import 'package:vocality_ai/screen/splash_onboarding/splash_screen.dart';
import 'package:vocality_ai/screen/splash_onboarding/tap_to_start.dart';

// void main() {
//   runApp(const MyApp());
// }
void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
     
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OTPVerifyScreen(),
    );
  }
}
*/

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enable only in development mode
      builder: (context) => MyApp(), // Wrap the app in DevicePreview
    ),
  );
}
// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),

          routerConfig: AppPages.router,
        );
      },
    );
  }
}
