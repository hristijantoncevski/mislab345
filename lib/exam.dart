import 'package:flutter/material.dart';
import 'package:mis3/location.dart';

class Exam {
  static int idCounter = 1;
  int id;
  String subject;
  String date;
  String time;
  Location location;

  Exam({int? id, required this.subject, required this.date, required this.time, required this.location}) : id = idCounter++;
}