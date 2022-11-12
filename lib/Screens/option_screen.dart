import 'package:blog/Components/roundbutton.dart';
import 'package:blog/Screens/loginScreen.dart';
import 'package:blog/Screens/signup.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/blog.png"),
                  width: 180,
                  height: 300,
                ),
                RoundButton(
                    title: "Login",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginScreen())));
                    }),
                SizedBox(height: 30),
                RoundButton(
                    title: "Register",
                    onPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => SignUp())));
                    }),
              ]),
        ),
      ),
    );
  }
}
