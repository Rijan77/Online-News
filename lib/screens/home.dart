import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Online News", style: TextStyle(
          fontWeight: FontWeight.w700

        ),)),
        backgroundColor: Colors.black12,
      ),
      body: ListView.builder(
        itemCount: 50,
          itemBuilder: (BuildContext context, int index){
            return const ListTile(
              leading: Icon(Icons.newspaper),
              title: Icon(Icons.tv),
            );

          })
    );
  }
}
