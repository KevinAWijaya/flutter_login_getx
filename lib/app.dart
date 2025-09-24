import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/color.dart';
import 'core/routes/app_pages.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: VColor.surface, textTheme: GoogleFonts.montserratTextTheme()),
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
