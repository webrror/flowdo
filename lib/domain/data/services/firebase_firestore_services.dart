// ignore_for_file: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowdo/domain/models/todo_model.dart';

const COLLECTION_REF = "main";
const TODOS_SUBCOLLECTION = "todos";

/// [FirebaseFirestoreMethods] class consists of properties and methods related to Firebase Firestore
class FirebaseFirestoreMethods {
  /// Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection reference
  late CollectionReference userTodosCollectionReference;

  /// Current user's id
  late String? userId;

  // Constructor
  FirebaseFirestoreMethods() {
    initUserCollection();
  }

  /// Method to init `userTodosCollectionReference` and `userId`
  Future<void> initUserCollection() async {
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    userTodosCollectionReference = _firestore.collection(COLLECTION_REF).doc(userId).collection(TODOS_SUBCOLLECTION).withConverter<TodoModel>(
          fromFirestore: (snapshot, options) => TodoModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  /// Method to get stream of all todos
  Stream<QuerySnapshot> getAllTodos() {
    return userTodosCollectionReference.snapshots();
  }

  /// Method to add a todo
  ///
  /// Pass a [TodoModel] to `todo` param
  Future<void> addTodo(TodoModel todo) async {
    await userTodosCollectionReference.add(todo);
  }

  /// Method to update a todo
  ///
  /// Pass id of the todo to be updated to `id` param and **UPDATED** [TodoModel] to `todo` param
  Future<void> updateTodo(String id, TodoModel todo) async {
    await userTodosCollectionReference.doc(id).update(todo.toJson());
  }

  /// Method to delete a todo
  ///
  /// Pass id of the todo to be deleted to `id` param
  Future<void> deleteTodo(String id) async {
    await userTodosCollectionReference.doc(id).delete();
  }

  /// Method to create a document with `id` same as `user.userId`
  void createDocument() async {
    QuerySnapshot snapshot = await _firestore.collection(COLLECTION_REF).get();
    if (!snapshot.docs.any((element) => element.id == userId)) {
      if (userId != null) {
        _firestore.collection(COLLECTION_REF).doc(userId).set({});
      }
    }
  }

  /// Method to delete a document with `id` same as `user.userId`
  void deleteDocument() async {
    await _firestore.collection(COLLECTION_REF).doc(userId).delete();
  }
}