import 'package:flowdo/common/constants/constants.dart';

enum ToastType { success, warning, error, info }

enum FilterOptions { all, complete, incomplete }

extension FilterOptionsExtension on FilterOptions {
  String get name {
    switch (this) {
      case FilterOptions.all:
        return "All";
      case FilterOptions.complete:
        return "Completed";
      case FilterOptions.incomplete:
        return "Incomplete";
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