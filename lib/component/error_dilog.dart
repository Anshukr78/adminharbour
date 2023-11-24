import 'package:flutter/material.dart';



dialogError(String text, BuildContext context){
  return showDialog(
      context: context,
      builder: (context){
    return AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.spaceAround,
      title: Text('Error'),
      content: Text(text),
      contentPadding: const EdgeInsets.only(
          left: 50,
          top: 10,
          bottom: 10
      ),
      actions: [
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Ok'),
            style: ElevatedButton.styleFrom(
              primary: Colors.indigoAccent
            ),
          ),
        ),
      ],
    );
  });
}