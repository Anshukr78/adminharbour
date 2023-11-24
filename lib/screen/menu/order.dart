import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/orderBox.dart';
import '../../widget/title_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '\OrderScreen';
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Stream<QuerySnapshot> _returnStream = FirebaseFirestore.instance.collection('orders').snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget('Manage Order'),
          Row(
            children: [
              rowHeader('Product List', 2),
              rowHeader('Address', 2),
              rowHeader('Total amount', 1),
              rowHeader('Order Status', 1),
              rowHeader('Order date', 1),
              rowHeader('View more', 1),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.85,
            child: StreamBuilder(
                stream: _returnStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                  if(snapshot.hasError){
                    return const Text('An error occurs');
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.size,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return OrderBox(
                          productId: snapshot.data!.docs[index]['productList'],
                          orderId: snapshot.data!.docs[index]['id'],
                          userId: snapshot.data!.docs[index]['userId'],
                          addressId: snapshot.data!.docs[index]['address'],
                          size: snapshot.data!.docs[index]['productSize'],
                          quantity: snapshot.data!.docs[index]['productQuantity'],
                          totalAmount: snapshot.data!.docs[index]['totalAmount'].toString(),
                          status: snapshot.data!.docs[index]['orderStatus'],
                          date: snapshot.data!.docs[index]['orderDate'].toString(),
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
