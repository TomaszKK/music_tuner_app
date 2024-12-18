String guitar = 'Guitar';
String bass = 'Bass';
String tenorhorn = 'Tenorhorn';
String saxophone = 'Saxophone';
String trumpet = 'Trumpet';

Map<String, List<String>> noteInstrumentDefaultProvider = {
  'Guitar':  ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'],
  'Bass': ['E1', 'A1', 'D2', 'G2'],
  'Tenorhorn': ['B1'],
  'Saxophone': ['F♯1'],
  'Trumpet': ['B1'],
};

Map<String, List<String>> instrumentNotesMap = Map<String, List<String>>.from(noteInstrumentDefaultProvider);
Map<String, List<String>> manualNotesMap = Map<String, List<String>>.from(noteInstrumentDefaultProvider);

Map<String, double> selectedInstrumentNotesMap = {};