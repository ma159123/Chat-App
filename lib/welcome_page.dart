import 'package:chat_app/register/social_register_screen.dart';
import 'package:chat_app/social_login/LoginScreen.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
         children:  [
          const SizedBox(width: 135.0,height: 150,child: Image(image: AssetImage('assets/images/chat.png'),)),
          const SizedBox(height: 10.0,),
           const Text('ChatMe',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20.0,),
           MaterialButton(minWidth: 200,color: Colors.orange,onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatLoginScreen()));
           },child:const Text('Login',style: TextStyle(color: Colors.white,),) ,),
           MaterialButton(minWidth: 200,color:Colors.indigo,onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRegisterScreen()));
           },child:const Text('Register',style: TextStyle(color: Colors.white,fontSize: 20.0,),) ,),

         ],
        ),
      ),
    );
  }
}
