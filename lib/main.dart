import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => Scaffold(
              appBar: AppBar(title: const Text('Katalog Resep')),
              body: const Center(child: Text('Berhasil Masuk ke Home!')),
            ),
      },
    );
  }
}