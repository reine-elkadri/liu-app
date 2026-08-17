import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List students = [];
  Map<int, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final response = await http.post(
      Uri.parse("http://localhost/liu_app/students.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"action": "get"}),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      List list = data["students"];
      setState(() {
        students = list;
        attendance.clear();
        for (int i = 0; i < list.length; i++) {
          int id = int.parse(list[i]["id"].toString());
          attendance[id] = false;
        }
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load students")));
    }
  }

  Future<void> saveAttendance() async {
    Map<String, bool> sendData = {};
    attendance.forEach((key, value) {
      sendData[key.toString()] = value;
    });

    final response = await http.post(
      Uri.parse("http://localhost/liu_app/attendance.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"attendance": sendData}),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Attendance saved")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save attendance")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
        backgroundColor: const Color(0xFF174EAD),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (students.isEmpty)
            const Expanded(
              child: Center(
                child: Text("No students found"),
              ),
            ),
          if (students.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  Map student = students[index];
                  int id = int.parse(student["id"].toString());

                  return Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CheckboxListTile(
                      title: Text("${student["first_name"]} ${student["last_name"]}"),
                      value: attendance[id],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            attendance[id] = val;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child:SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: saveAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF174EAD),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Save Attendance",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
