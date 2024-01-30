import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis3/location.dart';
import 'package:mis3/main.dart';
import 'package:mis3/exam.dart';
import 'package:mis3/map.dart';

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
  late double newLatitude;
  late double newLongitude;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    validate = '';
    newLatitude = 0.0;
    newLongitude = 0.0;
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
                  String formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                  timeController.text = formattedTime;
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen(exams: const [], allowAddMarkers: true,
                      onLocationSelected: (double latitude, double longitude) {
                        setState(() {
                          newLatitude = latitude;
                          newLongitude = longitude;
                        });
                      },
                    ),
                  ),
                );

                if(selectedLocation != null) {
                  newLatitude = selectedLocation['latitude'];
                  newLongitude = selectedLocation['longitude'];
                }
              },
              child: const Text('Select Location'),
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
                      location: Location(latitude: newLatitude, longitude: newLongitude)
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