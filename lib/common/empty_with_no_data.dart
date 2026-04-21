import 'package:flutter/material.dart';

class EmptyWithNoData extends StatefulWidget {
  const EmptyWithNoData({super.key});

  @override
  _EmptyWithNoDataState createState() => _EmptyWithNoDataState();
}

class _EmptyWithNoDataState extends State<EmptyWithNoData> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Container(
      color: Colors.black,
      child: Center(
        child: Text("No Data Found",style: TextStyle(
          color: Colors.white,
          fontFamily: "Raleway",
          fontSize: (w+h)*0.0085,
          fontWeight: FontWeight.w600,
        ),),
      ),
    );
  }
}
