

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../widget/categories_widget.dart';






class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  static const routeName = '\CategoriesScreen';
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  var _image;
  String? fileName;
  final TextEditingController _controller = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;


  uploadCategory(image)async{
    const Uuid uuidImage = Uuid();
    Reference reference = _storage.ref().child('Category').child(uuidImage.v4());
    UploadTask uploadTask = reference.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFireStore()async{
    EasyLoading.show();
    if(_image != null && _controller.text.isNotEmpty){
      const Uuid uuid = Uuid();
      String imageUrl = await uploadCategory(_image);
      _firebase.collection('Category').doc(_controller.text.trim()).set({
        'image' : imageUrl,
        'name' : _controller.text.trim()
      });
      EasyLoading.dismiss();
      setState(() {
        _image = null;
        _controller.text = '';
      });
    }else{

    }
  }

  _pickImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );

    if(result != null){
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }else{

    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Category',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 32,
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade500,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(
                          color: Colors.grey.shade800,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _image != null ? Image.memory(_image, fit: BoxFit.fill,) :  const Center(
                        child: Text('Category'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade900),
                      child: const Text('Upload Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30,),
              Flexible(
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: 'Enter categories',
                        helperText: 'Categories',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade900),
                onPressed: () {
                  uploadToFireStore();
                },
                child: const Text('Save'),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade500,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'List Of Category',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
          ),
          CategoryWidget(),
        ],
      ),
    );
  }
}
