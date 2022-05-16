import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   if (!mounted) return;
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }

  void postData() async {
    List<String> data = _scanBarcode.split('*');
    try {
      var response = await Dio().post(
        // api link end tavina
        'https://reqres.in/api/users',
        data: {
          "name": data[0],
          "organization": data[1],
          "profession": data[2],
        },
      );
      print('data ${response}');
    } catch (e) {
      print(e);
    }
  }

//barcode scanner flutter ant
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Barcode Scanner')),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.all(10),
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     onPressed: () => scanBarcodeNormal(),
                  //     child: const Text('Barcode scan'),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => scanQR(),
                        child: const Text('QR scan')),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Scan result : $_scanBarcode\n',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: postData,
                      child: Text("Бүртгүүлэх"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
