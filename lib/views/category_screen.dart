import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../models/category.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryController controller = Get.find<CategoryController>();
  final TextEditingController nameController = TextEditingController();

  CategoryScreen({super.key});

  void _showForm({Category? category}) {
    if (category != null) {
      nameController.text = category.name;
    } else {
      nameController.clear();
    }
    Get.defaultDialog(
      title: category == null ? 'Nueva Categoría' : 'Editar Categoría',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
        ],
      ),
      textConfirm: 'Guardar',
      textCancel: 'Cancelar',
      onConfirm: () async {
        final name = nameController.text.trim();
        if (name.isEmpty) return;
        if (category == null) {
          await controller.addCategory(name);
        } else {
          await controller.updateCategory(Category(id: category.id, name: name));
        }
        Get.back(closeOverlays: true);
        // Future.microtask(() => Get.offNamed('/categories'));
      },
      onCancel: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.getCategories();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offNamed('/'),
        ),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.categories.length,
        itemBuilder: (context, i) {
          final cat = controller.categories[i];
          return ListTile(
            title: Text(cat.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showForm(category: cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await controller.deleteCategory(cat.id);
                  },
                ),
              ],
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
