import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  String message = "";
  bool checked = false;

  Future<void> login() async {
    final response = await http.post(
      Uri.parse("http://localhost/liu_app/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": idController.text,
        "password": passController.text,
      }),
    );

    final data = jsonDecode(response.body);

     if (data['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      setState(() {
       message = "Login failed: Invalid ID or Password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF174EAD),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/uni_logo.png", height: 80),
              const SizedBox(height: 15),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: "ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: (val) {
                      setState(() {
                        checked = val!;
                      });
                    },
                  ),
                  const Text("Remember Me"),
                ],
              ),
              Text(message, style: const TextStyle(color: Colors.red)),
              SizedBox(height: 13),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF174EAD),
                  foregroundColor: Colors.white,
                  minimumSize: Size(30, 50),
                ),
                child: const Text("LOGIN", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
