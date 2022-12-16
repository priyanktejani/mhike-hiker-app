import 'package:flutter/material.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/pages/add_hike_page.dart';
import 'package:mhike/pages/hike_detail/hike_detail_page.dart';
import 'package:mhike/pages/home/home_page.dart';
import 'package:mhike/pages/auth/login_page.dart';
import 'package:mhike/pages/auth/signup_page.dart';
import 'package:mhike/pages/search_page.dart';
import 'package:mhike/services/auth/auth_service.dart';

void main() {
  runApp(
    const MyApp(),
  );
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
        searchRoute: (context) => const SearchPage(),
        addHikeRoute: (context) => const AddHikePage(),
        hikeDetailRoute: (context) => const HikeDetailPage(),
      },
    );
  }
}

// Authentication Wrapper
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
            // if user signed in than return home else login
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
