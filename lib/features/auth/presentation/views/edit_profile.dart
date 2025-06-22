import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:news_app/core/common/widgets/button_widget.dart";
import "package:news_app/core/common/widgets/text_field_widget.dart";

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController emailControl = TextEditingController();

  final userEmail = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
       leading: IconButton(onPressed: (){
         return Navigator.pop(context);
       }, icon: Icon(Icons.arrow_back_sharp,size: 35,)),
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: SingleChildScrollView(
        child: Flexible(
            child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Column(
            children: [
              Card(
                elevation: 4,
                color: Colors.brown.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 140),
                        child: Text(
                          "Profile Information",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                          editingController: nameControl,
                          firstIcon: Icon(Icons.person),
                          textLabel: "Full Name"),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                          editingController: emailControl,
                          hintText: userEmail?.email?? "Email not fount",
                          firstIcon: Icon(Icons.email),
                          textLabel: "Email Address"),
                      SizedBox(
                        height: 30,
                      ),
                      ButtonWidget(
                        buttonText: "Save Change",
                        styleText: TextStyle(fontSize: 20),
                        onTap: () {},
                        backgroundColor: Colors.orangeAccent.shade200,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Card(
                elevation: 4,
                color: Colors.brown.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 170),
                        child: Text(
                          "Password Reset",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFieldWidget(
                          editingController: nameControl,
                          firstIcon: Icon(Icons.email),
                          textLabel: "Email for Reset Link"),
                      SizedBox(
                        height: 30,
                      ),
                      ButtonWidget(
                        buttonText: "Send Reset Link",
                        styleText: TextStyle(fontSize: 20),
                        onTap: () {},
                        backgroundColor: Colors.red.shade300,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
