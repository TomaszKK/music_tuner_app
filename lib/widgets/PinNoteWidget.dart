import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/NoteRepresentationWidget.dart';
import 'NoteSrollerWidget.dart';
import 'TunerWidget.dart';

class PinNoteWidget extends StatefulWidget {
  PinNoteWidget({
    Key? key,
    required this.defaultNote,
    required this.currentNote,
    required this.circleSize,
    required this.currentInstrument,
    required this.onNoteChanged,  // Add a callback function
  }) : super(key: key);

  String defaultNote;
  String currentNote;
  final double circleSize;
  final String currentInstrument;
  final ValueChanged<String> onNoteChanged;  // Callback when note is changed

  @override
  State<PinNoteWidget> createState() => _PinNoteWidgetState();
}

class _PinNoteWidgetState extends State<PinNoteWidget> {
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
    final themeColor = ThemeManager().currentTheme.colorScheme
        .secondaryContainer;
    final currentNoteColor = ThemeManager().currentTheme.colorScheme
        .onSecondaryContainer;
    final NoteScrollerWidget noteScrollerWidget = NoteScrollerWidget();

    return ValueListenableBuilder<String>(
      valueListenable: TunerWidget.blockedNoteNotifier,
      builder: (context, blockedNote, child) {
        final isCurrentNoteBlocked = blockedNote == widget.currentNote;

        return GestureDetector(
          onTap: () async {
            String? returnNote = await noteScrollerWidget.showNotePicker(context, widget.currentNote, widget.defaultNote);
            if (returnNote != null) {
              setState(() {
                widget.currentNote = returnNote;
                if(isCurrentNoteBlocked) {
                  TunerWidget.blockedNoteNotifier.value = returnNote;
                  _setBlockedNoteForInstrument(returnNote);
                }
              });
              widget.onNoteChanged(returnNote);
            }
          },
          onLongPress: () {
            setState(() {
              if (isCurrentNoteBlocked) {
                // Unblock if already blocked
                TunerWidget.blockedNoteNotifier.value = '';
                _clearBlockedNoteForInstrument();
              } else {
                // Block this note
                TunerWidget.blockedNoteNotifier.value = widget.currentNote;
                _setBlockedNoteForInstrument(widget.currentNote);
              }
            });
          },
          child: ValueListenableBuilder<String>(
            valueListenable: TunerWidget.currentNoteNotifier, // Listen to the ValueNotifier
            builder: (context, currentNoteNotifier, child) {
              if (currentNoteNotifier == widget.currentNote) {
                return Container(
                  alignment: Alignment.center,
                  height: widget.circleSize,
                  width: widget.circleSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ThemeManager().currentTheme.colorScheme
                          .secondaryContainer,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeManager().currentTheme.colorScheme
                          .secondaryContainer,
                        blurRadius: 15.0,
                        // spreadRadius: 3.0,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: NoteRepresentationWidget(
                      noteString: widget.currentNote, fontSize: 20),
                );
              }
              else{
                return Container(
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
                    noteString: widget.currentNote,
                    fontSize: 20,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
