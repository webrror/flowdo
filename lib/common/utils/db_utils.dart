import 'package:flowdo/domain/models/todo_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// IsarService provides methods to interface with Isar DB
class IsarService {
  /// Isar DB instance variable
  late Future<Isar> db;

  /// Constructor intialises instance
  IsarService() {
    db = getInstance();
  }

  /// Method to get instance of Isar DB
  ///
  /// If instance does not exist, creates one.
  Future<Isar> getInstance() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TodoModelSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  /// Method to save a TodoModel
  Future<void> saveTodo(TodoModel todo) async {
    final isarDb = await db;
    isarDb.writeTxnSync<int>(
      () => isarDb.todoModels.putSync(todo),
    );
  }

  /// Method to retrieve all saved TodoModels
  Future<List<TodoModel>> getTodos() async {
    final isarDb = await db;
    return await isarDb.todoModels.where().findAll();
  }

  /// Method to spit out todos immadiately
  Stream<List<TodoModel>> listenToTodos() async* {
    final isarDb = await db;
    yield* isarDb.todoModels.where().sortByCreatedOnDesc().watch(
          fireImmediately: true,
        );
  }

  /// Method to update a TodoModel
  Future<void> updateTodo(TodoModel updatedTodo) async {
    final isarDb = await db;
    await isarDb.writeTxn(() async {
      await isarDb.todoModels.put(updatedTodo);
    });
  }

  /// Method to toggle status of a TodoModel
  Future<void> toggleTodo(int id) async {
    final isarDb = await db;
    await isarDb.writeTxn(() async {
      final todo = await isarDb.todoModels.get(id);
      if (todo != null) {
        todo.isComplete = !todo.isComplete;
        await isarDb.todoModels.put(todo);
      }
    });
  }

  /// Method to delete a TodoModel
  Future<void> removeTodo(int id) async {
    final isarDb = await db;
    isarDb.writeTxnSync(() => isarDb.todoModels.deleteSync(id));
  }

  /// Method to clear all data in the db
  Future<void> cleanDb() async {
    final isarDb = await db;
    await isarDb.writeTxn(() => isarDb.clear());
  }
}