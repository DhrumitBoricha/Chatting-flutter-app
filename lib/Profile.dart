import 'dart:io';


import 'package:Chat.On/Forgot_password.dart';
import 'package:Chat.On/edit_profile.dart';
import 'package:Chat.On/hometry.dart';
import 'package:Chat.On/login-signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  List<IconData> iconList = [
    Icons.home_outlined,
    Icons.account_circle_outlined,
    Icons.lock_outline,
    Icons.info_outline,
    Icons.logout_outlined,
  ];
  List title = ['Home','Edit Profile','Change Password','Help','Logout'];

  String? uname;
  String? image;
  getudetails() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.email.toString()).get();
    setState(() {
      uname = ds.get('Username');
      image = ds.get('Image');

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getudetails();
    print(uname.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final h  =MediaQuery.of(context).size.height;
    final w  =MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        title:
        Text('PROFILE',style: GoogleFonts.laila(color: Colors.black,fontWeight: FontWeight.bold),)
        ,centerTitle: true,backgroundColor: Color(0xFFD3FDDD),

      ),
      body: Stack(
        children: [
          Positioned(child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    Container(
                      height: h*0.350,
                      width: w,
                      color: Color(0xFFD3FDDD),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           GestureDetector(
                               onTap: (){},
                               child: CircleAvatar(radius: 100,backgroundImage: NetworkImage(image.toString()),))
                         ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          ),
          Positioned(
            top: 250,
            child: Container(
              height: h*0.9,
              width: w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child:  Text(uname.toString(),style: GoogleFonts.laila(color: Colors.black,fontWeight: FontWeight.bold),)
                      ),
                    ],
                  ),SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                      height: h*0.5,
                      width: w,
                      child: ListView.separated(itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            if(index ==0)
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedDrawer()));
                            }else if(index == 1)
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                            }else if(index == 2){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                            }else if(index == 3){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                            }else if(index == 4){
                              try {
                                await FirebaseAuth.instance.signOut();

                                SharedPreferences sh = await SharedPreferences.getInstance();
                                sh.remove("user_email");
                                print("---------------------------------logout---------------------------------------");
                                print("--------sharedprefrence clear ---${sh.getString("user_email")}");


                                Navigator.push(context, MaterialPageRoute(builder: (context) => loginpage()));
                                Fluttertoast.showToast(msg: 'Logout');
                              } catch (e) {
                                print('Error signing out: $e');
                              }                            }
                          },
                          child: Column(
                            children: [
                            Row(
                              children: [
                                Icon(iconList[index],size: 30,),
                                SizedBox(width: 20,),
                                Text(title[index],style: GoogleFonts.laila(fontSize: 18),)
                              ],
                            ),
                              SizedBox(height: 20,),
                              Container(
                                height: h*0.001,
                                width: w,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(30)
                                ),
                              )
                            ],
                          ),
                        );
                      }, itemCount: 5, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 15,);
                      },),

                    ),
                  )
                ],
              ),

            ),
          )
        ],
      ),
    );
  }
}

