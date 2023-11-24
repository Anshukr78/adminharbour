import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/title_widget.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderDetailsPage;

  const OrderDetailsPage({Key? key, required this.orderDetailsPage})
      : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final List<String> items = [
    'Ordered',
    'Canceled',
    'Packed',
    'Shipped',
    'Delivery'
  ];
  String? selectedValue;

  String? againValue;

  bool loader = false;

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  updateStatus() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderDetailsPage)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(
              child: Text("Document does not exist"),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            selectedValue = data['orderStatus'];
            currentDate = data['deliveryDate'];
            return Column(
              children: [
                titleWidget('Order Information'),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order id:-   ${data['id']}'),
                          Text('Order Date:- ${data['orderDate']}'),
                          headerWidget('Product details'),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.6,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data['productList'].length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('product')
                                        .doc(data['productList'][index])
                                        .get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text("Something went wrong"),
                                        );
                                      }

                                      if (snapshot.hasData &&
                                          !snapshot.data!.exists) {
                                        return const Center(
                                          child:
                                              Text("Document does not exist"),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> dataProduct =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        print(data);
                                        return Container(
                                          height: 120,
                                          width: 320,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    dataProduct['profile']),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(dataProduct['name']),
                                                    Text(dataProduct[
                                                        'category']),
                                                    Row(
                                                      children: [
                                                        dataProduct['brand'] ==
                                                                'G'
                                                            ? Text(
                                                                'G',
                                                                style:
                                                                    GoogleFonts
                                                                        .cuprum(
                                                                  color: const Color(
                                                                      0xff473001),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  letterSpacing:
                                                                      0.2,
                                                                ),
                                                              )
                                                            : Text(
                                                                'L.H',
                                                                style:
                                                                    GoogleFonts
                                                                        .damion(
                                                                  color: const Color(
                                                                      0xff473001),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  letterSpacing:
                                                                      0.2,
                                                                ),
                                                              ),
                                                        Text(
                                                            dataProduct['price']
                                                                .toString()),
                                                      ],
                                                    ),
                                                    Text('Size:- ' +
                                                        data['productSize']
                                                            [index]),
                                                    Text(
                                                        'Quentity:- ${data['productQuantity'][index]}X')
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }

                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(data['userId'])
                              .collection('address')
                              .doc(data['address'])
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text("Something went wrong"),
                              );
                            }

                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return const Center(
                                child: Text("Document does not exist"),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> dataAddress =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return SizedBox(
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Center(
                                      child: Text('Address :-'),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(dataAddress['first_name'] +
                                            ' ' +
                                            dataAddress['last_name']),
                                        Text(dataAddress['address']),
                                        Text(dataAddress['landmark'] +
                                            ',' +
                                            dataAddress['city']),
                                        Text(dataAddress['country'] +
                                            ', ' +
                                            dataAddress['pincode']),
                                        Text(dataAddress['phone_number'])
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        data['deliveryDate'] == null
                            ? SizedBox()
                            : Text('Delivered Date: - ${data['deliveryDate']}'),
                        Text('Payment Mode:- ${data['paymentMode']}'),
                        Text('Paid Amount :- ${data['paidAmount']}'),
                        Row(
                          children: [
                            const Text('Order Status :- '),
                            const SizedBox(
                              width: 20,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: againValue ?? selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                    againValue = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 40,
                                  width: 140,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // againValue == 'Deliivery' ||
                        //         selectedValue == 'Deliivery'
                        //     ? Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: <Widget>[
                        //           Text(currentDate.toString()),
                        //           TextButton(
                        //             onPressed: () => _selectDate(context),
                        //             child: const Text('Select date'),
                        //           ),
                        //         ],
                        //       )
                        //     : const SizedBox(),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () async {

                            setState(() {
                              loader = true;
                            });
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(data['id']);

                              DocumentSnapshot snapShotDataUpdate =
                                  await transaction.get(documentReference);

                              transaction.update(documentReference, {
                                'orderStatus': againValue,
                                'deliveryDate': DateTime.now()
                              });
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Order Status has been updated')));
                            setState(() {
                              againValue = null;
                              loader = false;
                            });
                          },
                          child: loader
                              ? Center(child: CircularProgressIndicator())
                              : Container(
                                  height: 45,
                                  width: 200,
                                  margin: const EdgeInsets.only(left: 100),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.indigoAccent
                                            .withOpacity(0.5),
                                      ),
                                      color: Colors.indigoAccent),
                                  child: const Center(
                                    child: Text(
                                      'Change order status',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
