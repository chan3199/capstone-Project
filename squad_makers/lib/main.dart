import 'package:firebase_core/firebase_core.dart';
import 'package:squad_makers/model/app_view_model.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_view/start_page.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() async {
  debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AppViewModel());
      }),
      theme: ThemeData(),
      home: startPage(),
    );
  }
}
