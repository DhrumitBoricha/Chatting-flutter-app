import 'dart:io';

import 'package:Chat.On/hometry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var confirmPass;

  File? therapist_photo;

  Future<void> profile_image() async {
    XFile? xf = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xf != null) {
      setState(() {
        therapist_photo=File(xf.path);
      });
    }
  }

  final _fauth1 =  FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLoading = false;
  void _handleContainerTap() {
    setState(() {
      _isLoading = true;
    });

    // Simulating a loading process
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }


  TextEditingController confirmpassword = TextEditingController();

  login()async {
    try{
      await _fauth1.signInWithEmailAndPassword(email:email.text , password: password.text).then((value) async {
        Navigator.push(context, MaterialPageRoute(builder:(context)=>AnimatedDrawer())

        ).onError(( FirebaseAuthException error, stackTrace) {
          Fluttertoast.showToast(msg: error.message.toString());
        });
      });
    }
    on FirebaseAuthException catch(error)
    {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  TextEditingController email1 = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController username1 = TextEditingController();
  TextEditingController city1 = TextEditingController();

  SingUp() async
  {
    try
    {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("Image/${email1.text}");
      UploadTask uploadTask = ref.putFile(therapist_photo!);
      await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
      String spaURL = await ref.getDownloadURL();
      print('Download URL: $spaURL');
      await _fauth1.createUserWithEmailAndPassword(email:email1.text.toString() , password:password1.text.toString()).then((value) {
        FirebaseFirestore.instance.collection('Users').doc(email1.text.toString()).set({
          "Username":username1.text.toString(),
          "Email":email1.text.toString(),
          "city":city1.text.toString(),
          "Image":spaURL.toString(),
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AnimatedDrawer()))
            .onError(( FirebaseAuthException error, stackTrace) {
          Fluttertoast.showToast(msg: error.message.toString());
        });
      });
    }
    on FirebaseAuthException catch(error){
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  bool _isClick = true;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xFFF4FFEF),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/Logo.png',height: 100,),
            ],
          ),SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                'CHAT.ON',
                style: GoogleFonts.laila(color: Color(0xFF338C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )
            ],
          ),
          _isClick ?
          Expanded(
            child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child : Positioned(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: h * 0.480,
                                width: w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(70),
                                      bottomLeft: Radius.circular(30),
                                      topRight: Radius.circular(200)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF9AF6B9),
                                        offset: Offset(1.0, 0.5),
                                        blurRadius: 20.0,
                                        spreadRadius: 0.0)
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, top: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isClick = !_isClick;
                                              });
                                            },
                                            child: Container(
                                              child: Text(
                                                'Signup',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 30, right: 30, top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: h * 0.480,
                              width: w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(275),
                                    bottomRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF9AF6B9),
                                      offset: Offset(1.0, 0.5),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0)
                                ],
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 10, right: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Login',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.003,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.18,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.003,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                color: Colors.green.shade400,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 60, left: 50, right: 20),
                                      child: TextFormField(
                                        controller: email,
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            suffixIcon: Icon(
                                              Icons.email_outlined,
                                              color: Color(0xFFADEAA0),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 50, right: 20),
                                      child: TextFormField(
                                        controller: password,
                                        decoration: InputDecoration(
                                            hintText: 'Password',
                                            suffixIcon: Icon(
                                              Icons.password_outlined,
                                              color: Color(0xFFADEAA0),
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.6,
                              height:
                              MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                  color:  Color(0xFF16380D),
                                  borderRadius: BorderRadius.circular(30)),
                              child: GestureDetector(
                                onTap: () async {
                                  _handleContainerTap();
                                  login();
                                  // SharedPreferences sh = await SharedPreferences.getInstance();
                                  // sh.setString("user_email", email.text);


                                  // // sh.getString("user_email");
                                  // print("----------${sh.getString("user_email")}");
                                  // print("------------------------------------------------------------------------------");
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator(color: Colors.greenAccent,):
                                Text(
                                  "Login",
                                  style: GoogleFonts.laila(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ],
                  )
                ]
            ),
          ):
          Expanded(
            child: Stack(children: [
              Positioned(
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 30, right: 30, top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: h * 0.480,
                          width: w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(200),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF9AF6B9),
                                  offset: Offset(1.0, 0.5),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 10, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isClick = !_isClick;
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60, left: 20, right: 20),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Emailllll',
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFFAEDEE8),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Passworddddd',
                                        prefixIcon: Icon(
                                          Icons.password_outlined,
                                          color: Color(0xFFAEDEE8),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 30, right: 30, top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: h * 0.600,
                          width: w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                topRight: Radius.circular(275)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF9AF6B9),
                                  offset: Offset(1.0, 0.5),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 10, top: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Signup',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.003,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.003,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            color:  Colors.green.shade400,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: (){profile_image();},
                                        child: CircleAvatar(radius: 40,backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg',),backgroundColor: Colors.greenAccent,)),
                                    SizedBox(height: 10,),
                                    Text('Profile Image',style: GoogleFonts.laila(fontSize: 15),)
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 50),
                                  child: TextFormField(
                                    controller: username1,
                                    decoration: InputDecoration(
                                        hintText: 'Username',
                                        suffixIcon: Icon(
                                          Icons.drive_file_rename_outline,
                                          color: Color(0xFFADEAA0),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 50),
                                  child: TextFormField(
                                    controller: email1,
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        suffixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFFADEAA0),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 50),
                                  child: TextFormField(
                                    controller: city1,
                                    decoration: InputDecoration(
                                        hintText: 'City',
                                        suffixIcon: Icon(
                                          Icons.location_city_outlined,
                                          color: Color(0xFFADEAA0),
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 50),
                                    child: TextFormField(
                                      controller: password1,
                                      decoration: InputDecoration(
                                          hintText: 'Password',
                                          suffixIcon: Icon(
                                            Icons.password_outlined,
                                            color: Color(0xFFADEAA0),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 490),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height:
                          MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Color(0xFF16380D),
                              borderRadius: BorderRadius.circular(30)),
                          child: GestureDetector(
                            onTap: (){
                              _handleContainerTap();
                              SingUp();
                            },
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.greenAccent,):
                            Text(
                              "Sign up",
                              style: GoogleFonts.laila(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
