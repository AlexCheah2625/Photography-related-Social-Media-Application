import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/Login%20and%20Signup/login.dart';
import 'package:practice/resources/auth.dart';
import 'package:practice/responsive/responsive.dart';
import 'package:practice/utils/utils.dart';
import '../mobilelayout.dart';
import '../weblayout.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;

  final _formKey = GlobalKey<FormState>();
  final List<String> genders = ['Male', 'Female', 'Others'];
  String _genders = "Male";
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signupUser() async {
    setState(() {
      _loading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      age: _ageController.text,
      gender: _genders,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _loading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Login()));
    }
  }

  void selectImage() async {
    Uint8List pic = await pickImage(ImageSource.gallery);
    setState(() {
      _image = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //background pic
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("asset/Signup.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height:MediaQuery.of(context).size.height*1.2 ,
          child: SingleChildScrollView(
            physics:const ClampingScrollPhysics(),
            child: Column(
              children: [
              //Logo
              Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(_image!),
                                  radius: 80,
                                ),
                                backgroundColor: Color(0xFF2B414A),
                                radius: 85,
                              )
                            : const CircleAvatar(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'),
                                  radius: 80,
                                ),
                                backgroundColor: Color(0xFF2B414A),
                                radius: 85,
                              ),
                        Positioned(
                            bottom: -10,
                            left: 100,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ))
                      ],
                    ),
                  )),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Container(
                            //Signup
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            margin: const EdgeInsets.only(top: 135),
                            child: const Text(
                              "Sign Up",
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(children: [
                        Row(
                          children: [
                            Container(
                              //Email
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              margin: const EdgeInsets.only(top: 10),
                              child: const Text(
                                "Email",
                                style: TextStyle(
                                    color: Color(0xFFDADADA),
                                    fontFamily: 'Noto',
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 46),
                              margin: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*0.019,
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                      color: Color(0xFFDADADA),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 5),
                              margin: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*0.55,
                                height: 32,
                                child: TextFormField(
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
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
                          ],
                        ),
                        Container(
                          //Username
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  "Username",
                                  style: TextStyle(
                                      color: Color(0xFFDADADA),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 1),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.019,
                                  child: const Text(
                                    ":",
                                    style: TextStyle(
                                        color: Color(0xFFDADADA),
                                        fontFamily: 'Noto',
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 5),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.55,
                                  height: 32,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'Please Enter Your Username'
                                          : null;
                                    },
                                    controller: _usernameController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //Username
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  "Bio",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 73),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.017,
                                  child: const Text(
                                    ":",
                                    style: TextStyle(
                                        color: Color(0xFFD9D9D9),
                                        fontFamily: 'Noto',
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 5),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.55,
                                  height: 32,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'Please Enter Your Bio'
                                          : null;
                                    },
                                    controller: _bioController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                //Age
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  "Age",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontSize: 20,
                                      fontFamily: "Noto"),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 70),
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.55,
                                  height: 32,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'Please Enter Your Age'
                                          : null;
                                    },
                                    controller: _ageController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //Gender
                          child: Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, left: 20),
                                child: const Text(
                                  "Gender",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontSize: 20,
                                      fontFamily: "Noto"),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 31),
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                margin: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 110,
                                  child: Form(
                                    key: _formKey,
                                    child: DropdownButtonFormField<String>(
                                        value: _genders == ''
                                            ? genders[0]
                                            : genders[0],
                                        dropdownColor: Colors.black,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFFD9D9D9),
                                        ),
                                        items: genders.map((gender) {
                                          return DropdownMenuItem(
                                              value: gender,
                                              child: Text('$gender',
                                                  style: TextStyle(
                                                      color: Color(0xFFD9D9D9),
                                                      fontSize: 20,
                                                      fontFamily: "Noto")));
                                        }).toList(),
                                        onChanged: (val) =>
                                            setState(() => _genders = val!)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //Password
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  "Password",
                                  style: TextStyle(
                                      color: Color(0xFFD9D9D9),
                                      fontFamily: 'Noto',
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 9),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  child: const Text(
                                    ":",
                                    style: TextStyle(
                                        color: Color(0xFFD9D9D9),
                                        fontFamily: 'Noto',
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 5),
                                margin: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.55,
                                  height: 32,
                                  child: TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
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
                            ],
                          ),
                        ),
                        Container(
                          //Button
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 151,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: signupUser,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDADADA),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: _loading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ))
                                    : const Text(
                                        'Sign-Up',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Noto",
                                            color: Colors.black),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
