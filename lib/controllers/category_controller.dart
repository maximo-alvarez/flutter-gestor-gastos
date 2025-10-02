import 'package:get/get.dart';
import '../models/category.dart';
import '../services/db.dart';
import 'package:uuid/uuid.dart';

// Controlador para manejar las categorías
class CategoryController extends GetxController {
  final RxList<Category> categories = <Category>[].obs;
  final DbService dbService = Get.find<DbService>();

  Future<void> getCategories() async {
    final rows = await dbService.db.query('categories');
    categories.value = rows.map(Category.fromMap).toList();
  }

  Future<void> addCategory(String name) async {
    final category = Category(id: const Uuid().v4(), name: name);
    await dbService.db.insert('categories', category.toMap());
    await getCategories();
    Get.snackbar('Categoría', 'Categoría agregada correctamente');
  }

  Future<void> updateCategory(Category category) async {
    await dbService.db.update('categories', category.toMap(), where: 'id=?', whereArgs: [category.id]);
    await getCategories();
    Get.snackbar('Categoría', 'Categoría actualizada');
  }

  Future<void> deleteCategory(String id) async {
    await dbService.db.delete('categories', where: 'id=?', whereArgs: [id]);
    await getCategories();
    Get.snackbar('Categoría', 'Categoría eliminada');
  }
}
