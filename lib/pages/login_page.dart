import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'playlist_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isPasswordVisible = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      final result = await authService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      if (result['success']) {
        final data = result['data'];
        print('User: ${data['firstName']} ${data['lastName']}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PlaylistPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${result['message']}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.7,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.25),
            child: Column(
              children: [
                Container(
                    child: Text(
                  "Hello Again!",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      fontWeight: FontWeight.bold),
                )),
                Container(
                  child: Text(
                    "Welcome back you've",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
                Container(
                  child: Text(
                    "been missed!",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                )
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.15,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Sudut melengkung
                    border: Border.all(color: Colors.grey), // Garis tepi
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: usernameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person_outlined),
                        label: Text("Username")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.15,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Sudut melengkung
                    border: Border.all(color: Colors.grey), // Garis tepi
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.password_outlined),
                      label: Text("Password"),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.1),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.14,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Warna tombol
                      foregroundColor: Colors.white, // Warna teks/spinner
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: login,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
