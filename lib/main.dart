import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/theme_controller.dart';
import 'views/main_screen.dart';
import 'utils/themes.dart';
import 'utils/constants.dart';

void main() {
  runApp(const IdeaSparkApp());
}

class IdeaSparkApp extends StatefulWidget {
  const IdeaSparkApp({super.key});

  @override
  State<IdeaSparkApp> createState() => _IdeaSparkAppState();
}

class _IdeaSparkAppState extends State<IdeaSparkApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    bool savedTheme = await ThemeController.loadThemePreference();
    setState(() {
      _isDarkMode = savedTheme;
    });
  }

  Future<void> _toggleTheme() async {
    bool newTheme = await ThemeController.toggleTheme();
    setState(() {
      _isDarkMode = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
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

  @override
  void initState() {
    super.initState();
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
          builder: (context) => MainScreen(
            toggleTheme: widget.toggleTheme,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lightbulb,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: GoogleFonts.merriweather(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Spark Your Next Big Idea',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: widget.isDarkMode 
                            ? Colors.white70 
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
