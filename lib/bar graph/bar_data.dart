import 'package:budgetly/bar%20graph/individual_bar.dart';

class BarData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  List<IndividualBar> barData = [];

  // initialise bar data
  void initialiseBarData() {
    barData = [
      // mon
      IndividualBar(x: 0, y: monAmount),

      IndividualBar(x: 1, y: tueAmount),

      IndividualBar(x: 2, y: wedAmount),

      IndividualBar(x: 3, y: thuAmount),

      IndividualBar(x: 4, y: friAmount),

      IndividualBar(x: 5, y: satAmount),

      IndividualBar(x: 6, y: sunAmount),
    ];
  }

  BarData({
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
  });
}
