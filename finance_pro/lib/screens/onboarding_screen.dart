import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../main.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Toma el control',
      'description': 'Monitorea tus ingresos y gastos en múltiples monedas, incluso sin conexión a internet.',
      'icon': LucideIcons.wallet,
    },
    {
      'title': 'Detecta lo invisible',
      'description': 'Nuestra inteligencia artificial detecta gastos hormiga para que sepas a dónde se va tu dinero sin darte cuenta.',
      'icon': LucideIcons.eye,
    },
    {
      'title': 'Alcanza tus metas',
      'description': 'Establece objetivos de ahorro, haz seguimiento a tu patrimonio y mejora tu salud financiera.',
      'icon': LucideIcons.target,
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -150, right: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.accentColor.withAlpha(50), Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: -100, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.accentPurple.withAlpha(50), Colors.transparent]),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Saltar', style: TextStyle(color: AppColors.textMuted)),
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) => setState(() => _currentPage = page),
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Glass Icon Container
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 120, height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(20),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: AppColors.accentColor.withAlpha(100), width: 2),
                                  ),
                                  child: Icon(_onboardingData[index]['icon'], size: 50, color: AppColors.accentColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              _onboardingData[index]['title'],
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _onboardingData[index]['description'],
                              style: const TextStyle(fontSize: 16, color: AppColors.textMuted, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? AppColors.accentColor : Colors.white.withAlpha(50),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Next / Start Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _onboardingData.length - 1) {
                              _completeOnboarding();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1 ? 'Comenzar' : 'Siguiente',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
