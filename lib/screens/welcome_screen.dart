import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animationForBackground;
  Animation animationForLogo;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      upperBound: 1,
    );
//     animation = CurvedAnimation(
//       parent: controller,
//       curve: Curves.decelerate,
//     );
//
    animationForLogo = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );
//
    animationForBackground = ColorTween(
            begin: Color.fromARGB(255, 210, 183, 180),
            end: Color.fromARGB(255, 103, 149, 156))
        .animate(controller);

    //
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animationForBackground.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animationForLogo.value * 70,
                  ),
                ),

                // TypewriterAnimatedTextKit(
                //   text: ['Flash Chat'],
                //   textStyle: TextStyle(
                //     fontSize: 45.0,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                Text(
                  "Let's Talk",
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                buttonColor: Colors.lightBlueAccent,
                onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                buttonTitle: 'LogIn'),
            RoundedButton(
                buttonColor: Colors.blueAccent,
                onPressed: () =>
                    Navigator.pushNamed(context, RegistrationScreen.id),
                buttonTitle: 'Register'),
          ],
        ),
      ),
    );
  }
}
