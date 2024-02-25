import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(172, 255, 255, 255),
        minimumSize: const Size(double.infinity, 45),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: GoogleFonts.rajdhani(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.orange[600]),
      ),
    );
  }
}
