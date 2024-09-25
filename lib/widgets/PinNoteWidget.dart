import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/NoteRepresentationWidget.dart';
import 'NoteSrollerWidget.dart';
import 'TunerWidget.dart';

class PinNoteWidget extends StatefulWidget {
  PinNoteWidget({
    Key? key,
    required this.defaultNote,
    required this.circleSize,
    required this.currentInstrument,
  }) : super(key: key);

  String defaultNote;
  final double circleSize;
  final String currentInstrument; // Instrument name or ID

  @override
  State<PinNoteWidget> createState() => _PinNoteWidgetState();
}

class _PinNoteWidgetState extends State<PinNoteWidget> {
  // Store blocked notes per instrument
  static final Map<String, String> _blockedNotesByInstrument = {};
  String initBLockedNote = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBlockedNoteForInstrument();
    });
  }

  // Load the blocked note for the current instrument when the widget is initialized
  void _loadBlockedNoteForInstrument() {
    final blockedNote = _blockedNotesByInstrument[widget.currentInstrument] ?? '';
    TunerWidget.blockedNoteNotifier.value = blockedNote;
  }

  // Save the blocked note for the current instrument
  void _setBlockedNoteForInstrument(String note) {
    _blockedNotesByInstrument[widget.currentInstrument] = note;
  }

  // Clear the blocked note for the current instrument
  void _clearBlockedNoteForInstrument() {
    _blockedNotesByInstrument[widget.currentInstrument] = '';
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ThemeManager().currentTheme.colorScheme.secondaryContainer;
    final currentNoteColor = ThemeManager().currentTheme.colorScheme.onSecondaryContainer;
    final NoteScrollerWidget noteScrollerWidget = NoteScrollerWidget();

    return ValueListenableBuilder<String>(
      valueListenable: TunerWidget.blockedNoteNotifier,
      builder: (context, blockedNote, child) {
        final isCurrentNoteBlocked = blockedNote == widget.defaultNote;

        return GestureDetector(
          onLongPress: () {
            setState(() {
              if (isCurrentNoteBlocked) {
                // Unblock if already blocked
                TunerWidget.blockedNoteNotifier.value = '';
                _clearBlockedNoteForInstrument();
              } else {
                // Block this note
                TunerWidget.blockedNoteNotifier.value = widget.defaultNote;
                _setBlockedNoteForInstrument(widget.defaultNote);
              }
            });
          },
          onTap: () async {
            // Show note picker and wait for the selected note
            String? returnNote = await noteScrollerWidget.showNotePicker(context, widget.defaultNote);
            if (returnNote != null) {
              setState(() {
                widget.defaultNote = returnNote;
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: widget.circleSize,
            width: widget.circleSize,
            decoration: BoxDecoration(
              color: isCurrentNoteBlocked ? themeColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentNoteBlocked ? currentNoteColor : themeColor,
                width: 2,
              ),
              boxShadow: isCurrentNoteBlocked
                  ? [
                BoxShadow(
                  color: themeColor,
                  blurRadius: 20.0,
                  blurStyle: BlurStyle.outer,
                ),
              ]
                  : null,
            ),
            child: NoteRepresentationWidget(
              noteString: widget.defaultNote,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}
