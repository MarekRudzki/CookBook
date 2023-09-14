import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class InternetNotConnected extends StatelessWidget {
  const InternetNotConnected({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 35,
        width: MediaQuery.of(context).size.width,
        color: Colors.red.withOpacity(0.5),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SpinKitThreeBounce(
              size: 25,
              color: Colors.red,
            ),
            Center(
              child: Text(
                'No Internet connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            SpinKitThreeBounce(
              size: 25,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
