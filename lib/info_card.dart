import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:corona/line_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String effectedNum;
  final Color iconColor;

  const InfoCard({
    Key key,
    this.title,
    this.effectedNum,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      return Container(
        width: snapshot.maxWidth / 2 - 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/running.svg",
                      height: 12,
                      width: 12,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(title)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "$effectedNum\n",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 20,color: kTextColor),
                        ),
                        TextSpan(
                          text: "İnsan",
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 12,
                            height: 2,
                          ),
                        )
                      ]),
                    ),
                  ),
                  Expanded(
                    child: LineReportChart(),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
