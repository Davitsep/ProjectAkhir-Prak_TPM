import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/globals.dart';
import 'package:the_holy_quran/models/surah.dart';
import 'package:the_holy_quran/screens/detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurahList extends StatefulWidget {
  const SurahList({Key? key}) : super(key: key);

  @override
  _SurahListState createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
  late Future<List<Surah>> _surahListFuture;
  List<Surah> _surahList = [];
  List<Surah> _filteredSurahList = [];

  @override
  void initState() {
    super.initState();
    _surahListFuture = _fetchSurahList();
  }

  Future<List<Surah>> _fetchSurahList() async {
    final response = await http.get(Uri.parse('https://equran.id/api/surat'));
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = jsonDecode(response.body);
      final List<Surah> surahList =
          decodedJson.map((dynamic item) => Surah.fromJson(item)).toList();
      setState(() {
        _surahList = surahList;
        _filteredSurahList = surahList;
      });
      return surahList;
    } else {
      throw Exception('Failed to fetch surah list from API');
    }
  }

  void filterSurahList(String query) {
    final List<Surah> filteredList = _surahList.where((surah) {
      final String name = surah.nama.toLowerCase();
      final String latinName = surah.namaLatin.toLowerCase();
      final String queryLower = query.toLowerCase();
      return name.contains(queryLower) || latinName.contains(queryLower);
    }).toList();

    setState(() {
      _filteredSurahList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: TextField(
            onChanged: filterSurahList,
            style:
                TextStyle(color: Colors.white), // Set the text color to white
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search,
                  color: Colors.white), // Set the icon color to white
              labelStyle: TextStyle(
                  color: Colors.white), // Set the label color to white
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white), // Set the border color to white
                borderRadius:
                    BorderRadius.circular(10.0), // Set the border radius
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _filteredSurahList.length,
            separatorBuilder: (context, index) => Divider(
              color: const Color(0xFF7B80AD).withOpacity(.35),
            ),
            itemBuilder: (context, index) {
              final surah = _filteredSurahList[index];
              return _surahItem(context: context, surah: surah);
            },
          ),
        ),
      ],
    );
  }

  Widget _surahItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(
              noSurat: surah.nomor,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset('assets/svgs/nomor-surah.svg'),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Text(
                        "${surah.nomor}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          surah.tempatTurun.name,
                          style: GoogleFonts.poppins(
                            color: text,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: text,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${surah.jumlahAyat} Ayat",
                          style: GoogleFonts.poppins(
                            color: text,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                surah.nama,
                style: GoogleFonts.amiri(
                  color: primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}
