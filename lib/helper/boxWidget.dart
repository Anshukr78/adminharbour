import 'package:flutter/material.dart';



class BoxWidget extends StatelessWidget {
  final String imageUrl, name, category,description;
  final price, size;
  const BoxWidget({Key? key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.size}) : super(key: key);


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
          widgetData(
              1,
              Container(
                height: 50,
                width: 50,
                child: Image.network(imageUrl),
              )
          ),
          widgetData(3, Text(name)),
          widgetData(2, Text(description)),
          widgetData(2, Text(category)),
          widgetData(1, Text(price)),
          widgetData(1, Column(
            children: [
              ...List.generate(size.length, (index) {
                return Text(size[index]);
              })
            ],
          )
          ),
        ],
      ),
    );
  }
}
