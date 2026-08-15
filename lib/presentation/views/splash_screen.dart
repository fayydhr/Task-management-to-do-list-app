import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar mentok kanan-kiri di bagian atas
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/png/image.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Konten Teks dan Tombol di bagian bawah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul
                  Text(
                    'Task Management &\nTo-Do List',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'This productive tool is designed to help\nyou better manage your task\nproject-wise conveniently!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6E6A7C),
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Let's Start
                  GestureDetector(
                    onTap: () => Get.offNamed('/home'),
                    child: Container(
                      width: 331,
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5F33E1),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5F33E1).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'Let’s Start',
                            style: GoogleFonts.lexendDeca(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: SvgPicture.asset(
                              'assets/svg/arrow.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 75),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
