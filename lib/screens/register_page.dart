import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../globals.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/shared_preferences_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final HiveService hiveService = HiveService();
  final SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Text(
              "Register Form",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold, // Ubah teks menjadi tebal
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
                  hintText: '', // Ubah hint menjadi string kosong
                  floatingLabelBehavior: FloatingLabelBehavior
                      .never, // Menghilangkan label saat ditekan
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
                  hintText: '', // Ubah hint menjadi string kosong
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor:
                      Colors.white, // Ubah warna latar belakang menjadi terang
                  filled: true, // Aktifkan latar belakang terisi
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
            Positioned(
              left: 0,
              bottom: -23,
              right: 0,
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _register(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 115, vertical: 16),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Ubah warna teks menjadi putih
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final User user = User()
      ..username = username
      ..password = password;

    await hiveService.addUser(user);
    await sharedPreferencesService.setLoggedIn(true);

    if (username == '' && password == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Register Berhasil',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Pengguna Telah berhasil terdaftar.',
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
    } else {
      await hiveService.addUser(user);
      await sharedPreferencesService.setLoggedIn(true);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Register Berhasil',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Pengguna Telah berhasil terdaftar.',
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
}
