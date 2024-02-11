import 'package:flowdo/common/constants/constants.dart';
import 'package:flutter/material.dart' show Color, Colors;

enum ToastType { success, warning, error, info }

enum FilterOptions { all, complete, incomplete, category }

extension FilterOptionsExtension on FilterOptions {
  String get name {
    switch (this) {
      case FilterOptions.all:
        return Strings.all;
      case FilterOptions.complete:
        return Strings.completed;
      case FilterOptions.incomplete:
        return Strings.incomplete;
      case FilterOptions.category:
        return Strings.category;
    }
  }
}

// Sort Options
enum SortBy { updatedOn, createdOn }

extension SortByExtension on SortBy {
  String get name {
    switch (this) {
      case SortBy.updatedOn:
        return Strings.updatedOn;
      case SortBy.createdOn:
        return Strings.createdOn;
    }
  }
}

enum OrderBy { asc, desc }

extension OrderExtension on OrderBy {
  String get name {
    switch (this) {
      case OrderBy.asc:
        return Strings.asc;
      case OrderBy.desc:
        return Strings.desc;
    }
  }

  String get longName {
    switch (this) {
      case OrderBy.asc:
        return Strings.ascL;
      case OrderBy.desc:
        return Strings.descL;
    }
  }
}

enum TodoCategories { general, important, personal, work }

extension TodoCategoryExtension on TodoCategories {
  (String, Color) get categoryProperties {
    switch (this) {
      case TodoCategories.personal:
        return (Strings.personal, Colors.blueAccent);
      case TodoCategories.work:
        return (Strings.work, Colors.green);
      case TodoCategories.important:
        return (Strings.important, Colors.redAccent);
      case TodoCategories.general:
        return (Strings.general, Colors.orangeAccent);
    }
  }
}

enum Corner { topLeft, topRight, bottomLeft, bottomRight }