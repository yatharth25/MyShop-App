import 'package:flutter/material.dart';

class CircularProgIndicator extends StatefulWidget {
  const CircularProgIndicator({
    Key key,
  }) : super(key: key);

  @override
  _CircularProgressIndicatorState createState() =>
      _CircularProgressIndicatorState();
}

class _CircularProgressIndicatorState extends State<CircularProgIndicator> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
