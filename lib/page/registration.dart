// ignore_for_file: unused_import, library_private_types_in_public_api, unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gqony/page/home.dart';
import 'package:gqony/page/login.dart';
import 'package:gqony/main.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String _kitchenName = '';

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you can call your registration function with _fullName, _email, _phoneNumber, _kitchenName
      // For example:
      // registerUser(_fullName, _email, _phoneNumber, _kitchenName);
    }
  }

  Void() {
    /*

    fill out authentication here..

    */

    //navigate to home page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MyHomePage(title: MyApp.appTitle)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const ValueKey('fullName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
                onSaved: (value) {
                  _fullName = value!;
                },
              ),
              TextFormField(
                key: const ValueKey('email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                key: const ValueKey('phoneNumber'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              TextFormField(
                key: const ValueKey('kitchenName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your kitchen name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Kitchen Name',
                ),
                onSaved: (value) {
                  _kitchenName = value!;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: const Text('Confirm'),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _trySubmit,
                child: const Text('Register'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _goToLoginPage,
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToLoginPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
