import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_auth_services.dart';
import 'package:flowdo/domain/data/services/firebase_firestore_services.dart';
import 'package:flowdo/domain/data/services/theme_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/domain/models/todo_model.dart';
import 'package:flowdo/presentation/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

final _formKey = GlobalKey<FormState>();

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController _settingsIconAnimationController;
  late TextEditingController _contentController;
  final service = FirebaseFirestoreMethods();
  // Filter
  FilterOptions selectedFilter = FilterOptions.all;
  TodoCategories? selectedCategoryForFilter;
  // Sort
  OrderBy sortOrder = OrderBy.desc;
  SortBy sortBy = SortBy.createdOn;
  // Category
  TodoCategories selectedCategory = TodoCategories.general;
  Future<void>? _bottomSheetFuture;

  @override
  void initState() {
    _contentController = TextEditingController();
    _settingsIconAnimationController = AnimationController(
      vsync: this,
      duration: 500.ms,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      const QuickActions quickActions = QuickActions();
      quickActions.initialize((type) {
        switch (type) {
          case 'action_add':
            showAddSheet();
            break;
          default:
            break;
        }
      });

      quickActions.setShortcutItems(quickActionShortcuts);
    });
    super.initState();
  }

  @override
  void dispose() {
    _settingsIconAnimationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Create handler
  createNewTodo() async {
    TodoModel todo = TodoModel(
      content: _contentController.text,
      isCompleted: false,
      createdOn: Timestamp.now(),
      updatedOn: Timestamp.now(),
      isFresh: true,
      categories: selectedCategory,
    );

    await service.addTodo(todo).then((value) {
      Navigator.pop(context);
      _contentController.clear();
      showSuccessToast(context, Strings.taskAddedSuccessfully);
    });
  }

  /// Update handler
  updateTodo(String id, TodoModel todo) async {
    TodoModel todoUpdate = todo.copyWith(
      content: _contentController.text.trim(),
      updatedOn: Timestamp.now(),
      isFresh: false,
      categories: selectedCategory,
    );
    await service.updateTodo(id, todoUpdate).then((value) {
      Navigator.pop(context);
      _contentController.clear();
      showSuccessToast(context, Strings.taskUpdatedSuccessfully);
    });
  }

  OutlineInputBorder buildBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide.none,
    );
  }

  /// Create/Update bottom sheet
  void showAddSheet({TodoModel? todoForUpdate, String? id}) {
    bool isEdit = todoForUpdate != null;
    _bottomSheetFuture ??= showGlassBottomSheet(
      context,
      sheetTitle: isEdit ? Strings.updateYourTask : Strings.addATask,
      maxHeight: getScreenHeight(context) * 0.5,
      isDismissible: true,
      buildSheet: [
        Flexible(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ).copyWith(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
                        validator: (value) {
                          if ((value?.trim().isEmpty ?? true)) {
                            return Strings.enterSomething;
                          }
                          return null;
                        },
                        controller: _contentController,
                        autofocus: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 12,
                          ),
                          enabledBorder: buildBorder(),
                          focusedBorder: buildBorder(),
                          errorBorder: buildBorder(),
                          focusedErrorBorder: buildBorder(),
                          hintText: Strings.hintText,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 15, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StatefulBuilder(builder: (context, set) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                            child: PopupMenuButton(
                              tooltip: Strings.category,
                              offset: const Offset(0, 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              position: PopupMenuPosition.under,
                              child: FLButton(
                                onTap: null,
                                horizontalPadding: 10,
                                verticalPadding: 5,
                                content: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 4,
                                      backgroundColor: selectedCategory.categoryProperties.$2,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      selectedCategory.categoryProperties.$1,
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              itemBuilder: (context) {
                                return TodoCategories.values.map((e) {
                                  return PopupMenuItem(
                                    onTap: () {
                                      set(() {
                                        selectedCategory = e;
                                      });
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 4,
                                            backgroundColor: e.categoryProperties.$2,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            e.categoryProperties.$1,
                                            style: const TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          );
                        }),
                        FLButton(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              try {
                                if (isEdit) {
                                  if (id != null) {
                                    updateTodo(id, todoForUpdate);
                                  } else {
                                    return;
                                  }
                                } else {
                                  createNewTodo();
                                }
                                _bottomSheetFuture = null;
                              } catch (e) {
                                debugPrint(e.toString());
                                showErrorToast(context);
                              }
                            }
                          },
                          content: Text(isEdit ? Strings.update : Strings.add),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ).then(
      (value) => setState(
        () {
          _bottomSheetFuture = value;
        },
      ),
    );
  }

  /// Preferences bottom sheet
  void showSettingsSheet(User user) {
    showGlassBottomSheet(
      context,
      maxHeight: getScreenHeight(context) * (kIsWeb ? 0.56 : 0.51),
      sheetTitle: Strings.settings,
      buildSheet: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                Strings.theme,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Consumer<ThemeServices>(
                builder: (context, value, child) {
                  return SizedBox(
                    width: getScreenWidth(context),
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text(Strings.darkTheme),
                          icon: Icon(Icons.dark_mode),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text(Strings.lightTheme),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text(Strings.deviceTheme),
                          icon: Icon(Icons.phone_android),
                        )
                      ],
                      selected: {value.currentTheme},
                      onSelectionChanged: (themeOption) async {
                        try {
                          value.toggleTheme(themeOption.first);
                        } catch (e) {
                          debugPrint(e.toString());
                          showErrorToast(context);
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                Strings.account,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (user.isAnonymous) ...[
                Text(
                  "${Strings.guestUser} (${user.uid})",
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ] else ...[
                Text(
                  "${user.displayName?.trim()} (${user.email})",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
              const SizedBox(
                height: 15,
              ),
              const Text(
                Strings.appInfo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                AppInfo.appVersion,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Text(
                "${AppInfo.appName} (${kIsWeb ? "Web" : Platform.operatingSystem})",
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              Text(
                AppInfo.builtWithFlutter,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              const Text(
                "by ${AppInfo.madeBy}",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FLButton(
                    onTap: () {
                      Navigator.pop(context);
                      showAccDeleteSheet();
                    },
                    content: Text(
                      Strings.deleteAccount,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    bgColor: Colors.red.withOpacity(0.1),
                    borderColor: Colors.redAccent.withOpacity(0.2),
                  ),
                  FLButton(
                    onTap: () {
                      context.read<FirebaseAuthMethods>().signOut(context);
                      Navigator.pop(context);
                    },
                    content: const Text(Strings.signOut),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Acc. deletion bottom sheet
  void showAccDeleteSheet() {
    showGlassBottomSheet(
      context,
      sheetTitle: Strings.areYouSureWantToDelete,
      maxHeight: getScreenHeight(context) * 0.38,
      minHeight: getScreenHeight(context) * 0.38,
      buildSheet: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  Strings.permanentAction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FLButton(
                  onTap: () async {
                    await context.read<FirebaseAuthMethods>().deleteAccount(context).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  content: Text(
                    Strings.deleteAccount,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  bgColor: Colors.red.withOpacity(0.1),
                  borderColor: Colors.redAccent.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Sort options bottom sheet
  void showSortSheet() async {
    bool? reload = await showGlassBottomSheet<bool>(
      context,
      customChild: StatefulBuilder(
        builder: (context, set) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: getScreenHeight(context) * 0.34,
              minHeight: getScreenHeight(context) * 0.34,
            ),
            width: getScreenWidth(context),
            color: getSurfaceColor(context),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Strings.sortBy,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SortBy.values.map((e) {
                    return ChoiceChip(
                      elevation: 1,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      label: Text(
                        e.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                      selected: sortBy == e,
                      onSelected: (value) {
                        set(() {
                          sortBy = e;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  Strings.order,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: OrderBy.values.map((e) {
                    return ChoiceChip(
                      elevation: 1,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      label: Text(
                        e.longName,
                        style: const TextStyle(fontSize: 12),
                      ),
                      selected: sortOrder == e,
                      onSelected: (value) {
                        set(() {
                          sortOrder = e;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FLButton(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    content: const Text(Strings.done),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
    if (reload != null && reload) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      body: Stack(
        children: [
          const BlobBackground(),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0, tileMode: TileMode.clamp),
              child: Container(
                height: getScreenHeight(context),
                width: getScreenWidth(context),
                color: getAppBlurColor(context),
              ),
            ),
          ),
          CustomScrollView(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                backgroundColor: Colors.white10,
                forceMaterialTransparency: true,
                title: const Text(
                  AppInfo.appName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: false,
                actions: [
                  Tooltip(
                    message: Strings.preferences,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        showSettingsSheet(user);
                        _settingsIconAnimationController.forward(from: 0);
                      },
                      onLongPress: () {
                        _settingsIconAnimationController.forward(from: 0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: const FaIcon(
                          FontAwesomeIcons.gear,
                          size: 18,
                        )
                            .animate(
                              controller: _settingsIconAnimationController,
                              onPlay: (controller) => controller.stop(),
                            )
                            .rotate(duration: 500.ms),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          child: PopupMenuButton(
                            tooltip: Strings.filter,
                            position: PopupMenuPosition.under,
                            offset: const Offset(0, 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: FLButton(
                              verticalPadding: 3,
                              horizontalPadding: 14,
                              onTap: null,
                              content: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: FaIcon(
                                      FontAwesomeIcons.filter,
                                      size: 11,
                                    ),
                                  ),
                                  if (selectedFilter != FilterOptions.category) ...[
                                    Text(selectedFilter.name)
                                  ] else if (selectedCategoryForFilter != null && selectedFilter == FilterOptions.category) ...[
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: selectedCategoryForFilter!.categoryProperties.$2,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(selectedCategoryForFilter!.categoryProperties.$1)
                                      ],
                                    )
                                  ],
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: FaIcon(
                                      FontAwesomeIcons.chevronDown,
                                      size: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) {
                              List<PopupMenuItem> filterOptions = FilterOptions.values.where((e) => e != FilterOptions.category).map(
                                (e) {
                                  return PopupMenuItem(
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = e;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(e.name),
                                    ),
                                  );
                                },
                              ).toList();

                              List<PopupMenuItem> categories = TodoCategories.values.map((e) {
                                return PopupMenuItem(
                                  onTap: () {
                                    setState(() {
                                      selectedFilter = FilterOptions.category;
                                      selectedCategoryForFilter = e;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: e.categoryProperties.$2,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(e.categoryProperties.$1),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList();
                              return filterOptions + categories;
                            },
                          ),
                        ),
                        FLButton(
                          tooltip: Strings.sort,
                          verticalPadding: 3,
                          horizontalPadding: 14,
                          onTap: () {
                            showSortSheet();
                          },
                          content: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: FaIcon(
                                  FontAwesomeIcons.sort,
                                  size: 12,
                                ),
                              ),
                              Text("${sortBy.name} - ${sortOrder.name}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: HomeBody(
                  service: service,
                  onEditTodo: (todo, id) {
                    _contentController.text = todo.content;
                    selectedCategory = todo.categories;
                    showAddSheet(todoForUpdate: todo, id: id);
                  },
                  filterOption: selectedFilter,
                  sortBy: sortBy,
                  orderBy: sortOrder,
                  category: selectedCategoryForFilter,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        tooltip: Strings.addNewTask,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        onPressed: () {
          _contentController.clear();
          showAddSheet();
        },
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0, tileMode: TileMode.clamp),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}