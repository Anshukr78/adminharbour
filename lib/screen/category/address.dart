import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddressDetails extends StatefulWidget {
  final String addressId;
  final String userId;
  const AddressDetails({Key? key, required this.addressId, required this.userId}) : super(key: key);

  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users')
          .doc(widget.userId).collection('address').doc(widget.addressId).get(),
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
              Text(data['first_name']+' '+ data['last_name']),
              Text(data['address']),
              Text(data['landmark']+','+data['city']),
              Text(data['country']+','+data['pincode']),
              Text('Phone no:-'+data['phone_number'])
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
