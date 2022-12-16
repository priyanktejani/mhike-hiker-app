import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/core/text_form_field_input.dart';
import 'package:mhike/services/auth/auth_exceptions.dart';
import 'package:mhike/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _containerHeight = 390.0;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

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
            height: _containerHeight,
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
                    fontSize: 64.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Divider(
                  height: 20,
                  color: Colors.transparent,
                ),

                // login form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // email field
                      TextFormFieldInput(
                        textEditingController: _emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email address',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const Divider(
                        height: 14,
                        color: Colors.transparent,
                      ),
                      // Password field
                      TextFormFieldInput(
                        textEditingController: _passwordController,
                        textInputType: TextInputType.text,
                        hintText: 'Password',
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Can\'t be empty';
                          }
                          if (value.length < 8) {
                            return 'Too short';
                          }
                          return null;
                        },
                      ),
                      const Divider(
                        height: 14,
                        color: Colors.transparent,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // login
                          // check if user input is valid
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            // get user input
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            try {
                              // firebase logIn
                              await AuthService.firebase().logIn(
                                email: email,
                                password: password,
                              );

                              // navigate to home
                              if (!mounted) return;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                homeRoute,
                                (Route<dynamic> route) => false,
                              );
                            } on UserNotFoundException {
                              "User not found";
                            } on WrongPasswordException {
                              "Wrong password";
                            } on GenericAuthException {
                              'Authentication error';
                            }
                          }

                          setState(() {
                            _containerHeight = 430;
                          });
                        },

                        // login button
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff282b41),
                          minimumSize: const Size(
                            double.infinity,
                            56,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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
                            Navigator.of(context).pushReplacementNamed(
                              signupRoute,
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
