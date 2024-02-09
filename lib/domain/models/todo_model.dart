// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String content;
  bool isCompleted;
  Timestamp createdOn;
  Timestamp updatedOn;
  bool isFresh;
  TodoModel({
    required this.content,
    required this.isCompleted,
    required this.createdOn,
    required this.updatedOn,
    required this.isFresh,
  });

  TodoModel.fromJson(Map<String, Object?> json)
      : this(
          content: (json['content'] ?? "") as String,
          isCompleted: (json['isCompleted'] ?? false) as bool,
          createdOn: json['createdOn'] as Timestamp,
          updatedOn: json['updatedOn'] as Timestamp,
          isFresh: json['isFresh'] as bool,
        );

  TodoModel copyWith({
    String? content,
    bool? isCompleted,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    bool? isFresh,
  }) {
    return TodoModel(
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      isFresh: isFresh ?? this.isFresh,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'isCompleted': isCompleted,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'isFresh': isFresh,
    };
  }

  @override
  String toString() {
    return 'TodoModel(content: $content, isCompleted: $isCompleted, createdOn: $createdOn, updatedOn: $updatedOn, isFresh: $isFresh)';
  }
}