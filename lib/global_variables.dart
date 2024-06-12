import 'package:aquatic_insights/model/river_data.dart';
import 'package:intl/intl.dart';

final List<String> lastTwentyDays = List.generate(15, (index) {
  DateTime day = DateTime.now().subtract(Duration(days: index));
  return DateFormat('dd-MM-yyyy').format(day);
});
List<String> availableDays = [];
 Future<void>? downloadFuture;
 

IndusData indus = IndusData();
KalabaghData kalabagh = KalabaghData();
KabulData kabul = KabulData();
ChashmaData chashma = ChashmaData();
TaunsaData taunsa = TaunsaData();
GudduData guddu = GudduData();
SukkarData sukkar = SukkarData();
KotriData kotri = KotriData();
JhelumData jhelum = JhelumData();
ChenabData chenab = ChenabData();
PanjnadData panjnad = PanjnadData();
