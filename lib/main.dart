import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() {
  runApp(PhotoPickerApp());
}

class PhotoPickerApp extends StatefulWidget {
  @override
  _PhotoPickerAppState createState() => _PhotoPickerAppState();
}

class _PhotoPickerAppState extends State<PhotoPickerApp> {
  bool isDarkMode = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _retrieveThemePreference();
  }

  void _retrieveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text('Photo Picker & Theme Switcher')),
        body: Container(
          color: isDarkMode ? Colors.black : Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectImage,
                child: Text("Select a Photo"),
              ),
              SizedBox(height: 20),
              selectedImage != null
                  ? Image.file(selectedImage!, height: 200, width: 200)
                  : Text("No image selected", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isDarkMode ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) => _toggleThemeMode(),
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
