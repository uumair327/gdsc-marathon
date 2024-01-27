import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:marathon/utils/constants.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class ScannerPage extends StatelessWidget {
  ScannerPage({super.key});
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _openQRScanner(context);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: const Text(
                    "00:00:00",
                    style: TextStyle(color: kWhite, fontSize: 20),
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: kRed, borderRadius: BorderRadius.circular(10)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      child: const CircleAvatar(
                          backgroundColor: kLightRed,
                          child: Icon(
                            LucideIcons.flame,
                            color: kRed,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      child: const CircleAvatar(
                          backgroundColor: kLightRed,
                          child: Icon(
                            LucideIcons.flame,
                            color: kRed,
                          )),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kLightYellow),
                child: InkWell(onTap: () {
                  _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                    context: context,
                    onCode: (scannedCode) {
                      // setState(() {
                      //   this.code = scannedCode;
                      //   // Update checkpoint logic
                      // });
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openQRScanner(BuildContext context) {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: context,
      onCode: (scannedCode) {
        // Handle the scanned code as needed
        // setState(() {
        //   this.code = scannedCode;
        //   // Update checkpoint logic
        // });
      },
    );
  }
}
