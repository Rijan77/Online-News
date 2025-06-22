import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/core/common/widgets/button_widget.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitNote() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      setState(() => _isLoading = true);

      final DateTime currentDate = DateTime.now();

      // Simulate save delay
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note submitted successfully!")),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedImage = null;
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload an image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Notes",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_sharp, size: 30),
        ),
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              color: Colors.brown.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Create and share your thoughts or ideas.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView(
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter a title' : null,
                      ),
                      const SizedBox(height: 15),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter description' : null,
                      ),
                      const SizedBox(height: 20),

                      // Image Button
                      ButtonWidget(
                        buttonText: "Select Image",
                        icon: const Icon(Icons.image, color: Colors.white),
                        backgroundColor: Colors.blueGrey,
                        styleText: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        onTap: _pickImage,
                      ),

                      const SizedBox(height: 10),

                      // Image Preview
                      if (_selectedImage != null)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 200,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Submit Button
                      Center(
                        child: ButtonWidget(
                          buttonText: "Submit",
                          isLoading: _isLoading,
                          backgroundColor: Colors.blueGrey,
                          styleText: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          onTap: _submitNote,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
