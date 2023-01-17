import 'package:cativou/principal/principal_page.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget TopNavBar(context) {
  return AppBar(
    leading: GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PrincipalPage())),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: Image.asset(
          'images/backIco.png',
          color: Colors.lightGreenAccent[700],
          width: 100,
          height: 100,
        ),
      ),
    ),
    leadingWidth: 70,
    automaticallyImplyLeading: false,
    actions: [
      Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 70, 10),
          child: Image.asset(
            "images/cativouLogo.png",
            fit: BoxFit.cover,
            width: 150,
          ),
        ),
      ),
      new GestureDetector(
        child: IconButton(
          icon: new Image.asset(
            'images/homeIco.png',
            color: Colors.lightGreenAccent[700],
            width: 30,
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrincipalPage()),
            );
          },
        ),
      ),
      const SizedBox(
        width: 5,
      )
    ],
    backgroundColor: Colors.transparent,
  );
}
