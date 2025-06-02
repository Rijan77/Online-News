
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/presentation/views/login.dart';
import 'package:news_app/presentation/widgets/button_widget.dart';
import 'package:news_app/presentation/widgets/text_field_widget.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            SizedBox(height: screenHeight*0.02,),
        
            Image.asset("Assets/registrationlogo.png", height: 250,),

            SizedBox(height: screenHeight*0.06,),
        
            TextFieldWidget(
              textLabel: "FullName",
              editingController: TextEditingController(),
              firstIcon: Icon(Icons.person),),

            SizedBox(height: screenHeight*0.02,),


            TextFieldWidget(
                textLabel: "Email Address",
                editingController: TextEditingController(),
                firstIcon: Icon(Icons.email_rounded))
            ,
            SizedBox(height: screenHeight*0.02,),

            TextFieldWidget(
              textLabel: "Password",
                editingController: TextEditingController(),
                firstIcon: Icon(Icons.lock)),

            SizedBox(height: screenHeight*0.02,),

            TextFieldWidget(
              textLabel: "Confirm Password",
                editingController: TextEditingController(),
                firstIcon: Icon(Icons.lock_reset_sharp, size: 30,),),

            SizedBox(height: screenHeight*0.06,),

            ButtonWidget(buttonText: "Sign Up", styleText: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600

            )),
            SizedBox(height: screenHeight*0.01,),
            Text("Or"),
            SizedBox(height: screenHeight*0.01,),

            ButtonWidget(
                imagePath: "Assets/googlelogo.png",
                buttonText: "Continue with Google", styleText: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600
            )),

            // SizedBox(height: screenHeight*0.02,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have Account?", style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600
                ),),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                }, child: Text("Login", style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),))
              
              ],
            )

          ],
        ),
      ),
    );
  }
}
