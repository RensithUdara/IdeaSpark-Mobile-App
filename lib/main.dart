import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';

void main() {
  runApp(const StartupApp());
}

class StartupApp extends StatefulWidget {
  const StartupApp({super.key});

  @override
  State<StartupApp> createState() => _StartupAppState();
}

class _StartupAppState extends State<StartupApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    themeLoadPreference();
  }

  Future<void> themeLoadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
    });
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IdeaSpark',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Future<void> Function() toggleTheme;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack);

    _fadeAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    _logoController.forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(
            toggleTheme: widget.toggleTheme,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
    });
    await prefs.setBool('isDarkMode', isDarkMode);
  }
  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFFFACC15),
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Slide-in App Name
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    "IdeaSpark",
                    style: GoogleFonts.merriweather(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Fade-in Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Think. Share. Evolve.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SUNSET GRADIENT THEME (Creative Orange + Pink + Indigo + Teal)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFB923C), // Vibrant Orange
  scaffoldBackgroundColor: const Color(0xFFFFF7ED), // Soft Cream
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFB923C),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFB923C),   // Orange
    secondary: Color(0xFFF472B6), // Pink
    tertiary: Color(0xFF6366F1),  // Indigo
    surface: Color(0xFFFFFBF7),   // Light surface
    background: Color(0xFFFFF7ED),// Cream background
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFB923C),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFF97316), // Deep Orange
  scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep Navy
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E293B), // Dark surface
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFF97316),  // Orange Glow
    secondary: Color(0xFFEC4899),// Pink Accent
    tertiary: Color(0xFF818CF8), // Indigo Accent
    surface: Color(0xFF1E293B),  // Dark Card Surface
    background: Color(0xFF0F172A), // Background
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF97316),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
  ),
);

