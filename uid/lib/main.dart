import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'screens/difficulty_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/leaderboard_screen.dart';

void main() {
  runApp(const MemoryMatchApp());
}

/// Main application widget.
/// Sets up the theme, provider, and navigation.
class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Memory Match',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: HomeScreen.routeName,
        routes: _buildRoutes(),
      ),
    );
  }

  /// Builds the playful app theme with vibrant colors.
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE91E63), // Playful Pink
        brightness: Brightness.light,
        secondary: const Color(0xFF03A9F4), // Light Blue
        surface: const Color(0xFFFFF8E1), // Cream
        primaryContainer: const Color(0xFFFFE0F2), // Light Pink
        secondaryContainer: const Color(0xFFE3F2FD), // Light Blue
        errorContainer: const Color(0xFFFFDAD5),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6200EE),
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE91E63),
          letterSpacing: 1.5,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF03A9F4),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6200EE),
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF03A9F4),
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFFFF8E1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: const Color(0xFFE91E63).withOpacity(0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE91E63),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFFF8E1),
        selectedColor: const Color(0xFFE91E63).withOpacity(0.2),
        labelStyle: GoogleFonts.poppins(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// Builds the route table for named navigation.
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      HomeScreen.routeName: (context) => HomeScreen(),
      DifficultyScreen.routeName: (context) => DifficultyScreen(),
      GameScreen.routeName: (context) => GameScreen(),
      ResultScreen.routeName: (context) => ResultScreen(),
      HowToPlayScreen.routeName: (context) => HowToPlayScreen(),
      LeaderboardScreen.routeName: (context) => const LeaderboardScreen(),
    };
  }
}
