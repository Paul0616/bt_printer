import 'dart:typed_data';

import 'package:bt_printer/fiscal_printer/generic_printer_bloc.dart';
import 'package:bt_printer/select_bonded_device_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'fiscal_printer/models/utils/datecs_utils/datecs_commans.dart';
import 'fiscal_printer/models/utils/datecs_utils/datecs_message.dart';
import 'fiscal_printer/models/utils/datecs_utils/datecs_report_type.dart';
import 'fiscal_printer/models/utils/datecs_utils/datecs_response_adapter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BluetoothConnection? connection;
  bool isConnecting = true;

  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
  }

  // printReportZ(BluetoothDevice device,{required DatecsMessage message}) {
  //   // if(connection == null){
  //   BluetoothConnection.toAddress(device.address).then((conn) {
  //     print('Connected to the device');
  //     connection = conn;
  //     setState(() {
  //       isConnecting = false;
  //       isDisconnecting = false;
  //     });
  //     // connection!.input!.firstWhere((data) => !DatecsResponseAdapter(
  //     //           response: data, sequenceNumber: message.seqNo)
  //     //           .checkWaitToGetResponse()).timeout(timeLimit)
  //     // //     .listen(onDataReceived).onDone(() {
  //     // //   if (isDisconnecting) {
  //     // //     print('Disconnecting locally!');
  //     // //   } else {
  //     // //     print('Disconnected remotely!');
  //     // //   }
  //     // // }
  //     // );
  //     _sendCommand(
  //       message: DatecsMessage(
  //         command: DatecsCommands.report(DatecsReportType.reportZ),
  //       ),
  //     );
  //   }).catchError((err) {
  //     print('Cannot connect, exception occured');
  //     print(err);
  //   });
  // }
  //
  // _sendCommand({required DatecsMessage message}) async {
  //   try {
  //     connection!.output.add(message.getMessage());
  //     await connection!.output.allSent;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  // void onDataReceived(Uint8List data) {
  //   print("DATA: ${data.toList()}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bluetooth PRINTER'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: ElevatedButton(
              child: const Text("Connect to paired device"),
              onPressed: () async {
                final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const SelectBondedDevicePage(
                      checkAvailability: false,
                    );
                  },
                ));
                if (selectedDevice != null) {
                  print("Connect -> selected ${selectedDevice.address}");
                  var bloc = Provider.of<GenericPrinterBloc>(context, listen: false);
                  bloc.dailySum(selectedDevice);
                } else {
                  print("Connect -> no device selected");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
