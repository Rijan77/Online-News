import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              padding: EdgeInsets.only(top: screenHeight * 0.2),
              child: Center(child: Icon(Icons.newspaper_outlined, size: 130, color: Colors.blueGrey,), ),
            ),
            Text("Online News", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600
            ),),
        
            Padding(
              padding:  EdgeInsets.only(top: screenHeight * 0.1, left: screenWidth*0.04, right: screenWidth *0.04),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  enabledBorder: OutlineInputBorder(
        
                  ),
                  focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth*0.04, right: screenWidth *0.04),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
        
                  ),
                  focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                ),
              ),
            ),
            
            SizedBox(height: screenHeight* 0.07,),
            
           Container(
             height: screenHeight * 0.066,
             width: screenWidth * 0.7,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Colors.blueGrey.shade300
             ),
             child:  Center(child: Text("Login", style: TextStyle(
               fontSize: 25,
               fontWeight: FontWeight.w600
             ),)),
           ),
            SizedBox(height: screenHeight*0.01,),

            Text("OR", style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600
            ),),

            SizedBox(height: screenHeight*0.01,),

            Container(
              height: screenHeight * 0.066,
              width: screenWidth * 0.7,
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade300,
                borderRadius: BorderRadius.circular(10)
              ),
              child:  Center(child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("Assets/googlelogo.png", width: 30,)
                  ),
                  Text("Continue with Google", style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              )),
            ),
          ],
        ),
      ),

    );
  }
}
