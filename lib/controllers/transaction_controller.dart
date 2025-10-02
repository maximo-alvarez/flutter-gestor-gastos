import 'package:get/get.dart';
import '../models/transaction.dart';
import '../services/db.dart';
import 'package:uuid/uuid.dart';
// Controlador para manejar las transacciones
class TransactionController extends GetxController {
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  final DbService dbService = Get.find<DbService>();

  Future<void> getTransactions() async {
    final rows = await dbService.db.rawQuery('''
      SELECT t.*, c.name as categoryName, c.colorCode as categoryColor
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      ORDER BY t.date DESC
    ''');
    transactions.value = rows;
  }

  Future<void> addTransaction({
    required String description,
    required double amount,
    required DateTime date,
    required String categoryId,
    required String type,
  }) async {
    final transaction = Transaction(
      id: const Uuid().v4(),
      description: description,
      amount: amount,
      date: date,
      categoryId: categoryId,
      type: type,
    );
    await dbService.db.insert('transactions', transaction.toMap());
    await getTransactions();
    Get.snackbar('Transacción', 'Transacción agregada correctamente');
  }

  Future<void> deleteTransaction(String id) async {
    await dbService.db.delete('transactions', where: 'id=?', whereArgs: [id]);
    await getTransactions();
    Get.snackbar('Transacción', 'Transacción eliminada');
  }
}
