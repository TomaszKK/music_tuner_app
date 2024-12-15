import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/widgets/TranspositionWidget.dart';

class TranspositionButton extends StatelessWidget {
  final String selectedInstrument;

  const TranspositionButton({super.key, required this.selectedInstrument});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'lib/assets/Transp_logo.svg',
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimaryContainer,
          BlendMode.srcIn,
        ),
        width: 28,
        height: 28,
      ),
      onPressed: () {
        TranspositionWidget.showTranspositionWidget(context, selectedInstrument);
      },
    );
  }
}
