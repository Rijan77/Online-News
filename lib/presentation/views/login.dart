
import 'package:flutter/material.dart';
import 'package:news_app/presentation/views/registration.dart';
import 'package:news_app/presentation/widgets/button_widget.dart';
import 'package:news_app/presentation/widgets/text_field_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
   final screenHeight = MediaQuery.of(context).size.height;
   final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.14),
              child: const Center(child: Icon(Icons.newspaper_outlined, size: 130, color: Colors.blueGrey,), ),
            ),
            const Text("Online News", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600
            ),),

            SizedBox(height: screenHeight * 0.1,),
            TextFieldWidget(
              firstIcon: const Icon(Icons.email_rounded),
                textLabel: "Email Address",

                editingController: TextEditingController()),
            SizedBox(height: screenHeight * 0.04,),
            TextFieldWidget(
              firstIcon: const Icon(Icons.lock),
                textLabel: "Password",
                lastIcon: const Icon(Icons.remove_red_eye_rounded),
                editingController: TextEditingController()),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth * 0.4, top: screenHeight * 0.01),
              child: const Text("Forgot Password?", style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.black87
              ),),
            ),

            
            SizedBox(height: screenHeight* 0.07,),

           const ButtonWidget(buttonText: "Login", styleText: TextStyle(
             fontSize: 25,
               fontWeight: FontWeight.w600,
           ),),

            SizedBox(height: screenHeight*0.01,),

            const Text("OR", style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600
            ),),

            SizedBox(height: screenHeight*0.01,),

            const ButtonWidget(buttonText: "Continue with Google", styleText: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),
              imagePath: ("Assets/googlelogo.png"),

            ),
            SizedBox(height: screenHeight * 0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not Register Yet?", style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600
                ),),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Registration()));
                }, child: Text("Sign Up", style: TextStyle(
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
