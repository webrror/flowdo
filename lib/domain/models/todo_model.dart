import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@Collection()
@Name('TodoModel')
class TodoModel {
  // Isar Properties
  Id id = Isar.autoIncrement;

  // Data Properties
  late DateTime createdOn;
  late String title;
  late String content;
  bool isComplete = false;
}
