import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  List students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/liu_app/students.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "get"}),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          students = data["students"];
        });
      } else {
        setState(() {
          students = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load students")),
        );
      }
    } catch (e) {
      setState(() {
        students = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> deleteStudent(int index) async {
    final student = students[index];
    final id = student['id'].toString();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: const Text("Are you sure you want to delete this student?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final response = await http.post(
        Uri.parse("http://localhost/liu_app/students.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "delete", "id": id}),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          students.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Student deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete: ${data['message']}")),
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
        title: const Text("Students List"),
        backgroundColor: const Color(0xFF174EAD),
        foregroundColor: Colors.white,
      ),
     body: Column(
  children: [
    if (students.isEmpty)
      const Expanded(
        child: Center(
          child: Text("No students found"),
          ),),
    if (students.isNotEmpty)
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Column(
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                            "${student['first_name']} ${student['last_name']}"),
                        subtitle: Text("ID: ${student['student_id']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteStudent(index),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
    ),
  ],
),
    );
  }
}
