import 'package:flutter/material.dart';

class Try extends StatefulWidget {
  const Try({super.key});

  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 10,
            pinned: true,
            backgroundColor: Colors.black,
            title: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "rijan__7",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ],
            ),
          ),
          // Top section with profile info
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    child: Row(
                      children: [],
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/736x/84/a0/6b/84a06bfa43baddf9108b9a80a3a3f05d.jpg")),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Rijan Acharya",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    "hjajkldjlkamndlkjflkdjj" * 10,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),

          // Pinned top Row
          SliverAppBar(
            expandedHeight: 10,
            pinned: true,
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.branding_watermark_sharp),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.video_settings),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.supervised_user_circle_rounded),
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // Scrolling content below
          SliverToBoxAdapter(
            child: Column(
              children: [_buildContainer()],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildContainer() {
  return Column(
    children: List.generate(
      5,
      (index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 400,
          width: double.infinity,
          color: Colors.orange,
        ),
      ),
    ),
  );
}
