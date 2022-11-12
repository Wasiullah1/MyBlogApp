import 'package:blog/Screens/forgotpass.dart';
import 'package:blog/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Components/roundbutton.dart';
import 'HomeScreen.dart';

// import '../Models/current_user.dart';
// import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwaordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  bool isloaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text('LOGIN',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) return "Email is required*";

                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                        RegExp regex = RegExp(pattern.toString());

                        if (!regex.hasMatch(value.trim())) {
                          return "Email address is not valid";
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                          // } else if (value.length < 6) {
                          //   return "Your passwaord is less then 6 charactors";
                          // } else if (value.length > 15) {
                          //   return "Your passwaord is greator 15 charactors";
                        } else
                          return null;
                      },
                      controller: passwaordController,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    isloaded == false
                        ? RoundButton(
                            title: "Login",
                            onPress: () async {
                              setState(() {
                                isloaded = true;
                              });
                              await signIn("${emailController.text}",
                                  "${passwaordController.text}");
                              setState(() {
                                isloaded = false;
                              });
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPass()));
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Forget password?")),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Don't have an account?")),
                    SizedBox(
                      height: 10,
                    ),
                    RoundButton(
                      title: "Register",
                      onPress: () async {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                    )
                  ]),
            ),
          ),
        ));
  }

  Future<void> signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  // CurrentAppUser.currentUserData
                  //     .getCurrentUserData(uid.user!.uid),
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
