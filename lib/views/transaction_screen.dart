import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/category_controller.dart';

class TransactionScreen extends StatelessWidget {
  final TransactionController transactionController = Get.find<TransactionController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  TransactionScreen({super.key});

  void _showForm(BuildContext context) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    String? selectedCategoryId;
    String type = 'expense';

    Get.defaultDialog(
      title: 'Nueva Transacción',
      content: Column(
        children: [
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Monto'),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            initialValue: selectedCategoryId,
            items: categoryController.categories.map((cat) => DropdownMenuItem(
              value: cat.id,
              child: Text(cat.name),
            )).toList(),
            onChanged: (val) => selectedCategoryId = val,
            decoration: const InputDecoration(labelText: 'Categoría'),
          ),
          DropdownButtonFormField<String>(
            initialValue: type,
            items: const [
              DropdownMenuItem(value: 'income', child: Text('Ingreso')),
              DropdownMenuItem(value: 'expense', child: Text('Gasto')),
            ],
            onChanged: (val) => type = val ?? 'expense',
            decoration: const InputDecoration(labelText: 'Tipo'),
          ),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                dateController.text = picked.toIso8601String().substring(0, 10);
              }
            },
          ),
        ],
      ),
      textConfirm: 'Guardar',
      textCancel: 'Cancelar',
      onConfirm: () async {
        final desc = descController.text.trim();
        final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
        final date = DateTime.tryParse(dateController.text.trim()) ?? DateTime.now();
        if (desc.isEmpty || selectedCategoryId == null) return;
        await transactionController.addTransaction(
          description: desc,
          amount: amount,
          date: date,
          categoryId: selectedCategoryId!,
          type: type,
        );
        if (Get.isDialogOpen ?? false) Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    transactionController.getTransactions();
    categoryController.getCategories();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offNamed('/'),
        ),
      ),
      body: Obx(() => ListView.builder(
        itemCount: transactionController.transactions.length,
        itemBuilder: (context, i) {
          final tx = transactionController.transactions[i];
          return ListTile(
            leading: tx['categoryColor'] != null ? CircleAvatar(backgroundColor: Color(tx['categoryColor'])) : null,
            title: Text(tx['description']),
            subtitle: Text('${tx['categoryName']} • ${tx['date'].toString().substring(0, 10)}'),
            trailing: Text(
              (tx['type'] == 'income' ? '+' : '-') + tx['amount'].toString(),
              style: TextStyle(
                color: tx['type'] == 'income' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onLongPress: () async {
              await transactionController.deleteTransaction(tx['id']);
            },
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
