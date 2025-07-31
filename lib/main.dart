import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sum_thing/utils.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SumThing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("SumThing",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Image.asset('assets/logo.png'),
            const SizedBox(height: 20),
            const SizedBox(
                width: 300,
                child: Text(
                    "Une application permettant d'additionner les montants des QR-factures",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QRSumView(),
                  ),
                );
              },
              child: const Text('Ouvrir le scanner de QR'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRSumView extends StatefulWidget {
  const QRSumView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRSumViewState();
}

class _QRSumViewState extends State<QRSumView> {
  Barcode? result;
  MobileScannerController controller = MobileScannerController();
  List<double> scannedValues = [];

  bool isSidebarOpen = true;
  Color _borderColor = Colors.red;

  double get totalSum => scannedValues.fold(0, (sum, item) => sum + item);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: _buildQrView(context),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                child: Text('Total: CHF ${totalSum.toStringAsFixed(2)}'),
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          child: ElevatedButton(
            onPressed: scannedValues.isNotEmpty
                ? () {
                    setState(() {
                      scannedValues.removeLast();
                      result = null;
                    });
                  }
                : null,
            child: const Text('Annuler le dernier'),
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          child: IconButton(
            icon: Icon(
              isSidebarOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isSidebarOpen = !isSidebarOpen;
              });
            },
          ),
        ),
        if (isSidebarOpen)
          Positioned(
            top: 150,
            left: 0,
            bottom: 0,
            width: 150,
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  child: Text(
                      'Valeurs Scannées:\n${scannedValues.map((s) => "CHF $s").join('\n')}'),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: _handleBarcode,
        ),
        // Custom overlay with colored border
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      final scanData = barcodes.barcodes.firstOrNull;
      if (scanData != null && result?.rawValue != scanData.rawValue) {
        setState(() {
          result = scanData;
          double? extracted = extractAmount(scanData.rawValue);
          if (extracted != null) {
            scannedValues.add(extracted);
            // Show success feedback with green border
            _borderColor = Colors.green;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  _borderColor = Colors.red;
                });
              }
            });
          } else {
            // INVALID QR CODE (not a QR facture or wrong format)
          }
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
