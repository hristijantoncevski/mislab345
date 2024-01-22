import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mis3/AddExam.dart';
import 'package:mis3/login.dart';
import 'package:mis3/exam.dart';
import 'package:mis3/notification.dart';
import 'package:mis3/register.dart';
import 'package:mis3/calendar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Login(),
      initialRoute: '/',
      routes: {
        '/': (context) => const ExamListScreen(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
      }
    );
  }
}

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  _ExamListScreenState createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  late final Notifications notifications;
  List<Exam> exams = [];

  @override
  void initState() {
    notifications = Notifications();
    notifications.initializeNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Dates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => FirebaseAuth.instance.currentUser != null ? _addExam(context)
             :  Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            )
          ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.currentUser != null ? {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarScreen(exams: exams))
              )
            } : Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            ),
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              print("Logged out");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            icon: const Icon(Icons.login_rounded)
          ),
        ],
      ),
      body: exams.isEmpty
          ? const Center (
        child: Text(
          'No exams',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove), color: Colors.red,
                      onPressed: () {
                        setState(() {
                          exams.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  exams[index].subject,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${exams[index].date}\n${exams[index].time}',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addExam(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: AddExam(
                onAdd: addNewExamToList,
              ),
            ),
          ),
        );
      },
    );
  }

  void addNewExamToList(Exam newExam){
    setState(() {
      exams.add(newExam);
    });

    notifications.show(id: newExam.id, title: "New exam", body: "A new exam for ${newExam.subject}, on date ${newExam.date} at ${newExam.time}");
    notifications.scheduleNotification(id: newExam.id, title: "Upcoming exam", body: "Your exam for ${newExam.subject} is in 1 hour. Good luck", date: newExam.date, time: newExam.time);
  }

}