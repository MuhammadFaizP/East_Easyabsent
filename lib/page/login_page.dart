import 'package:absensi_flutter/page/admin_page.dart';
import 'package:absensi_flutter/page/user_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_page.dart';
import 'user_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  void showLoginError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-credential':
        errorMessage = 'Oops! Informasi login Anda salah atau sudah kedaluwarsa. Silahkan coba lagi.';
        break;
      case 'user-not-found':
        errorMessage = 'Tidak ada pengguna yang ditemukan untuk email tersebut. Silahkan periksa dan coba lagi.';
        break;
      case 'wrong-password':
        errorMessage = 'Kata sandi salah. Silahkan coba lagi.';
        break;
      default:
        errorMessage = 'Terjadi kesalahan, silahkan coba lagi nanti.';
    }

    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loginAdmin() async {
    const adminId = 'guru1';
    const adminPassword = 'guru123';

    if (_emailController.text == adminId && _passwordController.text == adminPassword) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Admin credentials')));
    }
  }

  Future<void> _loginUser() async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserPage()));
    } on FirebaseAuthException catch (e) {
      showLoginError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('East.', style: TextStyle(
          fontFamily: 'Mont', color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 27, 33, 107),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Color.fromARGB(255, 80, 80, 80),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 24,
                      color: Color.fromARGB(255, 153, 153, 153),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(fontFamily: 'Mont', color: Color.fromARGB(255, 186, 186, 186)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontFamily: 'Mont', color: Color.fromARGB(255, 186, 186, 186)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_emailController.text == 'guru1') {
                          _loginAdmin();
                        } else {
                          _loginUser();
                        }
                      }
                    },
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15), backgroundColor: Color.fromARGB(255, 0, 84, 152),
                      textStyle: const TextStyle(fontFamily: 'Mont', fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: const Text(
                      'Register as User',
                      style: TextStyle(fontFamily: 'Mont', color: Color.fromARGB(255, 188, 188, 188)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
