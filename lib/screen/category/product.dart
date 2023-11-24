import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Product extends StatefulWidget {
  final String productId;
  const Product({Key? key, required this.productId}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('product')
          .doc(widget.productId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"),);
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document does not exist"),);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          print(data);
          return Column(
            children: [
              const SizedBox(height: 5,),
              Image.network(data['profile'], height: 25,width: 25,),
              const SizedBox(height: 5,),
              Text(data['name']),
              const SizedBox(height: 5,),
              Text(data['category']),
              const SizedBox(height: 5,),
              Text('Brand name :- ' + data['brand']),
              const SizedBox(height: 5,),
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
