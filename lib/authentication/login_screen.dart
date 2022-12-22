import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminEmail = "";
  String adminPassword = "";

  allowAdminToLogin() async
   {
     SnackBar snackBar= const SnackBar(
       content: Text(
         "Checking Credentionals, Please wait..",
         style: TextStyle(
           fontSize: 36,
           color:  Colors.black,
         ),

       ),
       backgroundColor: Colors.teal,
       duration: Duration(seconds:5),
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      User? currentAdmin;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
      ).then((fAuth)
      {
        //success login
         currentAdmin = fAuth.user;
      }).catchError((onError)
      {
        //display error message
        final snackBar= SnackBar(
          content: Text(
            "Error Ocured: " + onError.toString(),
            style: const TextStyle(
              fontSize: 36,
              color:  Colors.black,
            ),

          ),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds:5),
            );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

      if(currentAdmin != null)
      {
        await FirebaseFirestore.instance
            .collection("admin")
            .doc(currentAdmin!.uid)
            .get().then((snap)
        {
             if(snap.exists)
             {
             Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
             }
             else
             {
               SnackBar snackBar= const SnackBar(
                 content: Text(
                   "No Record Found, You are not an admin.",
                   style:  TextStyle(
                     fontSize: 36,
                     color:  Colors.black,
                   ),

                 ),
                 backgroundColor: Colors.teal,
                 duration:  Duration(seconds:5),
               );
               ScaffoldMessenger.of(context).showSnackBar(snackBar);
             }

             });

      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
           Center(
             child: Container(
               width: MediaQuery.of(context).size.width * .5,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children:[
                   //image
                   Image.asset(
                    "images/admin.png"
                   ),

                   //email text field
                   TextField(
                     onChanged: (value)
               {
                 adminEmail = value;
               },
                     style: TextStyle(fontSize: 16, color: Colors.black),
                     decoration: const InputDecoration(
                       enabledBorder: OutlineInputBorder(
                         borderSide: BorderSide(
                           color: Colors.teal,
                           width: 2,
                         )
                       ),
                       focusedBorder: OutlineInputBorder(
                     borderSide: BorderSide(
                     color: Colors.tealAccent,
                       width: 2,
                     )
                   ),
                       hintText: "Type your Email",
                       hintStyle: TextStyle(color: Colors.grey),
                       icon: Icon(
                         Icons.email,
                         color: Colors.teal,
                       ),
                     ),
                   ),

                   SizedBox( height: 15,),
                   //password text field
                   TextField(
                     onChanged: (value)
                     {
                       adminPassword = value;
                     },
                     obscureText: true,
                     style: TextStyle(fontSize: 16, color: Colors.black),
                     decoration: const InputDecoration(
                       enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                             color: Colors.teal,
                             width: 2,
                           )
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                             color: Colors.tealAccent,
                             width: 2,
                           )
                       ),
                       hintText: "Type your Password",
                       hintStyle: TextStyle(color: Colors.grey),
                       icon: Icon(
                         Icons.admin_panel_settings,
                         color: Colors.teal,
                       ),
                     ),
                   ),

                   SizedBox(height: 30,),
                   //button
                   ElevatedButton(
                     onPressed: ()
               {
                    allowAdminToLogin();
               },
                     style: ButtonStyle(
                       padding: MaterialStateProperty.all( const EdgeInsets.symmetric(horizontal: 100,vertical: 20)),
                       backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                       foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                     ),
                     child: const Text(
                       "Login",
                       style: TextStyle(
                         color: Colors.black,
                         letterSpacing: 2,
                         fontSize: 16,
                       ),
                     ),
                   ),

                 ],
               ),
             ),
           )
        ],
      ),
    );
  }
}
