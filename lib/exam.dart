import 'package:flutter/material.dart';

class Exam {
  static int idCounter = 1;
  int id;
  String subject;
  String date;
  String time;

  Exam({int? id, required this.subject, required this.date, required this.time}) : id = idCounter++;
}