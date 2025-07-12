import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, required this.isPassword, required this.hintText});

  final TextEditingController controller;
  final bool isPassword;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF))
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF000000))
        ),
        fillColor: const Color(0xFFFFFFFF),
        filled: true,
        hint: Padding(
          padding: const EdgeInsets.all(0 * 0.02),
          child: Text(
            hintText,
            style: GoogleFonts.tenorSans(
              color: const Color(0xFF333333),
              fontSize: 16
            ),
          ),
        )
      ),
    );
  }
}
