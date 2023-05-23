import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/globals.dart';
import '../models/user_model.dart';
import '../screens/home_screen.dart';
import '../services/hive_service.dart';
import '../services/shared_preferences_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final HiveService hiveService = HiveService();
  final SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();

  bool correctPassword = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              "Login Form",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Username',
                  hintText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Password',
                  hintText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 146,
                  vertical: 16,
                ),
              ),
              onPressed: () {
                _login(context, _usernameController.text);
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 131,
                  vertical: 16,
                ),
              ),
              onPressed: () {
                _navigateToRegister(context);
              },
              child: Text(
                'Register',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, String text) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final User? user = await hiveService.getUser(username);

    if (user != null && user.password == password) {
      // Login berhasil
      await sharedPreferencesService.setLoggedIn(true);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Login Gagal',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Username atau password salah.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: background,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
}
