import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhike/core/text_field_input.dart';
import 'package:mhike/pages/home_page.dart';
import 'package:mhike/pages/signup_page.dart';
import 'package:mhike/services/auth/auth_exceptions.dart';
import 'package:mhike/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282b41),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 400,
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 55, 59, 87),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'mhike',
                  style: GoogleFonts.dancingScript(
                    fontSize: 58.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Divider(
                  height: 20,
                  color: Colors.transparent,
                ),
                SizedBox(
                  child: TextFieldInput(
                    textEditingController: _emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: 'Email address',
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // login
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      // final user = AuthService.firebase().currentUser;
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } on UserNotFoundException {
                      "User not found";
                    } on WrongPasswordException {
                      "Wrong password";
                    } on GenericAuthException {
                      'Authentication error';
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      56,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: const Color(0xff282b41),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  height: 14,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
