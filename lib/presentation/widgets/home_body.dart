import 'dart:math';
import 'package:animated_line_through/animated_line_through.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_firestore_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/domain/models/todo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FaIcon, FontAwesomeIcons;

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.service,
    required this.onEditTodo,
    required this.filterOption,
    required this.orderBy,
    required this.sortBy,
  });
  final FirebaseFirestoreMethods service;
  final Function(TodoModel, String) onEditTodo;
  final FilterOptions filterOption;
  final OrderBy orderBy;
  final SortBy sortBy;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  updateStatusOfTodo(String id, TodoModel todo) async {
    try {
      TodoModel todoUpdate = todo.copyWith(
        isCompleted: !todo.isCompleted,
        updatedOn: Timestamp.now(),
        isFresh: false,
      );
      await widget.service.updateTodo(id, todoUpdate).then((value) {
        showSuccessToast(context, Strings.taskUpdatedSuccessfully);
      });
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showErrorToast(context);
      }
    }
  }

  deleteTodo(String id) async {
    try {
      await widget.service.deleteTodo(id).then((value) {
        showSuccessToast(context, Strings.taskDeletedSuccessfully);
      });
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showErrorToast(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
        stream: widget.service.getAllTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                strokeCap: StrokeCap.round,
              ),
            );
          } else if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? true)) {
            return Center(
              child: Text(Strings.randomNoTodosMessages[Random().nextInt(Strings.randomNoTodosMessages.length)]),
            );
          } else {
            List todos = sortedAndFilteredList(
              inputList: snapshot.data?.docs ?? [],
              filterOption: widget.filterOption,
              sortBy: widget.sortBy,
              orderBy: widget.orderBy,
            );

            if (todos.isEmpty) {
              return Center(
                child: Text(
                  widget.filterOption == FilterOptions.complete ? Strings.noCompletedTodos : Strings.noPendingTodos,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(
                bottom: 90,
                top: kToolbarHeight + (kIsWeb ? 35 : 100),
              ),
              itemBuilder: (context, index) {
                TodoModel todo = todos[index].data();
                String todoId = todos[index].id;
                return Card(
                  color: Colors.transparent,
                  elevation: 0,
                  key: Key(todoId),
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Tooltip(
                          message: todo.isCompleted ? Strings.markAsIncomplete : Strings.markAsComplete,
                          child: Checkbox(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            value: todo.isCompleted,
                            onChanged: (val) {
                              updateStatusOfTodo(todoId, todo);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              updateStatusOfTodo(todoId, todo);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedLineThrough(
                                  isCrossed: todo.isCompleted,
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    todo.content,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                if (todo.isFresh) ...[
                                  Text(
                                    "${Strings.createdOn2} ${FLDateFormatter().customDateTime(
                                      inputString: "",
                                      inputDatetime: todo.createdOn.toDate(),
                                      outputFormat: DateTimeFormats.ddMMM,
                                    )} at ${FLDateFormatter().customDateTime(
                                      inputString: "",
                                      inputDatetime: todo.createdOn.toDate(),
                                      outputFormat: DateTimeFormats.hhmmaa,
                                    )}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ] else ...[
                                  Text(
                                    "${Strings.lastUpdatedOn} ${FLDateFormatter().customDateTime(
                                      inputString: "",
                                      inputDatetime: todo.updatedOn.toDate(),
                                      outputFormat: DateTimeFormats.ddMMM,
                                    )} at ${FLDateFormatter().customDateTime(
                                      inputString: "",
                                      inputDatetime: todo.updatedOn.toDate(),
                                      outputFormat: DateTimeFormats.hhmmaa,
                                    )}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              tooltip: Strings.editTask,
                              onPressed: () {
                                widget.onEditTodo(todo, todoId);
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.pencil,
                                size: 14,
                              ),
                            ),
                            IconButton(
                              tooltip: Strings.deleteTask,
                              onPressed: () {
                                deleteTodo(todoId);
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.trash,
                                size: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: todos.length,
            );
          }
        },
      ),
    );
  }
}

List<dynamic> sortedAndFilteredList({
  required List<dynamic> inputList,
  required FilterOptions filterOption,
  required SortBy sortBy,
  required OrderBy orderBy,
}) {
  List<dynamic> filteredList = inputList.where((element) {
    TodoModel todo = element.data();
    switch (filterOption) {
      case FilterOptions.all:
        return true;
      case FilterOptions.complete:
        return todo.isCompleted;
      case FilterOptions.incomplete:
        return !todo.isCompleted;
    }
  }).toList();

  filteredList.sort(
    (a, b) {
      TodoModel todoA = a.data();
      TodoModel todoB = b.data();

      switch (sortBy) {
        case SortBy.updatedOn:
          return orderBy == OrderBy.asc ? todoA.updatedOn.compareTo(todoB.updatedOn) : todoB.updatedOn.compareTo(todoA.updatedOn);

        case SortBy.createdOn:
          return orderBy == OrderBy.asc ? todoA.createdOn.compareTo(todoB.updatedOn) : todoB.updatedOn.compareTo(todoA.createdOn);
      }
    },
  );
  return filteredList;
}