import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebaseHelper.dart';

var loginUser= FirebaseAuth.instance.currentUser;

class chatPage extends StatefulWidget {
  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();
  final storeMessages = FirebaseFirestore.instance;

  Service service = Service();

  getCurrentUser(){
    final user = auth.currentUser;
    if(user!=null){
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async{
                service.signOut(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
              },
              icon: Icon(Icons.logout)
          )
        ],
        title: Text(loginUser!.email.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 555,
            child: SingleChildScrollView(
              physics: ScrollPhysics(), reverse: true, child: showMessages())),
          Row(
            children: [
              Expanded(
                  child:Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue, width: 0.2)
                      )
                    ),
                    child: TextField(
                      controller: msg,
                      decoration: InputDecoration(
                          hintText: "Enter Message...."
                      ),
                    ),
                  )
              ),
              IconButton(
                  onPressed:(){
                    if(msg.text.isNotEmpty){
                      storeMessages.collection("Messages").doc().set({
                        "messages":msg.text.trim(),
                        "user":loginUser!.email.toString(),
                        "time":DateTime.now(),
                      });
                      msg.clear();
                    }

                  } ,
                  icon: Icon(Icons.send))
            ],
          ),

        ],
      ),
    );
  }
}

class showMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Messages").orderBy("time").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          physics: ScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true, primary: true, itemBuilder: (context, i){

          QueryDocumentSnapshot x = snapshot.data!.docs[i];
          return ListTile(
            title: Column(
              crossAxisAlignment: loginUser!.email == x['user']?CrossAxisAlignment.end:CrossAxisAlignment.start ,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color:loginUser!.email==x['user']? 
                    Colors.lightBlueAccent.withOpacity(0.2): 
                    Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(x['messages']),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            "User:" + x['user'],
                          style: TextStyle(fontSize: 13,
                              color: Colors.lightGreen),
                        )
                      ],
                    )
                )
              ],
            )
          );
        });
      },
    );
  }
}
