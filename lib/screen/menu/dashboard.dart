

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:uuid/uuid.dart';

import '../../component/error_dilog.dart';
import '../../widget/select_item.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static const routeName = '\DashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = false;
  var _image;
  String? fileName;
  List categoryName = [];
  List<String> categoryImage = [];
  List<String> size = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {}
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Category');

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    List<Map<String, dynamic>>? allData = querySnapshot.docs
        .map((doc) => doc.data())
        .cast<Map<String, dynamic>>()
        .toList();
    for (int i = 0; i < allData.length; i++) {
      categoryName.add(allData[i]['name']);
      categoryImage.add(allData[i]['image']);
    }

    print(categoryName.length);
    setState(() {
      loading = false;
    });
  }


  addItem()async{
    setState(() {
      loading = true;
    });

    if(categoryValue != null && brandName != null){

      if(fileName == null
          || _name.text.isEmpty
          || _description.text.isEmpty
          || _price.text.isEmpty){
        setState((){
          loading = false;
        });
        dialogError('All field are compulsory', context);
      }
      else{
        // storage.Reference reference = storage.FirebaseStorage.instance.ref().child('product').child(_uuid);
        // storage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        //
        // storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){
        // });

        try{

          Reference reference = _storage.ref().child('Product').child(const Uuid().v4());
          UploadTask uploadTask = reference.putData(_image);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          //await taskSnapshot.ref.getDownloadURL().then((url) async{

          String uuid = const Uuid().v4();
            await FirebaseFirestore.instance.collection('product').doc(uuid).set({
              'id' : uuid,
              'profile' : downloadUrl,
              'name' : _name.text.trim(),
              'description' : _description.text.trim(),
              'price' : double.parse(_price.text.trim()) ,
              'brand' : brandName,
              'category' : categoryValue,
              'size' : selectItems,
              'createAt' : Timestamp.now(),
            });
          //});

          _clearForm();
          setState(() {
            loading = false;
          });

          Fluttertoast.showToast(
              msg: "Product has been added successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
        } on FirebaseAuthException catch(e){
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: e.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        catch(e){
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: e.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }

    }else{
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: 'Select categories',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

  void _clearForm() {

  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  String? categoryValue;

  List<String> selectItems = [];

  void selectVariousValue() async {
    final List<String> items = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    final List<String>? result = await showCupertinoDialog(
        context: context,
        builder: (context) {
          return SelectItem(
            items: items,
          );
        });

    if (result != null) {
      setState(() {
        selectItems = result;
      });
    }
  }

  String brandName = 'L.H';




  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Add Product',
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
                            child: _image != null
                                ? Image.memory(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : const Center(
                                    child: Text('Product Image'),
                                  ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pickImage();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade900),
                            child: const Text('Upload Image'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                  labelText: 'Enter product name',
                                  helperText: 'Product name',
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _description,
                              maxLines: 6,
                              decoration: InputDecoration(
                                  labelText: 'Enter Description',
                                  helperText: 'Product Description',
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text('Category'),
                                const SizedBox(
                                  width: 10,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      hint: const Text('Select Category'),
                                      value: categoryValue,
                                      onChanged: (value) {
                                        setState(() {
                                          categoryValue = value.toString();
                                        });
                                      },
                                      items: List.generate(categoryName.length,
                                          (index) {
                                        return DropdownMenuItem(
                                            value: categoryName[index],
                                            child: Text(categoryName[index]));
                                      })),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text('Price'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: _price,
                                    decoration: InputDecoration(
                                        labelText: 'Enter Price',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Select Brand : '),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      brandName = 'L.H';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: brandName == 'L.H'
                                            ? Colors.indigo
                                            : Colors.white,
                                        border:
                                            Border.all(color: Colors.indigo),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Text(
                                      'L.H',
                                      style: GoogleFonts.damion(
                                        color: brandName == 'L.H'
                                            ? Colors.white
                                            : const Color(0xff473001),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      brandName = 'G';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: brandName == 'G'
                                            ? Colors.indigo
                                            : Colors.white,
                                        border:
                                            Border.all(color: Colors.indigo),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Text(
                                      'G',
                                      style: GoogleFonts.cuprum(
                                        color: brandName == 'G'
                                            ? Colors.white
                                            : const Color(0xff473001),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                selectVariousValue();
                              },
                              child: Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all()),
                                child: const Center(
                                  child: Text('Select Size'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              spacing: 5,
                              children: selectItems
                                  .map((e) => Chip(
                                      side: BorderSide(
                                        color: Colors.indigo.withOpacity(0.7),
                                      ),
                                      label: Text(e),
                                      backgroundColor:
                                          Colors.indigo.withOpacity(0.5)))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                addItem();
                              },
                              child: Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          Colors.indigoAccent.withOpacity(0.5),
                                    ),
                                    color: Colors.indigoAccent),
                                child: const Center(
                                  child: Text(
                                    'Upload Product',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
