import 'package:Chat.On/login-signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isTextFieldVisible = false;

  TextEditingController email = TextEditingController();
  final _auth =  FirebaseAuth.instance;

  resetpassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: email.text).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Link Sent"),
              content: Text(
                "Password reset link has been sent to your email.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            loginpage(),
                      ),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }).onError(( FirebaseAuthException error, stackTrace) {
        Fluttertoast.showToast(msg: error.message.toString());
      });

    } on FirebaseAuthException catch(error)
    {
      Fluttertoast.showToast(msg: 'Enter Write Email' + error.toString());

    }
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        _isTextFieldVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Set your desired background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset('assets/img/Logo.png',height: 100,width: 100,),
              SizedBox(height: 20,),
              Text(
                'CHAT.ON',
                style: GoogleFonts.laila(color: Color(0xFF338C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Forgot Password',style: GoogleFonts.laila(fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                ),
              ),
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _isTextFieldVisible
                    ? SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, -1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    height: 70,
                    width: 300,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter your email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox(),
              ),
              SizedBox(height: 20),
              Container(
                height:MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.green, Color(0xFFD3FDDD)])),
                child: Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      resetpassword();},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child:Text('Save',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
  ));
}
