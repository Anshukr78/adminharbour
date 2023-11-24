import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/title_widget.dart';

class RefundDetailsScreen extends StatefulWidget {
  final String refundId;

  const RefundDetailsScreen({Key? key, required this.refundId})
      : super(key: key);

  @override
  State<RefundDetailsScreen> createState() => _RefundDetailsScreenState();
}

class _RefundDetailsScreenState extends State<RefundDetailsScreen> {

  final List<String> items = [
    'Return Requested',
    'Return Approved',
    'Product Picked Up',
    'Refund Processed',
  ];
  String? selectedValue;

  String? againValue;

  bool loader = false;

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('refunds')
            .doc(widget.refundId)
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

            return SingleChildScrollView(
              child: Row(
                children: [
                  Column(
                    children: [
                      titleWidget('Refund Information'),
                      Text('Refund id :- ${widget.refundId}'),
                      Column(
                        children: [
                          headerWidget('Product details'),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('product')
                                .doc(data['productId'])
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(dataProduct['name']),
                                            Text(dataProduct['category']),
                                            Row(
                                              children: [
                                                dataProduct['brand'] == 'G'
                                                    ? Text(
                                                        'G',
                                                        style:
                                                            GoogleFonts.cuprum(
                                                          color: const Color(
                                                              0xff473001),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.2,
                                                        ),
                                                      )
                                                    : Text(
                                                        'L.H',
                                                        style:
                                                            GoogleFonts.damion(
                                                          color: const Color(
                                                              0xff473001),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.2,
                                                        ),
                                                      ),
                                                Text(dataProduct['price']
                                                    .toString()),
                                              ],
                                            ),
                                            Text('Size:- ' +
                                                data['productSize']),
                                            Text(
                                                'Quentity:- ${data['productQuantity']}X')
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
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      headerWidget('Address details'),
                      Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(data['userId'])
                                    .collection('address')
                                    .doc(data['addressId'])
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text("Something went wrong"),
                                    );
                                  }

                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return const Center(
                                      child: Text("Document does not exist"),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> dataAddress =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    return SizedBox(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
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
                              const SizedBox(height: 10,),
                              data['deliveryDate']==null? SizedBox(): Text('Delivered Date: - ${data['deliveryDate']}'),
                              Text('Reason :- ${data['reason']}'),
                              Text('More Details :- ${data['moreDetails']}'),
                              Text('Refund Amount :- ${data['refundAmount'].toString()}'),
                              Container(height: 150,width: 150,child: Image.network(data['returnImage'], fit: BoxFit.cover,),),
                              Row(
                                children: [
                                  const Text('Refund Status :- '),
                                  const SizedBox(width: 20,),
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
                              // againValue == 'Refund Processed' || selectedValue == 'Refund Processed' ? Column(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: <Widget>[
                              //     Text(currentDate.toString()),
                              //     TextButton(
                              //       onPressed: () => _selectDate(context),
                              //       child: Text('Select date'),
                              //     ),
                              //   ],
                              // ) : SizedBox(),
                              const SizedBox(height: 50,),
                              GestureDetector(
                                onTap: () async{
                                  setState(() {
                                    loader = true;
                                  });
                                  await FirebaseFirestore
                                      .instance
                                      .runTransaction(
                                          (transaction) async {
                                        DocumentReference documentReference = FirebaseFirestore
                                            .instance
                                            .collection(
                                            'refunds')
                                            .doc(data['id']);

                                        DocumentSnapshot
                                        snapShotDataUpdate =
                                        await transaction
                                            .get(documentReference);

                                        transaction
                                            .update(
                                            documentReference,
                                            {
                                              'refundStatus':
                                              againValue,
                                              'deliveryDate':
                                              DateTime.now()
                                            });
                                      });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Order Status has been updated'))
                                  );
                                  setState(() {
                                    againValue = null;
                                    loader = false;
                                  });
                                },
                                child:loader ? Center(child: CircularProgressIndicator()): Container(
                                  height: 45,
                                  width: 200,
                                  margin: const EdgeInsets.only(left: 100),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                        Colors.indigoAccent.withOpacity(0.5),
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
    );
  }
}
