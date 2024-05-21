import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _countryCode = "+1";

  void _login() async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://hexeros.com/dev/fund-tool/api/V1/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'country_code': _countryCode,
        'mobile': phone,
        'password': password,
        'push_token': '',
        'device_type': 'android',
        'device_id': 'wdcxc323ec2cevrfes',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseBody['data']['token']);
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('Login failed: ${responseBody['message']}');
      }
    } else {
      print('Network error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login Screen')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  _countryCode = phone.countryCode;
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
