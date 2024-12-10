import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class ImagePickerComponent extends StatefulWidget {
  const ImagePickerComponent({Key? key}) : super(key: key);

  @override
  _ImagePickerComponentState createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  Future<String?> _convertImageToBase64(File image) async {
  try {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    debugPrint('Imagen en Base64: $base64Image');
    return base64Image; // Devolvemos la cadena Base64
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error al convertir imagen a Base64: $e',
          style: const TextStyle(color: AppColors.lightGray),
        ),
        backgroundColor: AppColors.errorColor,
      ),
    );
    return null;
  }
}

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _selectedImage = imageFile;
        });
        await _convertImageToBase64(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al seleccionar imagen: $e',
            style: const TextStyle(color: AppColors.lightGray),
          ),
          backgroundColor: AppColors.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.rosePrimary),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: AppColors.deepRedAccent),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

 void _onAccept() {
  if (_selectedImage != null) {
    _convertImageToBase64(_selectedImage!).then((base64Image) {
      Navigator.of(context).pop(base64Image);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.palePinkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.softPinkBackground,
        title: const Text(
          'Seleccionar Imagen',
          style: TextStyle(color: AppColors.lightGray),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: AppColors.softPinkBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.rosePrimary, width: 3),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.deepMaroon),
                      ),
                    )
                  : _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.photo,
                            color: AppColors.deepMaroon,
                            size: 50,
                          ),
                        ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _showPickerOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rosePrimary,
                    foregroundColor: AppColors.lightGray,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Seleccionar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selectedImage != null ? _onAccept : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage != null
                        ? AppColors.softPinkBackground
                        : AppColors.lightGray,
                    foregroundColor: AppColors.lightGray,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}