import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/shared_preferences_service.dart';
import 'splash_screen.dart';
import 'surah_list.dart';

SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
final HiveService hiveService = HiveService();

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String _username;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
  }

  Future<void> getUsername() async {
    final User? user = await hiveService.getUser(_username);
    if (user != null) {
      setState(() {
        _username = user.username;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _logOut(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      print(_selectedIndex);
    }
  }

  Future<void> _logOut(BuildContext context) async {
    await sharedPreferencesService.setLoggedIn(false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: _appBar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: background,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: primary,
            ),
            label: 'Surah',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              color: text,
            ),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primary,
        unselectedItemColor: text,
      ),
      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _greeting(),
              ),
            ],
            body: const SurahList(),
          ),
        ),
      ),
    );
  }

  Column _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assalamualaikum',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: text,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          _username,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        _banner(),
      ],
    );
  }

  Stack _banner() {
    return Stack(
      children: [
        Container(
          height: 131,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, .6, 1],
              colors: [
                Color(0xFFDF98FA),
                Color(0xFFB070FD),
                Color(0xFF9055FF),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset('assets/svgs/quran.svg'),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Quran App',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Al-Quran lengkap\ndengan terjemahan Indonesia',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      title: Center(
        child: Text(
          'Quran App',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
