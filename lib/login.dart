import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/home.dart';
import 'package:todo/signup.dart';

import 'connect.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  var email = TextEditingController();
  var password = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  Future<void> postData() async {
    var data = {
      "email": email.text,
      "password": password.text,
    };
    var response = await post(Uri.parse('${Con.url}login.php'), body: data);
    var res = jsonDecode(response.body);
    print(res);

    if (response.statusCode == 200) {
      if (res['message'] == 'Login SuccessFully') {
        var id = res["reg_id"];

        final spref = await SharedPreferences.getInstance();
        spref.setString("reg_id", id);
        Fluttertoast.showToast(msg: 'Login Successfully');
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        ));
      } else {
        Fluttertoast.showToast(msg: 'Invalid username or password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
              SizedBox(height: 35),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 140),
                  color: Color.fromRGBO(229, 246, 247, 1.000),
                  height: 500,
                  width: 360,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "TODO",
                          style: TextStyle(
                              fontSize: 40,
                              color: Color.fromRGBO(0, 112, 173, 1),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 100, bottom: 0),
                          child: TextFormField(
                            controller: email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your Email";
                              }
                              if (!value.contains("@")) {
                                return "Enter Valid Email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Email",
                                contentPadding: EdgeInsets.only(left: 30),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10, bottom: 0),
                          child: TextFormField(
                            controller: password,
                            obscureText: passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your Password";
                              } else if (value.length < 6) {
                                return "atleast 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              contentPadding:
                                  EdgeInsets.only(left: 30, right: 30),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color.fromRGBO(0, 112, 173, 1),
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Lost Password?',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 112, 173, 1),
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (key.currentState!.validate()) {
                      postData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(0, 112, 173, 1),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Container(
                    width: 360,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 50.0,
                    ),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                      width: 30,
                      height: 30,
                      scale: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 50.0),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Twitter_2012_logo.svg/450px-Twitter_2012_logo.svg.png',
                      width: 40,
                      height: 40,
                      scale: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Image.network(
                      'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
                      width: 30,
                      height: 30,
                      scale: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signup(),
                          ));
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 112, 173, 1),
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
