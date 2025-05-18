import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/transfer_controller.dart';
import 'package:get/get.dart';

class ConfirmTransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transferController = Get.find<TransferController>();

    return Scaffold(
      appBar: AppBar(title: Text('Confirm Transfer')),
      body: Center(
        child: Text('Recipient: ${transferController.recipientAddress.value}'),
      ),
    );
  }
}
