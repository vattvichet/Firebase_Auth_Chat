import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/dialogs/get_dialog.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogIn'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _emailInput,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: _passwordInput,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundedButton(
                      buttonColor: Colors.lightBlueAccent,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final loggedInUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: _emailInput.text,
                                  password: _passwordInput.text);
                          if (loggedInUser != null) {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        } on Exception catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) => GetDialog(
                                    notificationType: "LogIn Failed!",
                                    content: "Account Invalid",
                                    backgroundColor: Colors.lightBlueAccent,
                                    buttonColor: Colors.brown,
                                  ));

                          print(e);
                        }
                      },
                      buttonTitle: 'LogIn'),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      child: Text("Haven't had account Yet? Click Here!")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
