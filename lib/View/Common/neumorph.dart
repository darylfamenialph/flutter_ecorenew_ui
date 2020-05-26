import 'package:flutter/material.dart';

//Color mC = Colors.grey.shade100;
Color mC = Colors.grey.shade200;
Color mCL = Colors.white;
Color mCD = Colors.black.withOpacity(0.1);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;

BoxDecoration nMbox = BoxDecoration(
  shape: BoxShape.circle,
  color: mC,
  boxShadow: [
    BoxShadow(
      color: mCD,
      offset: Offset(10, 10),
      blurRadius: 10,
    ),
    BoxShadow(
      color: mCL,
      offset: Offset(-10, -10),
      blurRadius: 10,
    ),
  ]
);

BoxDecoration nMboxInvert = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: mCD,
  boxShadow: [
    BoxShadow(
      color: mCL,
      offset: Offset(3, 3),
      blurRadius: 3,
      spreadRadius: -3
    ),
  ]
);

BoxDecoration nMCard = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: mC,
  boxShadow: [
    BoxShadow(
      color: mCD,
      offset: Offset(10, 10),
      blurRadius: 10,
    ),
    BoxShadow(
      color: mCL,
      offset: Offset(-10, -10),
      blurRadius: 10,
    ),
  ]
);

BoxDecoration nMRectBtn = BoxDecoration(
  borderRadius: BorderRadius.circular(25),
  color: mC,
  boxShadow: [
    BoxShadow(
      color: mCD,
      offset: Offset(10, 10),
      blurRadius: 10,
    ),
    BoxShadow(
      color: mCL,
      offset: Offset(-10, -10),
      blurRadius: 10,
    ),
  ]
);

