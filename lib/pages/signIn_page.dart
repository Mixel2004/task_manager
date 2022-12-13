import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int? valid;
  bool showPass = false;
  Map<int, String> errors = {
    1: 'The password is invalid.',
    2: 'Password must be at least 6 characters',
    3: 'No user found for that email.',
    4: 'The email address is invalid.',
    5: 'Some thing went wrong',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Sign In Using Your Email',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    style: const TextStyle(fontSize: 25),
                    validator: (value) {
                      if (!EmailValidator.validate(_emailController.text)) {
                        return 'Please enter a valid Email';
                      }
                      if (valid != null && ([3, 4, 5].contains(valid))) {
                        return errors[valid];
                      }
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    style: const TextStyle(fontSize: 25),
                    autocorrect: false,
                    obscureText: !showPass,
                    validator: (value) {
                      if (_passwordController.text.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (valid != null && ([1, 2, 5].contains(valid))) {
                        return errors[valid];
                      }
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: showPass,
                        onChanged: (value) {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        activeColor: Colors.grey.shade400,
                      ),
                      const Text(
                        'Show Password',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      valid = null;
                      if (_formKey.currentState!.validate()) {
                        signIn().then((value) {
                          valid = value;
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/content');
                          }
                        });
                      }
                    },
                    child:
                        const Text('Sign In', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      reset();
                      Navigator.pushNamed(context, '/signup');
                    },
                    child:
                        const Text('Sign Up', style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<int?> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        reset();
        return 3;
      } else if (e.code == 'wrong-password') {
        _passwordController.clear();
        return 1;
      }
    }
    return 5;
  }

  void reset() {
    _emailController.clear();
    _passwordController.clear();
    valid = null;
  }
}
