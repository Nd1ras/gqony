// ignore_for_file: unused_import, library_private_types_in_public_api, unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:gqony/page/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _usernameOrEmail = 'admin';
  String _password = '123456';

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed('/home', arguments: [
        _usernameOrEmail,
        _password,
      ]) as dynamic;
    }
  }

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you can call your login function with _username and _password
      // For example:
      // loginUser(_username, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 25),

                //message,app slogan
                Text(
                  "gqony Food Delivery App",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const SizedBox(height: 25),

                TextFormField(
                  key: const ValueKey('username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username or Email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Username Or Email',
                  ),
                  onSaved: (value) {
                    _usernameOrEmail = value!;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: _trySubmit,
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text('Create a new account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
