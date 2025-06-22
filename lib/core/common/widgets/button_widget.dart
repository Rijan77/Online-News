import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.buttonText,
    required this.styleText,
    this.imagePath,
    required this.onTap,
    this.isLoading,
    this.backgroundColor
  });

  final String buttonText; // What the button should say
  final TextStyle styleText; // Custom text style
  final String? imagePath; // Optional image inside the button
  final bool? isLoading; // Are we loading? show spinner
  final VoidCallback onTap; // What happens when user taps the button
  final Color? backgroundColor;



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return InkWell(
      onTap: isLoading == true? null : onTap, // disable when loading
      child: Container(
        // height: screenHeight * 0.066,
        // width: screenWidth * 0.7,

        height: isPortrait ? screenHeight * 0.066 : screenHeight * 0.14,
        width: isPortrait ? screenWidth * 0.7 : screenWidth * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor ?? Colors.blueGrey.shade300,
        ),
        child: Center(
          child:(isLoading ?? false)?
          SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imagePath != null) ...[
                      Image.asset(
                        imagePath!,
                        height: screenHeight * 0.04,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(buttonText, style: styleText),
                  ],
                ),
        ),
      ),
    );
  }
}
