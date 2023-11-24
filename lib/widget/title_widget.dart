import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget titleWidget(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 10, top: 10),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
    ),
  );
}

Widget headerWidget(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 10, top: 10),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
    ),
  );
}


Widget rowHeader(String text, int flex) {
  return Expanded(
    flex: flex,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade700,
        ),
        color: Colors.yellow.shade900,
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
