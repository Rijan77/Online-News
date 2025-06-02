
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/screens/home.dart';

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
        
            Padding(
              padding:  EdgeInsets.only(top: screenHeight * 0.1, left: screenWidth*0.04, right: screenWidth *0.04),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding:  EdgeInsets.only(top: screenHeight * 0.013, left: screenWidth * 0.02 ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(Icons.email_rounded, size: 27,),
                            SizedBox(
                              height:screenHeight * 0.04,
                              child: const VerticalDivider(
                                color: Colors.black54,
                                thickness: 1.5,
                                width: 15,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  labelText: "Email Address",
                  enabledBorder: const OutlineInputBorder(
        
                  ),
                  focusedBorder: const OutlineInputBorder( borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth*0.04, right: screenWidth *0.04),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding:  EdgeInsets.only(top: screenHeight * 0.001, left: screenWidth* 0.02),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(Icons.lock, size: 29,),
                        SizedBox(
                          height: screenHeight * 0.04,
                          child: const VerticalDivider(
                            color: Colors.black54,
                            thickness: 1.7,
                            width: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                  suffixIcon: const FaIcon(Icons.remove_red_eye),
                  labelText: "Password",
                  enabledBorder: const OutlineInputBorder(
        
                  ),
                  focusedBorder: const OutlineInputBorder( borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                ),
              ),
            ),

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
            
           InkWell(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
             },
             child: Container(
               height: screenHeight * 0.066,
               width: screenWidth * 0.7,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.blueGrey.shade300
               ),
               child:  const Center(child: Text("Login", style: TextStyle(
                 fontSize: 25,
                 fontWeight: FontWeight.w600
               ),)),
             ),
           ),
            SizedBox(height: screenHeight*0.01,),

            const Text("OR", style: TextStyle(
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
                  const Text("Continue with Google", style: TextStyle(
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
