import 'package:flutter/material.dart';
import 'package:proj2/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = 'buyer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: role,
              items:
                  ['buyer', 'artist']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
              onChanged: (val) => role = val!,
            ),
            ElevatedButton(
              child: Text('Register'),
              onPressed: () async {
                await AuthService().register(
                  emailController.text,
                  passwordController.text,
                  role,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
