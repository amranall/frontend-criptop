import 'package:criptop/pages/auth/login.dart';
import 'package:criptop/pages/auth/register.dart';
import 'package:criptop/pages/bottomNav.dart';
import 'package:criptop/pages/navigations/updatepass.dart';
import 'package:criptop/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'Crypto App',
          theme: ThemeData.dark(),
          initialRoute: authProvider.isAuthenticated ? '/main' : '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/main': (context) => const BottomNavScreen(),
            '/update-password': (context) => UpdatePasswordPage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
