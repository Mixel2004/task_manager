import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _conformPasswordController = TextEditingController();
  String? valid;
  bool showPass = false;

  @override
  void dispose() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.email);
      FirebaseAuth.instance.signOut();
    }
    super.dispose();
  }

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
                    'Sign Up Using Your Email',
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
                      if (valid != null) return valid;
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid Email';
                      }
                      if (!EmailValidator.validate(_emailController.text)) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                    ),
                    style: const TextStyle(fontSize: 25),
                    autocorrect: false,
                    obscureText: !showPass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (value != _conformPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _conformPasswordController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Conform Password',
                    ),
                    style: const TextStyle(fontSize: 25),
                    autocorrect: false,
                    obscureText: !showPass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
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
                      Navigator.pop(context);
                    },
                    child:
                        const Text('Sign In', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      valid = null;
                      if (_formKey.currentState!.validate()) {
                        print('Validated');
                        signUp().then((value) {
                          valid = value;
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                          }
                        });
                      }
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

  Future<String?> signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _newPasswordController.text)
          .then((value) => print('Signed Up'));
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
    return "Something went wrong";
  }
}
