// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flowdo/common/constants/enums.dart';
import 'package:flutter/material.dart';

class TodoModel {
  String content;
  bool isCompleted;
  Timestamp createdOn;
  Timestamp updatedOn;
  bool isFresh;
  TodoCategories categories;
  TodoModel({
    required this.content,
    required this.isCompleted,
    required this.createdOn,
    required this.updatedOn,
    required this.isFresh,
    required this.categories,
  });

  factory TodoModel.fromJson(Map<String, Object?> json) {
    TodoCategories? categories;
    try {
      // Handle explicit string values:
      if (json['categories'] is String) {
        categories = TodoCategories.values.firstWhereOrNull(
          (category) => category.name.toString() == json['categories'],
        );
      }
      // Handle implicit enum values
      else if (json['categories'] is TodoCategories) {
        categories = json['categories'] as TodoCategories;
      } else {
        categories = null;
      }
    } catch (error) {
      categories = null;
      debugPrint(error.toString());
    }
    return TodoModel(
      content: (json['content'] ?? "") as String,
      isCompleted: (json['isCompleted'] ?? false) as bool,
      createdOn: json['createdOn'] as Timestamp,
      updatedOn: json['updatedOn'] as Timestamp,
      isFresh: json['isFresh'] as bool,
      categories: categories ?? TodoCategories.general,
    );
  }

  TodoModel copyWith({
    String? content,
    bool? isCompleted,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    bool? isFresh,
    TodoCategories? categories,
  }) {
    return TodoModel(
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      isFresh: isFresh ?? this.isFresh,
      categories: categories ?? this.categories,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'isCompleted': isCompleted,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'isFresh': isFresh,
      'categories': categories.name,
    };
  }

  @override
  String toString() {
    return 'TodoModel(content: $content, isCompleted: $isCompleted, createdOn: $createdOn, updatedOn: $updatedOn, isFresh: $isFresh, categories: $categories)';
  }
}