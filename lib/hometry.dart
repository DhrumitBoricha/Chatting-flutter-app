import 'package:Chat.On/Forgot_password.dart';
import 'package:Chat.On/edit_profile.dart';
import 'package:Chat.On/filtered_users.dart';
import 'package:Chat.On/message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Contect As.dart';
import 'login-signup.dart';
class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({Key? key}) : super(key: key);

  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderRadiusAnimation;

  bool _isDrawerOpen = false;

  String? uname;
  String? uemail;
  String? profile_img;
  final _fstore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List name = [];
  List users = [];
  List city = [];
  List filtercity = [];
  // List customcity = ["https://images.pexels.com/photos/1563256/pexels-photo-1563256.jpeg?cs=srgb&dl=pexels-ricky-esquivel-1563256.jpg&fm=jpg","https://images.pexels.com/photos/1563256/pexels-photo-1563256.jpeg?cs=srgb&dl=pexels-ricky-esquivel-1563256.jpg&fm=jpg"];
  List img = [];
  List docid = [];

  getudetails() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.email.toString()).get();
    setState(() {
      profile_img = ds.get('Image');
      uemail = ds.get('Email');
      uname = ds.get('Username');
    });
  }
  final firestoreInstance = FirebaseFirestore.instance;


  getusers() async {
    filtercity.clear();
    QuerySnapshot qs = await FirebaseFirestore.instance.collection('Users').get();
    for(int i =0;i< qs.docs.length;i++){
      setState(() {
        users.add(qs.docs[i].get('Email'));
      });
    }
    if(users.contains(_auth.currentUser!.email.toString())){
      setState(() {
        users.remove(_auth.currentUser!.email.toString());
      });
    }
    for(int i =0;i< users.length;i++){
      DocumentSnapshot ds =await _fstore.collection('Users').doc(users[i]).get();
      setState(() {
        name.add(ds.get('Username'));
        city.add(ds.get('city'));
        img.add(ds.get('Image'));
        docid.add(ds.get('Email'));
      });

    }

    city.forEach((element) {
      if(filtercity.contains(element)){
      }else{
        filtercity.add(element);
      }
    });
  }





  @override
  void initState() {
    super.initState();
    getudetails();
    getusers();
    // getcities();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_animation);
    _borderRadiusAnimation = Tween<double>(begin: 1.0, end: 20.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_isDrawerOpen) {
      _toggleDrawer();
      return false;
    }
    return true;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    List<IconData> iconList = [
      Icons.home_outlined,
      Icons.account_circle_outlined,
      Icons.lock_outline,
      Icons.info_outline,
      Icons.logout_outlined,
    ];
    List title = ['Home','Edit Profile','Change Password','Help','Logout'];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_isDrawerOpen) {
                _toggleDrawer();
              }
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                    child: Scaffold(
                      backgroundColor: Color(0xFFD3FDDD),
                      body: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: ()  {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> profile()));
                                      _toggleDrawer();
                                    },
                                    child:Container(
                                      width: w*0.120,
                                      height: h*0.051,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.person_2_outlined,
                                          color: Colors.green,
                                          size: 25,
                                        ),
                                      ),
                                    )

                                ),
                                Spacer(),
                                Text(uname.toString(),style: GoogleFonts.laila(fontSize: 20),),
                                Spacer(),
                                CircleAvatar(radius: 25,backgroundImage: NetworkImage(profile_img.toString()),),

                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Expanded(
                            child: Container(
                              height: h*0.9,
                              width: w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow:  [BoxShadow(
                                      color: Colors.black45,offset: Offset.zero,blurRadius: 10,spreadRadius: 0.3
                                  )]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20),
                                    child: Container(
                                      height: h*0.07,
                                      child: TextFormField(
                                        // controller: email1,
                                        decoration: InputDecoration(
                                            hintText: 'Search',enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black), //<-- SEE HERE
                                        ),
                                            prefixIcon: Icon(
                                              Icons.search_sharp,
                                              color: Color(0xFFA5EC84),
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       height: 150,
                                  //       width: w,
                                  //       child: ListView.separated(scrollDirection: Axis.horizontal,itemBuilder: (BuildContext context, int index) {
                                  //         return  Column(
                                  //           children: [
                                  //             GestureDetector(
                                  //               onTap:(){
                                  //                 Navigator.push(context, MaterialPageRoute(builder: (context) => filtered_users(filtercity[index]),));
                                  //               },
                                  //               child: Container(
                                  //                   width: w*0.2,
                                  //                   height: 80,
                                  //                   decoration: BoxDecoration(
                                  //                     shape: BoxShape.circle,
                                  //                     image: DecorationImage(image: NetworkImage("https://images.pexels.com/photos/1563256/pexels-photo-1563256.jpeg?cs=srgb&dl=pexels-ricky-esquivel-1563256.jpg&fm=jpg"))
                                  //                   ),
                                  //                   ),
                                  //             ),
                                  //             Text(filtercity[index].toString(),style: TextStyle(fontSize: 10),)
                                  //           ],
                                  //         );
                                  //       },
                                  //         itemCount: filtercity.length, separatorBuilder: (BuildContext context, int index) {
                                  //         return SizedBox(width: 10,);
                                  //       },),
                                  //     ),
                                  //   ],
                                  // ),
                                  Expanded(
                                      child: Container(
                                        height: h,
                                        width: w,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10,left: 10),
                                          child: ListView.separated(
                                            itemBuilder: (BuildContext context, int index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>MessagingPage(docid[index].toString())));
                                                  // Navigator.push(context,MaterialPageRoute(builder: (context)=> ChattingPage(docid[index])));
                                                },
                                                child: Container(
                                                  height: h*0.110,
                                                  width: w,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20,),border: Border.all(color: Colors.black)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(radius: 30,backgroundImage: NetworkImage(img[index].toString())),
                                                        SizedBox(width: 20,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(name[index].toString(),style: GoogleFonts.laila(fontSize: 20)),
                                                            SizedBox(height: 5,),
                                                            Text(city[index].toString(),style: GoogleFonts.laila(fontSize: 15)),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );

                                            }, itemCount: name.length,
                                            separatorBuilder: (BuildContext context, int index) {
                                            return SizedBox(height: 10,);
                                          },
                                          ),
                                        ),
                                      )
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
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                width: 260.0,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: Drawer(
                    backgroundColor: Color(0xFFFFFFFF),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child:
                          Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10,),
                              child: Row(
                                children: [
                                  Image.asset('assets/img/Logo.png',height: 100,width: 100,)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    uemail.toString(),
                                    style: GoogleFonts.laila(color: Color(
                                        0xFF22690F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            )
                          ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
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
                                   _toggleDrawer();
                                  }else if(index == 1)
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                                  }else if(index == 2){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                  }else if(index == 3){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));
                                  }else if(index == 4){
                                    try {
                                      await FirebaseAuth.instance.signOut();


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
                                        Text(title[index],style: GoogleFonts.laila(fontSize: 15),)
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
