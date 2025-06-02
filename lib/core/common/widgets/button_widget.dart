import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({super.key, required this.buttonText, required this.styleText, this.imagePath, this.navigate});

  final String buttonText;
  final TextStyle styleText;
  final String? imagePath;
  final Navigator? navigate;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  get childText => null;

  get navigate => null;


  @override
  Widget build(BuildContext context) {
   final screenHeight = MediaQuery.of(context).size.height;
   final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: navigate,
      child: Container(
        height: screenHeight * 0.066,
        width: screenWidth * 0.7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey.shade300
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Wrap content only
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (widget.imagePath != null) ...[
              Image.asset(widget.imagePath!, height: screenHeight * 0.04,),
              const SizedBox(width: 8),
          ],
            Text(widget.buttonText, style: widget.styleText
            ),
        ])

      ),
    );
  }
}
