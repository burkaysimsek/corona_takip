import 'dart:convert';
import 'package:corona/virusDetail.dart';

import 'package:corona/Virusveri.dart';
import 'package:corona/constants.dart';
import 'package:corona/header.dart';
import 'package:corona/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class virusBilgi extends StatefulWidget {
  virusBilgi({Key key}) : super(key: key);

  @override
  _virusBilgiState createState() => _virusBilgiState();
}

class _virusBilgiState extends State<virusBilgi> {
  final controller = ScrollController();
  double offset = 0;

  String url = "https://api.covid19api.com/summary";

  Virusveri virusveri;
  Future<Virusveri> veri;

  Future<Virusveri> veriGetir() async {
    var response = await http.get(url);
    var decodedJson = json.decode(response.body);
    virusveri = Virusveri.fromJson(decodedJson);
    return virusveri;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    veri = veriGetir();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/nurse.svg",
              textTop: "Covid-19 İstatistik",
              textBottom: "#EvdeKal",
              offset: offset,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 335,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.03),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: FutureBuilder(
                future: veri,
                builder: (context, AsyncSnapshot<Virusveri> gelenDeger) {
                  if (gelenDeger.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (gelenDeger.connectionState ==
                      ConnectionState.done) {
                    return Wrap(
                      runSpacing: 20,
                      spacing: 20,
                      children: <Widget>[
                        InfoCard(
                          title: "Toplam Vakalar",
                          iconColor: Color(0xFFFF8C00),
                          effectedNum:
                              gelenDeger.data.global.totalConfirmed.toString(),
                        ),
                        InfoCard(
                          title: "Toplam Ölüm",
                          iconColor: Color(0xFFFF2D55),
                          effectedNum:
                              gelenDeger.data.global.totalDeaths.toString(),
                        ),
                        InfoCard(
                          title: "İyileşenler",
                          iconColor: Color(0xFF50E3C2),
                          effectedNum:
                              gelenDeger.data.global.totalRecovered.toString(),
                        ),
                        InfoCard(
                          title: "Yeni Vakalar",
                          iconColor: Color(0xFF5856D6),
                          effectedNum:
                              gelenDeger.data.global.newRecovered.toString(),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Korun",
                      style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    buildPreventation(),
                    SizedBox(height: 40),
                    GestureDetector(
                      child: buildHelpCard(context),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (CountryDetail())),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Row buildPreventation() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      PreventitonCard(
        svgSrc: "assets/icons/hand_wash.svg",
        title: "Ellerini Yıka",
      ),
      PreventitonCard(
        svgSrc: "assets/icons/use_mask.svg",
        title: "Maske Tak",
      ),
      PreventitonCard(
        svgSrc: "assets/icons/Clean_Disinfect.svg",
        title: "Dezenfektan Kullan",
      ),
    ],
  );
}

class PreventitonCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  const PreventitonCard({
    Key key,
    this.svgSrc,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(svgSrc),
        SizedBox(height: 5),
        Text(
          title,
          style: GoogleFonts.poppins(
              color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

Container buildHelpCard(BuildContext context) {
  return Container(
    height: 150,
    width: double.infinity,
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            // left side padding is 40% of total width
            left: MediaQuery.of(context).size.width * .4,
            top: 20,
            right: 20,
          ),
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF60BE93),
                Color(0xFF1B8D59),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Ülkendeki Tüm\n",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                      text: "istatislikleri Gör",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset("assets/icons/earth.png"),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: SvgPicture.asset("assets/icons/virus.svg"),
        ),
      ],
    ),
  );
}
