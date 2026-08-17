import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  Future<void> addStudent() async {
    if (firstController.text.isEmpty || lastController.text.isEmpty || idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://localhost/liu_app/students.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "add",
          "first_name": firstController.text,
          "last_name": lastController.text,
          "student_id": idController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student added successfully")),
      );
        firstController.clear();
        lastController.clear();
        idController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add student:")),
      );
      }
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF174EAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstController,
              decoration: InputDecoration(
                hintText: "First Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lastController,
              decoration: InputDecoration(
                hintText: "Last Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: "Student ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF174EAD),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Add Student",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
