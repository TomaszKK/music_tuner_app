import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/guitarWidget.dart';

class InstrumentWidget extends StatefulWidget {
  const InstrumentWidget({super.key, required this.title});

  final String title;

  @override
  State<InstrumentWidget> createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GuitarWidget(title: 'Guitar'),
    );
  }
}
