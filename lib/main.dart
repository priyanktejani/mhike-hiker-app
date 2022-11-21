import 'package:flutter/material.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/pages/home_page.dart';
import 'package:mhike/pages/login_page.dart';
import 'package:mhike/pages/signup_page.dart';
import 'package:mhike/services/auth/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M Hike',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const AuthenticationWrapper(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        signupRoute: (context) => const SignupPage(),
        homeRoute: (context) => const HomePage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
