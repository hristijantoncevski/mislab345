import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:mis3/main.dart';
import 'package:mis3/exam.dart';

class CalendarScreen extends StatelessWidget {
  final List<Exam> exams;

  const CalendarScreen({Key? key, required this.exams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: ExamCalendarDataSource(exams),
        monthViewSettings: const MonthViewSettings(showAgenda: true),
      ),
    );
  }
}

class ExamCalendarDataSource extends CalendarDataSource {
  final List<Exam> exams;

  ExamCalendarDataSource(this.exams);

  @override
  List<Appointment> get appointments => exams.map((exam) {
    final DateTime startTime = _parseDateTime('${exam.date} ${exam.time}');
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    return Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: exam.subject,
    );
  }).toList();

  DateTime _parseDateTime(String dateTimeString) {
    final List<String> parts = dateTimeString.split(' ');
    final List<String> dateParts = parts[0].split('-');
    final List<String> timeParts = parts[1].split(':');

    final int year = int.parse(dateParts[2]);
    final int month = int.parse(dateParts[1]);
    final int day = int.parse(dateParts[0]);
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    return DateTime(year, month, day, hour, minute);
  }
}
