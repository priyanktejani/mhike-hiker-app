import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mhike/core/text_field_input.dart';
import 'package:mhike/pages/home_page.dart';
import 'package:mhike/pages/login_page.dart';
import 'package:mhike/services/auth/auth_exceptions.dart';
import 'package:mhike/services/auth/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
            height: 420,
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 55, 59, 87),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Register your ',
                      style: TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'account',
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
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
                    // register
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    try {
                      await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );
                       Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                    } on WeekPasswordException {
                      'Weak password';
                    } on EmailAlreadyInUseException {
                      'Email already registered';
                    } on InvalidEmailException {
                      'Invalid email';
                    } on GenericAuthException {
                      'Failed to register';
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
                      backgroundColor: Colors.blue.shade800),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  height: 14,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
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
