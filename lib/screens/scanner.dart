import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:marathon/utils/constants.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text("00:00:00", style: TextStyle(color: kWhite, fontSize: 20),),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kRed,
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: CircleAvatar(
                        backgroundColor: kLightRed,
                        child:Icon(LucideIcons.flame,color: kRed,)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: CircleAvatar(
                          backgroundColor: kLightRed,
                          child:Icon(LucideIcons.flame,color: kRed,)
                      ),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(40),
                child: Center(child: Text("Scanner")),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kLightYellow
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
