import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/colors.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class LockOverlayScreen extends StatelessWidget {
  const LockOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: Localization might not be available in the overlay isolate easily
    // so we use hardcoded strings for the overlay for reliability.
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blur Background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: AppColors.emerald.withOpacity(0.9),
              ),
            ),
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 2),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.gold,
                        size: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    child: const Text(
                      "Time for Tilawa",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      "This app is locked until you recite Quran. Discipline begins with recitation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Signal to main app to open recitation
                          FlutterOverlayWindow.closeOverlay();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.emerald,
                        ),
                        child: const Text(
                          "Start Recitation",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      FlutterOverlayWindow.closeOverlay();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
