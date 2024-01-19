import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis3/main.dart';
import 'package:mis3/exam.dart';

class AddExam extends StatefulWidget {
  final Function(Exam) onAdd;

  const AddExam({super.key, required this.onAdd});

  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  late TextEditingController subjectController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late String validate;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    validate = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(icon: Icon(Icons.text_fields), labelText: 'Subject'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(icon: Icon(Icons.calendar_today), labelText: 'Date'),
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                if(selectedDate == null) return;
                dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
              },
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(icon: Icon(Icons.access_time), labelText: 'Time'),
              readOnly: true,
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if(selectedTime != null){
                  String formattedTime = '${selectedTime.hour}:${selectedTime.minute}';
                  timeController.text = formattedTime;
                }
              },
            ),
            const SizedBox(height: 8),
            if(validate.isNotEmpty)
              Text(
                validate, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  widget.onAdd(
                    Exam(
                      subject: subjectController.text,
                      date: dateController.text,
                      time: timeController.text,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Exam'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (subjectController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty) {
      setState(() {
        validate = 'All fields are required.';
      });
      return false;
    } else {
      setState(() {
        validate = '';
      });
      return true;
    }
  }
}