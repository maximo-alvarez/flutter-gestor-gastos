
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/transaction_controller.dart';
import '../services/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/category.dart';
import '../models/transaction.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Gestor de Gastos', () {
    late CategoryController categoryController;
    late TransactionController transactionController;

    setUpAll(() async {
      Get.reset();
      final dbService = DbService();
      await dbService.init();
      Get.put<DbService>(dbService);
      categoryController = Get.put(CategoryController());
      transactionController = Get.put(TransactionController());
    });

    test('Crear categoría', () async {
      await categoryController.addCategory('TestCat');
      expect(categoryController.categories.any((c) => c.name == 'TestCat'), isTrue);
      print('Categoría creada correctamente');
    });

    test('Crear transacción', () async {
      await categoryController.addCategory('TestCat');
      final cat = categoryController.categories.firstWhere((c) => c.name == 'TestCat');
      await transactionController.addTransaction(
        description: 'TestTx',
        amount: 100.0,
        date: DateTime.now(),
        categoryId: cat.id,
        type: 'expense',
      );
      expect(transactionController.transactions.any((t) => t['description'] == 'TestTx'), isTrue);
      print('Transacción creada correctamente');
    });
  });
}
