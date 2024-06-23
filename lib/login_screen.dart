// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todots/register_screen.dart';
import 'package:todots/config_url.dart';
import 'package:todots/home_screen.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? _errorMessage;
  bool _isCheckingLoginStatus = true;

  @override
  void initState() {
    super.initState();
    _loginStatus();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwtToken');
    if (jwtToken != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TodoListScreen(jwtToken: jwtToken)));
    } else {
      setState(() {
        _isCheckingLoginStatus = false;
      });
    }
  }

  Future<void> _loginUsingJwtToken() async {
    String url = '${Config.baseUrl}/login';
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        String jwtToken = jsonDecode(response.body)['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', jwtToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TodoListScreen(jwtToken: jwtToken)),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to login: ${response.statusCode}';
        });
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingLoginStatus) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'MEFN Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.email, color: Colors.blue[900]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue[900],
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 24),
              ],
              ElevatedButton(
                onPressed: _loginUsingJwtToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
