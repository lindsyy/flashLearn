import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class scanScreen extends StatelessWidget {
  const scanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        backgroundColor: colorY100,
        title: Text(
          'Scan Subject',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Container(
          height: 46,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              String COLOR_CODE = '#ffffff';
              String CANCEL_BUTTON_TEXT = 'CANCEL';
              bool isShowFlashIcon = true;
              ScanMode scanMode = ScanMode.QR;
              String qr = await FlutterBarcodeScanner.scanBarcode(
                  COLOR_CODE, CANCEL_BUTTON_TEXT, isShowFlashIcon, scanMode);
              if (qr != '1') {
                EasyLoading.show(status: 'Processing...');
                String collectionPath = 'subject';
                // FirebaseFirestore.instance.collection(collectionPath).get({});
              }
            },
            child: Text(
              'Scan',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: 1.3, color: Colors.black),
              backgroundColor: colorY100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
      // body: ElevatedButton(
      //   onPressed: () async {
      //     String COLOR_CODE = '#ffffff';
      //     String CANCEL_BUTTON_TEXT = 'CANCEL';
      //     bool isShowFlashIcon = true;
      //     ScanMode scanMode = ScanMode.QR;
      //     String qr = await FlutterBarcodeScanner.scanBarcode(
      //         COLOR_CODE, CANCEL_BUTTON_TEXT, isShowFlashIcon, scanMode);
      //     if (qr != '-1') {
      //       //log firestore
      //       // print(qr);
      //       EasyLoading.show(status: 'Processing..');
      //       String collectionPath = 'subject';
      //       FirebaseFirestore.instance
      //           .collection(collectionPath)
      //           .get({'title':});
      //       EasyLoading.showSuccess('Subject QR Code logged successfully');
      //     }
      //     ;
      //   },
      //   child: Text('Scan'),
      // ),
    );
  }
}
