import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key, required this.editingController, required this.firstIcon, this.lastIcon, required this.textLabel});
  final TextEditingController editingController;
  final Icon firstIcon;
  final Icon? lastIcon;

  final String textLabel;


  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: TextField(
        controller: editingController,
        decoration: InputDecoration(
          prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              firstIcon,
              const VerticalDivider(
                color: Colors.black,
                thickness: 2,
                width: 10,
              ),
            ],
          ),
          suffixIcon: lastIcon,
          labelText: textLabel,
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2)
          )
        ),
      ),
    );
  }
}