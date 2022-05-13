import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/login_screen.dart';
import 'package:flutter_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key})
      : super(key: key); //for use in Navigation, avoiding the use of strings
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController anController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    anController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this, //the ticker (the _WelcomeScreenState)
      upperBound: 1.0,
    );
    //animation = CurvedAnimation(parent: anController, curve: Curves.decelerate); //Curves.decelerate...
    anController.forward();
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(anController);
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed){
    //     //anController.reverse();
    //   } else if (status == AnimationStatus.dismissed){
    //     anController.forward();
    //   }
    // });
    // anController.reverse(from: 1.0);
    anController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    anController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      //backgroundColor: Colors.white,
      //backgroundColor: Colors.red.withOpacity(anController.value),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: SizedBox(
                //height: animation.value * 100,
                height: 60,
                //height: anController.value,
                child: Image.asset('images/logo.png'),
              ),
            ),
            Center(
              child: AnimatedTextKit(
                stopPauseOnTap: true,
                animatedTexts: [
                  TypewriterAnimatedText('Flash Chat',
                      textStyle: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              title: 'Log In',
              pressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              color: Colors.blueAccent,
              title: 'Register',
              pressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
