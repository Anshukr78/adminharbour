import 'package:adminharbour/screen/category/address.dart';
import 'package:adminharbour/screen/category/product.dart';
import 'package:adminharbour/screen/details/refundDetails.dart';
import 'package:flutter/material.dart';


class ReturnBox extends StatelessWidget {
  final String productId, userId, addressId, status,reason,size, refundId;
  final quantity;
  const ReturnBox({Key? key, required this.productId, required this.userId, required this.addressId, required this.status, required this.reason, required this.size, required this.refundId, required this.quantity}) : super(key: key);


  Widget widgetData(int flex, Widget widget){
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: widget,
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          widgetData(1, Product(productId: productId)),
          widgetData(2, AddressDetails(addressId: addressId, userId: userId)),
          widgetData(2, Container(child: Text(reason),)),
          widgetData(2, Column(children:[ Text('Size :- $size'), Text('Quantity : - ${quantity.toString()}'), ],)),
          widgetData(1, Text(status),),
          widgetData(1, InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> RefundDetailsScreen(refundId: refundId)));
            },
            child: Text('View more..'),),)
        ],
      ),
    );
  }
}
