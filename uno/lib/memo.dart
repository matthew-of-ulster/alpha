import 'dart:convert';
import 'package:intl/intl.dart';

class Memo {
  final int? id;
  final String title;
  final String description;
  final DateTime? createdDate;
  final int? putOffCount;

  Memo({
    this.id,
    required this.title,
    required this.description,
    this.createdDate,
    this.putOffCount,
  });

  Map<String, dynamic> toMap() {
    int setId = id ?? 0;
    String setDate = '';

    if (createdDate == null) {
      String formatted =
          DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
      setDate = formatted;
    } else {
      setDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(createdDate!);
    }

    int setCount;
    if (putOffCount != null) {
      setCount = putOffCount! + 1;
    } else {
      setCount = 0;
    }

    return {
      'id': setId,
      'title': title,
      'description': description,
      'createdDate': setDate,
      'putOffCount': setCount,
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdDate: DateTime.now(),
      putOffCount: map['putOffCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Memo.fromJson(String source) => Memo.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Memo(id: $id, title: $title, description: $description, createdDate: $createdDate, putOffCount: $putOffCount)';
  }
}
