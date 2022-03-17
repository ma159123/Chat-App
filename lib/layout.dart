
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_login/LoginScreen.dart';
import 'chat_login/cubit/cubit.dart';
import 'chat_login/cubit/states.dart';
import 'componants.dart';

class Layout extends StatelessWidget {
  Layout({Key? key}) : super(key: key);
  var messageController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser!.email;
  String? messageText;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('ChatMe'),
          actions: [
            TextButton(
                onPressed: () {
                  LoginCubit.get(context).userLogout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatLoginScreen()),
                      (route) => false);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              messageStreamBuilder(),
              Row(
                children: [
                  SizedBox(
                    width: 325.0,
                    child: defaultTextFormField(
                      controller: messageController,
                      type: TextInputType.emailAddress,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'enter your message';
                        }
                        return null;
                      },
                      // onChange: (value){
                      //   messageText=value;
                      // },
                      hintText: 'write message...',
                      prefix: Icons.email_outlined,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                          LoginCubit.get(context).addData(message: messageController.text, userEmail: user!,time: FieldValue.serverTimestamp(),);
                          messageController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 35.0,
                        color: Colors.indigo,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageStreamBuilder()=>StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user-chat')
          .orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<Widget> messageWidgets = [];
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('message');
          //print(messageText);
          final messageSender = message.get('user');
          final currentUser=user;
          final messageWidget =
          messageItem(text: messageText, user: messageSender, isMe: currentUser==messageSender);
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageWidgets,
          ),
        );
      });
  Widget messageItem({required String text, required String user,required bool isMe}) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            Text(
              user,
              style: const TextStyle(fontSize: 12.0,color: Colors.black54),

            ),
            Material(
              color:isMe? Colors.blue[800]:Colors.black54,
                elevation: 5,
                borderRadius:isMe? const BorderRadius.only(
                  topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                   bottomRight: Radius.circular(30),
                ):const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                  child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
                ))
          ],
        ),
  );
}
