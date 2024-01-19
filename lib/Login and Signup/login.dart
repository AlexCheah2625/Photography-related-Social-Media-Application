import 'package:flutter/material.dart';
import 'package:practice/Screens/forget_password.dart';
import 'package:practice/mobilelayout.dart';
import 'package:practice/responsive/responsive.dart';
import 'package:practice/utils/utils.dart';
import 'package:practice/weblayout.dart';
import 'signup.dart';
import 'package:practice/resources/auth.dart';

// ignore: use_key_in_widget_constructors
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _Loading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser() async {
    setState(() {
      _Loading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "Success") {
      setState(() {
        _Loading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Responsive(
            mobileBody: MobileLayout(), desktopBody: WebLayout()),
      ));
    } else {
      setState(() {
        _Loading = false;
      });
      showSnackBar(res, context);
    }
    setState(() {
      _Loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("asset/Login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 80, left: 70),
                        child: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/id/237/200/300'),
                          radius: 60,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 80, left: 20),
                        child: const Text(
                          "Xenon",
                          style:
                              TextStyle(fontSize: 48, color: Color(0xFF2B414A)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.only(top: 230),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.transparent,
                                fontSize: 48,
                                fontFamily: 'Noto',
                                decorationColor: Color(0xFFDADADA),
                                shadows: [
                                  Shadow(
                                      color: Color(0xFFDADADA),
                                      offset: Offset(0, -13))
                                ],
                                decoration: TextDecoration.underline,
                                decorationThickness: 0.5),
                          )),
                      Container(
                          child: Column(
                        children: [
                          Container(
                            child: Column(children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 20),
                                child: const Text(
                                  "Email :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: 330,
                                  height: 32,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.all(8.0)),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'Please Enter Your Email'
                                          : null;
                                    },
                                    controller: _emailController,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 20),
                                child: const Text(
                                  "Password :",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: 330,
                                  height: 32,
                                  child: TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.all(10.0)),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'Please Enter Your Password'
                                          : null;
                                    },
                                    controller: _passwordController,
                                  ),
                                ),
                              ),
                              Container(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                                  .push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ForgetPassword()));
                                  },
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 45),
                                    child: const Text(
                                      'Forget Password?',
                                      style: TextStyle(
                                          color: Color(0xFFDADADA),
                                          fontFamily: "Noto"),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: SizedBox(
                                  width: 151,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: logInUser,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFDADADA),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: _Loading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ))
                                        : const Text(
                                            'Log-In',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Noto",
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: const Text("Dont have an Account ? ",
                                        style: TextStyle(
                                            color: Color(0xFFDADADA),
                                            fontSize: 16,
                                            fontFamily: "Noto")),
                                  ),
                                  Container(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUp()),
                                        )
                                      },
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Text(
                                          'SignUp',
                                          style: TextStyle(
                                              color: Color(0xFFDADADA),
                                              fontFamily: "Noto",
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            ]),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
