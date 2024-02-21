import 'dart:math';
import 'package:animated_line_through/animated_line_through.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_firestore_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/domain/models/todo_model.dart';
import 'package:flowdo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FaIcon, FontAwesomeIcons;

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.service,
    required this.onEditTodo,
    required this.filterOption,
    required this.orderBy,
    required this.sortBy,
    this.category,
  });
  final FirebaseFirestoreMethods service;
  final Function(TodoModel, String) onEditTodo;
  final FilterOptions filterOption;
  final OrderBy orderBy;
  final SortBy sortBy;
  final TodoCategories? category;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  /// Mark complete/incomplete a todo handler
  updateStatusOfTodo(String id, TodoModel todo) async {
    TodoModel todoUpdate = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedOn: Timestamp.now(),
      isFresh: false,
    );
    await widget.service.updateTodo(id, todoUpdate).then((value) {
      showSuccessToast(context, Strings.taskUpdatedSuccessfully);
    });
  }

  /// Delete handler
  deleteTodo(String id) async {
    await widget.service.deleteTodo(id).then((value) {
      showSuccessToast(context, Strings.taskDeletedSuccessfully);
    });
  }

  /// Random index used to show random String from `randomNoTodosMessages` array/list
  int randomIndex = Random().nextInt(Strings.randomNoTodosMessages.length);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.service.getAllTodos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          );
        } else if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? true)) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                Strings.randomNoTodosMessages[randomIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          );
        } else {
          List todos = sortedAndFilteredList(
            inputList: snapshot.data?.docs ?? [],
            filterOption: widget.filterOption,
            sortBy: widget.sortBy,
            orderBy: widget.orderBy,
            category: widget.category,
          );

          if (todos.isEmpty) {
            return const Center(
              child: Text(
                Strings.noTodos,
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return MasonryGridView.builder(
                primary: true,
                padding: const EdgeInsets.symmetric(horizontal: 13).copyWith(
                  bottom: 120,
                  top: 5,
                ),
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: max(1, min(3, (constraints.maxWidth / 330).floor())),
                ),
                itemCount: todos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  TodoModel todo = todos[index].data();
                  String todoId = todos[index].id;
                  return Card(
                    color: Colors.transparent,
                    elevation: 0,
                    key: Key(todoId),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: getBorderColor(context),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CustomPaint(
                              painter: CornerTrianglePainter(
                                corner: Corner.topLeft,
                                color: todo.categories.categoryProperties.$2.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8).copyWith(
                            top: 12,
                            bottom: 0,
                            left: 0.1,
                            right: 0.1,
                          ),
                          // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          // child: Row(
                          //   children: [
                          //     Tooltip(
                          //       message: todo.isCompleted ? Strings.markAsIncomplete : Strings.markAsComplete,
                          //       child: Transform.scale(
                          //         scale: 0.9,
                          //         child: Checkbox(
                          //           shape: const CircleBorder(),
                          //           value: todo.isCompleted,
                          //           onChanged: (val) {
                          //             updateStatusOfTodo(todoId, todo);
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 7,
                          //     ),
                          //     Expanded(
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           updateStatusOfTodo(todoId, todo);
                          //         },
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             AnimatedLineThrough(
                          //               isCrossed: todo.isCompleted,
                          //               duration: const Duration(milliseconds: 200),
                          //               child: Text(
                          //                 todo.content,
                          //                 style: const TextStyle(
                          //                   fontWeight: FontWeight.normal,
                          //                 ),
                          //               ),
                          //             ),
                          //             const SizedBox(
                          //               height: 3,
                          //             ),
                          //             Row(
                          //               children: [
                          //                 CircleAvatar(
                          //                   radius: 4,
                          //                   backgroundColor: todo.categories.categoryProperties.$2,
                          //                 ),
                          //                 const SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 if (todo.isFresh) ...[
                          //                   Expanded(
                          //                     child: Text(
                          //                       "${Strings.createdOn2} ${FLDateFormatter().customDateTime(
                          //                         inputString: "",
                          //                         inputDatetime: todo.createdOn.toDate(),
                          //                         outputFormat: DateTimeFormats.ddMMM,
                          //                       )} at ${FLDateFormatter().customDateTime(
                          //                         inputString: "",
                          //                         inputDatetime: todo.createdOn.toDate(),
                          //                         outputFormat: DateTimeFormats.hhmmaa,
                          //                       )}",
                          //                       style: const TextStyle(fontSize: 11),
                          //                     ),
                          //                   ),
                          //                 ] else ...[
                          //                   Expanded(
                          //                     child: Text(
                          //                       "${Strings.lastUpdatedOn} ${FLDateFormatter().customDateTime(
                          //                         inputString: "",
                          //                         inputDatetime: todo.updatedOn.toDate(),
                          //                         outputFormat: DateTimeFormats.ddMMM,
                          //                       )} at ${FLDateFormatter().customDateTime(
                          //                         inputString: "",
                          //                         inputDatetime: todo.updatedOn.toDate(),
                          //                         outputFormat: DateTimeFormats.hhmmaa,
                          //                       )}",
                          //                       style: const TextStyle(fontSize: 11),
                          //                     ),
                          //                   ),
                          //                 ]
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 7,
                          //     ),
                          //     Row(
                          //       children: [
                          //         IconButton(
                          //           tooltip: Strings.editTask,
                          //           onPressed: () {
                          //             widget.onEditTodo(todo, todoId);
                          //           },
                          //           icon: const FaIcon(
                          //             FontAwesomeIcons.pen,
                          //             size: 14,
                          //           ),
                          //         ),
                          //         IconButton(
                          //           tooltip: Strings.deleteTask,
                          //           onPressed: () {
                          //             deleteTodo(todoId);
                          //           },
                          //           icon: const FaIcon(
                          //             FontAwesomeIcons.trash,
                          //             size: 14,
                          //           ),
                          //         ),
                          //       ],
                          //     )
                          //   ],
                          // ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  try {
                                    updateStatusOfTodo(todoId, todo);
                                  } catch (e) {
                                    debugPrint(e.toString());
                                    showErrorToast(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: AnimatedLineThrough(
                                    isCrossed: todo.isCompleted,
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      todo.content,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5).copyWith(right: 0),
                                decoration: const BoxDecoration(
                                  // color: todo.categories.categoryProperties.$2.withOpacity(0.15),
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    topRight: Radius.circular(2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Tooltip(
                                      message: todo.isCompleted ? Strings.markAsIncomplete : Strings.markAsComplete,
                                      child: Transform.scale(
                                        scale: 0.9,
                                        child: Checkbox(
                                          shape: const CircleBorder(),
                                          value: todo.isCompleted,
                                          onChanged: (val) {
                                            try {
                                              updateStatusOfTodo(todoId, todo);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              showErrorToast(context);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    ...[
                                      if (todo.isFresh) ...[
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Strings.createdOn2} ${FLDateFormatter().customDateTime(
                                                inputString: "",
                                                inputDatetime: todo.createdOn.toDate(),
                                                outputFormat: DateTimeFormats.ddMMM,
                                              )} at ${FLDateFormatter().customDateTime(
                                                inputString: "",
                                                inputDatetime: todo.createdOn.toDate(),
                                                outputFormat: DateTimeFormats.hhmmaa,
                                              )}",
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Strings.lastUpdatedOn} ${FLDateFormatter().customDateTime(
                                                inputString: "",
                                                inputDatetime: todo.updatedOn.toDate(),
                                                outputFormat: DateTimeFormats.ddMMM,
                                              )} at ${FLDateFormatter().customDateTime(
                                                inputString: "",
                                                inputDatetime: todo.updatedOn.toDate(),
                                                outputFormat: DateTimeFormats.hhmmaa,
                                              )}",
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                    ...[
                                      IconButton(
                                        tooltip: Strings.editTask,
                                        onPressed: () {
                                          widget.onEditTodo(todo, todoId);
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.pen,
                                          size: 14,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: Strings.deleteTask,
                                        onPressed: () {
                                          try {
                                            deleteTodo(todoId);
                                          } catch (e) {
                                            debugPrint(e.toString());
                                            showErrorToast(context);
                                          }
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.trash,
                                          size: 14,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

List<dynamic> sortedAndFilteredList({
  required List<dynamic> inputList,
  required FilterOptions filterOption,
  required SortBy sortBy,
  required OrderBy orderBy,
  TodoCategories? category,
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
      case FilterOptions.category:
        switch (category) {
          case TodoCategories.personal:
            return todo.categories == TodoCategories.personal;
          case TodoCategories.work:
            return todo.categories == TodoCategories.work;
          case TodoCategories.important:
            return todo.categories == TodoCategories.important;
          case TodoCategories.general:
            return todo.categories == TodoCategories.general;
          default:
            return todo.categories == TodoCategories.general;
        }
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
          return orderBy == OrderBy.asc ? todoA.createdOn.compareTo(todoB.createdOn) : todoB.createdOn.compareTo(todoA.createdOn);
      }
    },
  );
  return filteredList;
}