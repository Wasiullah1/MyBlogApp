import 'package:blog/Components/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  bool isloaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent, title: Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formkey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
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
                  RoundButton(
                      title: "Recover Password",
                      onPress: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            isloaded = false;
                          });
                          try {
                            _auth
                                .sendPasswordResetEmail(
                                    email: emailController.text.toString())
                                .then((value) {
                              setState(() {
                                isloaded = false;
                              });
                              toastMessage(
                                  'Please Check your email, a reset link has been sent to your email');
                            }).onError((error, stackTrace) {
                              toastMessage(error.toString());
                              setState(() {
                                isloaded = false;
                              });
                            });
                          } catch (e) {
                            print(e.toString());
                            toastMessage(e.toString());
                          }
                        }
                      }),
                ]),
          ),
        ));
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context) => HomeScreen())),
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
