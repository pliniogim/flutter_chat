import 'package:flutter/material.dart';
import '../widgets/rounded_button.dart';
import 'package:flutter_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 100.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your Email...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                password = value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your Password...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              pressed: () async {
                try {
                  // print('$email $password');
                  //Implement registration functionality.
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } catch (e){
                 print(e);
                }
              },
              color: Colors.blueAccent,
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
