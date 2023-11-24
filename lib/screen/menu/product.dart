
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../helper/boxWidget.dart';
import '../../widget/title_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static const routeName = '\ProductScreen';
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('product').snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget('Manage Product'),
          Row(
            children: [
              rowHeader('Image', 1),
              rowHeader('Name', 3),
              rowHeader('Description', 2),
              rowHeader('Category', 2),
              rowHeader('Price', 1),
              rowHeader('Size', 1),
            ],
          ),
          Container(
            height: 500,
            child: StreamBuilder(
              stream: _productStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                  if(snapshot.hasError){
                    print('Have some error');
                    return Text('An error occurs');
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }
                  print('check');
                  print(snapshot.data!.size);
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return BoxWidget(
                          imageUrl: snapshot.data!.docs[index]['profile'].toString(),
                          name: snapshot.data!.docs[index]['name'].toString(),
                          category: snapshot.data!.docs[index]['category'].toString(),
                          description: snapshot.data!.docs[index]['description'].toString(),
                          price: snapshot.data!.docs[index]['price'].toString(),
                          size: snapshot.data!.docs[index]['size'],
                        );
                      }
                  );
                }),
          )
        ],
      ),
    );
  }
}
