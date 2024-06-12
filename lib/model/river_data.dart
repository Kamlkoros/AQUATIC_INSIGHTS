class RiverData {
  String riverName;
  Map<String, List<String>> dataLists = {};

  RiverData(this.riverName, this.dataLists);
  void clearData(String title) {
    dataLists[title] = [];
  }

  List<String> getData(String title) {
    return List<String>.from(dataLists[title] ?? []);
  }
}

class IndusData extends RiverData {
  IndusData()
      : super('INDUS @ TARBELA', {
          'LEVEL': [],
          'DEAD LEVEL': [],
          'MEAN INFLOW': [],
          'MEAN OUTFLOW': [],
        });
}

class KalabaghData extends RiverData {
  KalabaghData()
      : super('Kalabagh', {
          'U/S DISCHARGE': [],
          'D/S DISCHARGE': [],
          'Thal': [],
        });
}

class KabulData extends RiverData {
  KabulData()
      : super('KABUL @ NOWSHERA', {
          'MEAN DISCHARGE': [],
        });
}

class ChashmaData extends RiverData {
  ChashmaData()
      : super('CHASHMA', {
          'LEVEL': [],
          'DEAD LEVEL': [],
          'MEAN INFLOW': [],
          'MEAN OUTFLOW': [],
          'CJ LINK': [],
          'CRBC': [],
        });
}

class TaunsaData extends RiverData {
  TaunsaData()
      : super('TAUNSA', {
          'U/S DISCHARGE': [],
          'D/S DISCHARGE': [],
          'T-P LINK': [],
          'MUZAFARGHAR CANAL': [],
          'DERA GHAZI KHAN CANAL': [],
        });
}

class GudduData extends RiverData {
  GudduData()
      : super('Guddu', {
          'U/S DISCHARGE': [],
          'D/S DISCHARGE': [],
          'CANAL W/dls': [],
        });
}

class SukkarData extends RiverData {
  SukkarData()
      : super('Sukkar', {
          'U/S DISCHARGE': [],
          'D/S DISCHARGE': [],
          'CANAL W/dls': [],
        });
}

class KotriData extends RiverData {
  KotriData()
      : super('Kotri', {
          'U/S DISCHARGE': [],
          'D/S DISCHARGE': [],
          'CANAL W/dls': [],
        });
}

class JhelumData extends RiverData {
  JhelumData()
      : super('Jhelum', {
          'LEVEL': [],
          'DEAD LEVEL': [],
          'MEAN INFLOW': [],
          'MEAN OUTFLOW': [],
        });
}

class ChenabData extends RiverData {
  ChenabData()
      : super('CHENAB @ MARALA', {
          'MEAN U/S DISCHARGE': [],
          'MEAN D/S DISCHARGE': [],
        });
}

class PanjnadData extends RiverData {
  PanjnadData()
      : super('PANJNAD', {
          'U/S DISCHARGE': [],
          'D/S DISCHARGE': [],
        });
}
