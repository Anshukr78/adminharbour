import 'package:flutter/material.dart';


class SelectItem extends StatefulWidget {
  final List<String> items;
  const SelectItem({Key? key, required this.items}) : super(key: key);

  @override
  State<SelectItem> createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> {

  final List<String> selectItems =[];

  void itemChanged(String itemValue, bool isSelected){
    setState(() {
      if(isSelected){
        selectItems.add(itemValue);
      }else{
        selectItems.remove(itemValue);
      }
    });
  }

  void cancel(){
    Navigator.pop(context);
  }

  void submit(){
    Navigator.pop(context, selectItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Size'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((e) => CheckboxListTile(
            title: Text(e),
              value: selectItems.contains(e),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked){
                itemChanged(e, isChecked!);
              }
          )).toList(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
              cancel();
            },
            child: const Text('Cancel'),
        ),
        ElevatedButton(
            onPressed: (){
              submit();
            }, child: const Text('Submit'))
      ],
    );
  }
}
