import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Fail extends StatelessWidget {
  const Fail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fail'.tr),
      ),
      body: Center(
        child: Text('fail'.tr),
      ),
    );
  }
}