import 'dart:io';
import 'package:Chat.On/hometry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  String? selected_docid;
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();

  TextEditingController city = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<void> _saveChanges() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Image/${email.text}");
    UploadTask uploadTask = ref.putFile(therapist_photo!);
    await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
    String spaURL = await ref.getDownloadURL();
    print('Download URL: $spaURL');
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "Image":spaURL.toString(),
      "Username":username.text.toString(),}
    ).then((value) {Navigator.push(context, MaterialPageRoute(builder: (context)=>AnimatedDrawer()));
    });
  }

  bool _isLoading = false;
  void _handleContainerTap() {
    setState(() {
      _isLoading = true;
    });
    // Simulating a loading process
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  File? therapist_photo;

  Future<void> profile_image() async {
    XFile? xf = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xf != null) {
      setState(() {
        therapist_photo=File(xf.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        title:
        Text('EDIT PROFILE',style: GoogleFonts.laila(color: Colors.black,fontWeight: FontWeight.bold),)
        ,centerTitle: true,backgroundColor: Color(0xFFD3FDDD),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    profile_image();
                  },
                    child: Column(
                      children: [
                        CircleAvatar(radius: 100,backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg',),backgroundColor: Colors.greenAccent,),
                        Text('Profile Image',style: GoogleFonts.laila(fontSize: 20),)
                      ],
                    )),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Username',style: GoogleFonts.laila(fontSize: 20,color: Colors.black, ),)
                    ],
                  ),
                ),SizedBox(height: 10,),
                Container(
                  height: h*0.07,
                  width: w*0.9,
                  child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                        hintText: 'Enter Name',enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                        suffixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          color: Colors.green,
                        )),
                  ),
                ),

              SizedBox(height: 10,),
                // Container(
                //   height: h*0.07,
                //   child: TextFormField(
                //     // controller: username,
                //     decoration: InputDecoration(
                //         hintText: 'Enter Password',enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //           width: 1, color: Colors.black), //<-- SEE HERE
                //     ),
                //         prefixIcon: Icon(
                //           Icons.drive_file_rename_outline,
                //           color: Colors.green,
                //         )),
                //   ),
                // ),
                SizedBox(height: 16.0),

                SizedBox(height: 24.0),
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
                        _handleContainerTap();
                        _saveChanges();},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.greenAccent,): Text('Save',style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
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

