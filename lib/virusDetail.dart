import 'dart:convert';

import 'package:corona/constants.dart';

import 'package:corona/header2.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as Elementt;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CountryDetail extends StatefulWidget {
  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  String olum, vaka, iyilesen;
  final controller = ScrollController();
  int sayac = 0;
  double offset = 0;
  String videoUrl = "https://www.youtube.com/watch?v=67RzwX4pL-Q";
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl));
    _turkiye();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Future _turkiye() async {
    await http
        .get(
            'https://news.google.com/covid19/map?hl=tr&mid=/m/01znc_&gl=TR&ceid=TR:tr')
        .then((gelenVeri) {
      var document = parse(gelenVeri.body);
      List<Elementt.Element> links = document.querySelectorAll(
          '#yDmH0d > c-wiz > div > div.FVeGwb.ARbOBb > div.BP0hze > div.y3767c > div > div > div.zRzGke.EA71Tc.pym81b > div.UnO7qd > div > div > div.fNm5wd.qs41qe > div.UvMayb');
      List<Elementt.Element> links2 = document.querySelectorAll(
          '#yDmH0d > c-wiz > div > div.FVeGwb.ARbOBb > div.BP0hze > div.y3767c > div > div > div.zRzGke.EA71Tc.pym81b > div.UnO7qd > div > div > div.fNm5wd.qs41qe > div.UvMayb');
      List<Elementt.Element> links3 = document.querySelectorAll(
          '#yDmH0d > c-wiz > div > div.FVeGwb.ARbOBb > div.BP0hze > div.y3767c > div > div > div.zRzGke.EA71Tc.pym81b > div.UnO7qd > div > div > div.fNm5wd.qs41qe > div.UvMayb');

      List<String> linkMap = [];
      for (var link in links) {
        linkMap.add(
          link.text,
        );
      }

      for (var link in links2) {
        linkMap.add(
          link.text,
        );
      }
      for (var link in links3) {
        linkMap.add(
          link.text,
        );
      }

      setState(() {
        vaka = json
            .encode(linkMap[0])
            .replaceAll('\n', '')
            .replaceAll('\t', '')
            .replaceAll(' ', '')
            .replaceAll('n', '')
            .replaceAll("\\", '')
            .replaceAll('"', '')
            .replaceAll('[', '')
            .replaceAll(']', '');
        iyilesen = json
            .encode(linkMap[1])
            .replaceAll('\n', '')
            .replaceAll('\t', '')
            .replaceAll(' ', '')
            .replaceAll('n', '')
            .replaceAll("\\", '')
            .replaceAll('"', '')
            .replaceAll('[', '')
            .replaceAll(']', '');
        olum = json
            .encode(linkMap[2])
            .replaceAll('\n', '')
            .replaceAll('\t', '')
            .replaceAll(' ', '')
            .replaceAll('n', '')
            .replaceAll("\\", '')
            .replaceAll('"', '')
            .replaceAll('[', '')
            .replaceAll(']', '');

        // _htmlVeri = _htmlVeri.replaceAll(RegExp("[a-zA-Z]"), '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader2(
              image: "assets/icons/nurse.svg",
              textTop: "Türkiye Covid-19",
              textBottom: "İstatistik",
              offset: offset,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: vaka != null ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Veri(
                              gelenVeri: vaka,
                              title: "Toplam Vaka",
                              renk: kInfectedColor),
                          Veri(
                              gelenVeri: olum,
                              title: "Toplam Ölüm",
                              renk: kDeathColor),
                          Veri(
                              gelenVeri: iyilesen,
                              title: "İyileşen",
                              renk: kRecovercolor),
                        ],
                      ) : Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            YoutubePlayer(
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}

class Veri extends StatelessWidget {
  const Veri({
    Key key,
    @required this.title,
    @required this.gelenVeri,
    @required this.renk,
  }) : super(key: key);

  final String title;
  final String gelenVeri;
  final Color renk;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: renk.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: renk, width: 2),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          gelenVeri,
          style: GoogleFonts.poppins(
              color: renk, fontSize: 30, fontWeight: FontWeight.w300),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
              color: kTextLightColor,
              fontSize: 12,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
