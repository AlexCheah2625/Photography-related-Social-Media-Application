import 'package:flutter/material.dart';
import 'package:practice/color.dart';
import 'package:practice/resources/auth.dart';
import 'package:practice/utils/utils.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  bool _Loading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffold,
      appBar: AppBar(
        backgroundColor: Palette.postcolor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Xenon",
          style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontFamily: 'Ale',
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Text(
                  "Forget Password?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Noto',
                      fontWeight: FontWeight.bold,
                      decorationColor: Color(0xFFDADADA),
                      decoration: TextDecoration.underline,
                      decorationThickness: 0.5),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
              child: Center(
                child: Text("Enter your Email to reset your password :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Noto',
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: 350,
                height: 35,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(8.0)),
                  onChanged: (String value) {},
                  validator: (value) {
                    return value!.isEmpty ? 'Please Enter Your Email' : null;
                  },
                  controller: _emailController,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 151,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text;

                    // Check if email is not null or empty
                    if (email.isNotEmpty) {
                      AuthMethods().resetPassword(email);
                      showSnackBar("Password Reset Email Sent!", context);
                      Navigator.pop(context);
                    } else {
                      // Show an error message or handle the case where email is empty
                      showSnackBar("Please Enter Your Email", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDADADA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: _Loading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.black,
                        ))
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Noto",
                              color: Colors.black),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
