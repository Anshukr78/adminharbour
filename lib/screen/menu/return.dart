import 'package:adminharbour/helper/returnBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/boxWidget.dart';
import '../../widget/title_widget.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({Key? key}) : super(key: key);
  static const routeName = '\ReturnScreen';

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {

  final Stream<QuerySnapshot> _returnStream = FirebaseFirestore.instance.collection('refunds').snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget('Refund Request'),
          Row(
            children: [
              rowHeader('Product', 1),
              rowHeader('Address', 2),
              rowHeader('Reason', 2),
              rowHeader('Size & Quantity', 2),
              rowHeader('Status', 1),
              rowHeader('View more..', 1),
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

                        return ReturnBox(
                            productId: snapshot.data!.docs[index]['productId'],
                            userId: snapshot.data!.docs[index]['userId'],
                            addressId: snapshot.data!.docs[index]['addressId'],
                            status: snapshot.data!.docs[index]['refundStatus'],
                            reason: snapshot.data!.docs[index]['reason'],
                            size: snapshot.data!.docs[index]['productSize'],
                            refundId: snapshot.data!.docs[index]['id'],
                            quantity: snapshot.data!.docs[index]['productQuantity']
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
