import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {


  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categories = FirebaseFirestore.instance.collection('Category').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categories,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

          if(snapshot.hasError){
            return const Text('Something went wrong');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 100/130
              ),
              itemBuilder: (context, index){
                return Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(snapshot.data!.docs[index]['image'].toString(), fit: BoxFit.cover,),
                    ),
                    const SizedBox(height: 5,),
                    Text(snapshot.data!.docs[index]['name'].toString())
                  ],
                );
              }
          );
        }
    );
  }
}
