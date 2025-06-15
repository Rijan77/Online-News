import 'package:flutter/material.dart';
import 'package:news_app/core/common/widgets/button_widget.dart';
import 'package:news_app/core/common/widgets/text_field_widget.dart';

import '../../data/auth/signin_google.dart';

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

    final isPortrait = MediaQuery.of(context).orientation==Orientation.portrait;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
              SizedBox(
              height:isPortrait? screenHeight * 0.02: screenHeight * 0.01,
            ),

            Image.asset(
              "Assets/registrationlogo.png",
              height: isPortrait? 250: 150,
            ),

            SizedBox(
              height: screenHeight * 0.06,
            ),

            TextFieldWidget(
              textLabel: "FullName",
              editingController: TextEditingController(),
              firstIcon: const Icon(Icons.person),
            ),

            SizedBox(
              height: screenHeight * 0.02,
            ),

            TextFieldWidget(
                textLabel: "Email Address",
                editingController: TextEditingController(),
                firstIcon: const Icon(Icons.email_rounded)),
            SizedBox(
              height: screenHeight * 0.02,
            ),

            TextFieldWidget(
                textLabel: "Password",
                editingController: TextEditingController(),
                firstIcon: const Icon(Icons.lock)),

            SizedBox(
              height: screenHeight * 0.02,
            ),

            TextFieldWidget(
              textLabel: "Confirm Password",
              editingController: TextEditingController(),
              firstIcon: const Icon(
                Icons.lock_reset_sharp,
                size: 30,
              ),
            ),

            SizedBox(
              height: screenHeight * 0.06,
            ),

            ButtonWidget(
              buttonText: "Sign Up",
              styleText:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              isLoading: false,
              onTap: () {},
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Text("Or"),
            SizedBox(
              height: screenHeight * 0.01,
            ),

            ButtonWidget(
              imagePath: "Assets/googlelogo.png",
              buttonText: "Continue with Google",
              styleText:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              isLoading: false,
              onTap: () {
                GoogleSignIn().loginWithGoogle(context);
              },
            ),

            // SizedBox(height: screenHeight*0.02,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already Have Account?",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w600),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));
                    },
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
