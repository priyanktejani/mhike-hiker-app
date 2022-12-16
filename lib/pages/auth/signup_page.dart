import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/core/text_form_field_input.dart';
import 'package:mhike/services/auth/auth_exceptions.dart';
import 'package:mhike/services/auth/auth_service.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/user.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final MHikeService _mHikeService;

  double _containerHeight = 550.0;

  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _passwordController;

  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mHikeService = MHikeService();

    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future createNewUser() async {
    // get user inpute
    final email = _emailController.text;
    final username = _usernameController.text;
    final fullName = _fullNameController.text;
    final password = _passwordController.text;

    // signup
    // create new user object
    User newUser = User(
      email: email,
      username: username,
      fullName: fullName,
    );

    // add user to the databse
    _mHikeService.createUser(user: newUser);

    // create new firebase user or throw Exception
    try {
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        homeRoute,
        (Route<dynamic> route) => false,
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      TextFormFieldInput(
                        textEditingController: _usernameController,
                        textInputType: TextInputType.text,
                        hintText: 'Username',
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
                      TextFormFieldInput(
                        textEditingController: _fullNameController,
                        textInputType: TextInputType.name,
                        hintText: 'Full name',
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
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            createNewUser();
                          }

                          setState(() {
                            _containerHeight = 640;
                          });
                        },
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
                          'Sign Up',
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
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute,
                              (Route<dynamic> route) => false,
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
