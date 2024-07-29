import 'dart:convert';
import 'package:intl/intl.dart';

class Memo {
  final int? id;
  final String title;
  final String description;
  final DateTime? createdDate;
  final DateTime? targetDate;
  final int? putOffCount;

  Memo({
    this.id,
    required this.title,
    required this.description,
    this.createdDate,
    this.targetDate,
    this.putOffCount,
  });

  Map<String, dynamic> toMap() {
    String setCreatedDate = '';
    String setTargetDate = '';

    if (createdDate == null) {
      String formatted =
          DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
      setCreatedDate = formatted;
    } else {
      setCreatedDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(createdDate!);
    }

    if (targetDate == null) {
      String formatted = DateFormat("yyyy-MM-dd hh:mm:ss")
          .format(DateTime.now().add(const Duration(hours: 1)));
      setTargetDate = formatted;
    } else {
      setTargetDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(targetDate!);
    }

    int setCount;
    if (putOffCount != null) {
      setCount = putOffCount! + 1;
    } else {
      setCount = 0;
    }

    return {
      'title': title,
      'description': description,
      'createdDate': setCreatedDate,
      'targetDate': setTargetDate,
      'putOffCount': setCount,
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    DateTime tempTargetDate;
    if (map['targetDate'] != null) {
      tempTargetDate = DateTime.parse(map['targetDate']);
    } else {
      tempTargetDate = DateTime.now().add(const Duration(hours: 1));
    }
    return Memo(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdDate: DateTime.parse(map['createdDate']),
      targetDate: tempTargetDate,
      putOffCount: map['putOffCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Memo.fromJson(String source) => Memo.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Memo(id: $id, title: $title, description: $description, createdDate: $createdDate,targetDate: $targetDate, putOffCount: $putOffCount)';
  }
}
