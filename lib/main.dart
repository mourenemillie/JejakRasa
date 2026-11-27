import 'package:flutter/material.dart';
import 'theme.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Resep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkGoldTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Katalog Resep'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    tooltip: 'Profil',
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ],
              ),
              body: const Center(child: Text('Berhasil Masuk ke Home!')),
            ),
      },
    );
  }
}