import 'package:adminharbour/screen/details/orderDetails.dart';
import 'package:flutter/material.dart';

import '../screen/category/address.dart';
import '../screen/category/product.dart';

class OrderBox extends StatefulWidget {
  final productId,
      orderId,
      userId,
      addressId,
      size,
      quantity,
      totalAmount,
      status,
      date;

  const OrderBox(
      {Key? key,
      required this.productId,
      required this.orderId,
      required this.userId,
      required this.addressId,
      required this.size,
      required this.quantity,
      required this.totalAmount,
      required this.status,
      required this.date})
      : super(key: key);

  @override
  State<OrderBox> createState() => _OrderBoxState();
}

class _OrderBoxState extends State<OrderBox> {
  Widget widgetData(int flex, Widget widget) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: widget,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          widgetData(
              2,
              Column(
                children: [
                  ...List.generate(widget.productId.length, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Product(productId: widget.productId[index]),
                          Text('Size :- ${widget.size[index]}'),
                          Text('Quantity :- ${widget.quantity[index]}'),
                        ],
                      ),
                    );
                  })
                ],
              )),
          widgetData(
            2,
            AddressDetails(
              addressId: widget.addressId,
              userId: widget.userId,
            ),
          ),
          widgetData(
            1,
            Text(widget.totalAmount),
          ),
          widgetData(
            1,
            Text(widget.status),
          ),
          widgetData(
            1,
            Text(widget.date),
          ),
          widgetData(
            1,
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                            orderDetailsPage: widget.orderId)));
              },
              child: Text('View more..'),
            ),
          )
        ],
      ),
    );
  }
}
