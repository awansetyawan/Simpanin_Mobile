import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/pages/misc/splash.dart';
import 'package:simpanin/firebase_options.dart';
import 'package:simpanin/providers/maintenance_create_provider.dart';
import 'package:simpanin/providers/page_provider.dart';
import 'package:simpanin/providers/user_provider.dart';
import 'package:simpanin/providers/mailbox_book_provider.dart';
import 'package:simpanin/providers/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ThemeModeProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => MailboxBookProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => MaintenanceCreateProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => PageProvider(),
        ),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, themeModeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Simpanin',
            theme: _buildLightTheme(context),
            darkTheme: _buildDarkTheme(context),
            themeMode: themeModeProvider.isDarkModeActive
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        background: Colors.white,
        brightness: Brightness.light,
        primary: const Color(0xFFF16807),
        secondary: const Color(0xFF1A1A1A),
        tertiary: const Color(0xFFfef0e6),
        error: Colors.white,
        onBackground: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.copyWith(
              displayLarge: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
              displaySmall: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              displayMedium: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              bodyMedium: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              bodySmall: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        background: const Color(0xFF222222),
        brightness: Brightness.dark,
        primary: const Color(0xFFf48639),
        secondary: Colors.white,
        tertiary: const Color(0xFF2D2D2D),
        error: const Color(0xFFB00020),
        onBackground: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.copyWith(
              displayLarge: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
              displaySmall: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              displayMedium: const TextStyle(
                color: Color(0xFFB0B0B0), // Updated to a dark color
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              titleLarge: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
              bodyLarge: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              bodyMedium: const TextStyle(
                color: Color(0xFFB0B0B0), // Updated to a dark color
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70),
              bodySmall: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
