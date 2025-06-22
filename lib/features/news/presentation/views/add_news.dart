import 'package:flutter/material.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add News",
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
    );
  }
}
