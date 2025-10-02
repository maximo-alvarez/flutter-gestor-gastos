import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/category_controller.dart';
import 'controllers/transaction_controller.dart';
import 'views/category_screen.dart';
import 'views/transaction_screen.dart';
import 'views/home_screen.dart';

import 'controllers/lang_controller.dart';
import 'services/db.dart';
import 'utils/app_translation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() async => DbService().init());
  Get.put(LangController());
  Get.put(CategoryController());
  Get.put(TransactionController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Get.find<LangController>();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslation(),
        locale: lang.locale.value,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const HomeScreen()),
          GetPage(name: '/categories', page: () => CategoryScreen()),
          GetPage(name: '/transactions', page: () => TransactionScreen()),
        ],
      ),
    );
  }
}
