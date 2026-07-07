import 'package:flutter/material.dart';

import 'package:live_vitalist/aliment/aliment.dart';
import 'package:live_vitalist/app/super_bar.dart';

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  final List<Aliment> list = [];

  void onPop() {
    Navigator.pop(context, list);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        onPop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Aliment Selector')),
        // body: Stack(
        //   alignment: Alignment.center,
        //   children: [
        //     Positioned(
        //       bottom: 20.0,
        //       left: 12.0,
        //       right: 12.0,
        //       child: SuperBar()
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
