import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class filtered_users extends StatefulWidget {
  String? city;

  filtered_users(this.city);

  @override
  State<filtered_users> createState() => _filtered_usersState();
}

class _filtered_usersState extends State<filtered_users> {
  final _fstore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List users =[];
  List name =[];
  List city =[];
  List img =[];
  List docid =[];

  getusers() async {

    for(int i =0;i< users.length;i++){
      QuerySnapshot ds =await _fstore.collection('Users').where('city',isEqualTo:widget.city.toString()).get();
      for(int b = 0;b<ds.docs.length;b++){
        name.clear();
        city.clear();
        img.clear();
        docid.clear();
        setState(() {
          name.add(ds.docs[b].get('Username'));
          city.add(ds.docs[b].get('city'));
          img.add(ds.docs[b].get('Image'));
          docid.add(ds.docs[b].get('Email'));
        });

      }
    }
  }

  cleardata(){
    setState(() {
      name.clear();
      city.clear();
      img.clear();
      docid.clear();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    cleardata();
    getusers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
                height: h,
                width: w,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10,top: 30),
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          print(widget.city);
                          print(name);
                          print(city);
                          print(img);
                          // print(widget.city);

                        },
                        child: Container(
                          height: h*0.110,
                          width: w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20,),border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://images.pexels.com/photos/1563256/pexels-photo-1563256.jpeg?cs=srgb&dl=pexels-ricky-esquivel-1563256.jpg&fm=jpg')),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("name[index].toString()",style: GoogleFonts.laila(fontSize: 20)),
                                    SizedBox(height: 5,),
                                    Text('city[index].toString()',style: GoogleFonts.laila(fontSize: 15)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );

                    }, itemCount: 2,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10,);
                    },),
                ),
              )
          )
        ],
      ),

    );
  }
}
