// image_picker_page.dart
import 'package:applikasi_pesanan_makanan/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  Uint8List? _image;
  final PermissionService _permissionService = PermissionService();

  Future<void> _pickImage() async {
    bool cameraPermissionGranted = await _permissionService.requestCameraPermission();
    bool storagePermissionGranted = await _permissionService.requestStoragePermission();

    if (cameraPermissionGranted && storagePermissionGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() async {
          _image = Uint8List.fromList(await pickedFile.readAsBytes());
        });
      }
    } else {
      // Handle permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissions not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.memory(_image!) : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}
