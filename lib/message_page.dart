import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

class MessagingPage extends StatefulWidget {
  String? id;

  @override
  _MessagingPageState createState() => _MessagingPageState();

  MessagingPage(this.id);
}

class _MessagingPageState extends State<MessagingPage> {
    List<ChatMessage> messages = [];
  TextEditingController _messageController = TextEditingController();

  // bool isCurrentUser = false ;

    File? therapist_photo;

    Future<void> profile_image() async {
      XFile? xf = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xf != null) {
        setState(() {
          therapist_photo=File(xf.path);
        });
      }
    }

  Future<void> _sendMessage() async {
    String messageText = _messageController.text.trim();
    if(therapist_photo != null){
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("Image/${DateTime.now()}");
      UploadTask uploadTask = ref.putFile(therapist_photo!);
      await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
      String spaURL = await ref.getDownloadURL();
      print('Download URL: $spaURL');

      FirebaseFirestore.instance.collection('Message').add(
          {'Message':"",
            'Sender':FirebaseAuth.instance.currentUser!.email.toString(),
            'recipient': remail.toString(),
            "img_url":spaURL.toString(),
            'Time': DateTime.now()
          }).then((value) {
            setState(() {
              therapist_photo = null;
            });
      });
    }else{
      if (messageText.isNotEmpty) {

        FirebaseFirestore.instance.collection('Message').add(
            {'Message':_messageController.text.toString(),
              'Sender':FirebaseAuth.instance.currentUser!.email.toString(),
              'recipient': remail.toString(),
              "img_url":"",
              'Time': DateTime.now()
            });
        _messageController.clear();
      }else
      {
        Fluttertoast.showToast(msg: "can't send Empty Message ");
      }
    }

  }
    String? img,name,remail;
    getusers() async {
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Users').doc(widget.id).get();
      setState(() {
        img = ds.get('Image');
        name = ds.get('Username');
        remail = ds.get('Email');

      });
    }
    @override
    void initState() {
      // TODO: implement initState
      getusers();
      print(img);
      print(name);
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD3FDDD),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
                    child: Text(name.toString(),style: GoogleFonts.laila(),),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10,top: 2,bottom: 1),
          child: CircleAvatar(radius:10,backgroundImage: NetworkImage(img.toString()),),
        ),
        backgroundColor: Color(0xFFD3FDDD),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(

          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:FirebaseFirestore.instance.collection('Message')
                      .where('Sender',isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
                      .where('recipient',isEqualTo: widget.id.toString())
                      .orderBy('Time')
                      .snapshots(),
                    builder: (context, snapshot) {
                      // if(snapshot.data!.docs.isEmpty){
                      //   return Center(child: Text("No chat found"),);
                      // }
                      if(snapshot.hasError){
                        return Center(child: Text("Error Occured!"),);
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }

                      List<DocumentSnapshot> currentusermessages = snapshot.data!.docs;
                      return StreamBuilder<QuerySnapshot>(
                          stream:FirebaseFirestore.instance.collection('Message')
                              .where('Sender',isEqualTo: widget.id.toString())
                              .where('recipient',isEqualTo:FirebaseAuth.instance.currentUser!.email.toString() )
                              .orderBy('Time')
                              .snapshots(),
                        builder: (context, rsnapshot) {
                          if(snapshot.hasError){
                            return Center(child: Text("Error Occured!"),);
                          }
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }

                            List<DocumentSnapshot> recievermessages = rsnapshot.data!.docs;
                            List<DocumentSnapshot> allmesssages = currentusermessages + recievermessages;
                            allmesssages.sort((a, b) => (a['Time'] as Timestamp).compareTo(b['Time'] as Timestamp));
                          return ListView.separated(
                            itemCount: allmesssages.length,
                            itemBuilder: (context, index) {
                              bool isCurrentUser = allmesssages[index].get('Sender') ==
                              FirebaseAuth.instance.currentUser!.email.toString();

                              bool isMe = allmesssages[index].get('Sender') ==
                                  FirebaseAuth.instance.currentUser!.email.toString();

                              return
                                isMe ?
                                Column(
                                crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                                children: [
                                 Padding(
                                   padding: const EdgeInsets.only(right: 10),
                                   child: Stack(
                                     children: [
                                       // Container(width: 250,
                                       //   height: 40,
                                       //   decoration: BoxDecoration(
                                       //     color: Colors.greenAccent,
                                       //       border: Border.all(color: Color(0xFF0B3D0C),width: 3,)
                                       //   ),
                                       // ),
                                       allmesssages[index].get('Message')== null || allmesssages[index].get('Message')== ""?
                                       Container(
                                         width:250,
                                         height: 250,
                                         decoration: BoxDecoration(
                                             border: Border.all(color: Color(0xFF0B3D0C),width: 1,),

                                             image: DecorationImage(image: NetworkImage(allmesssages[index].get('img_url')),fit: BoxFit.cover,)
                                         ),
                                       ):
                                       Container(
                                         width: 250,
                                         height: 40,
                                         decoration: BoxDecoration(
                                           color: Color(0xFFCEEFD8),
                                             border: Border.all(color: Color(0xFF4FBC87),width: 1,),
                                             // borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))
                                         ),
                                         child: Padding(
                                           padding: const EdgeInsets.only(left: 10),
                                           child: Row(
                                             children: [
                                               Text(allmesssages[index].get('Message')),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 )
                                ],
                              ):
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                    ],
                                  ),
                                );
                            }, separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(height: 10,);
                          },
                          );
                        }
                      );
                    }
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',prefixIcon: GestureDetector(
                              onTap: (){profile_image();},
                              child: Icon(Icons.add)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.greenAccent)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: _sendMessage,
                        child: Icon(Icons.send,color: Colors.greenAccent,),
                      ),
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
