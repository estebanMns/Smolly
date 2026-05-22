class TimeOption {
  final String type; // '30s', '1m', '2m'
  final String label;
  final String price;
  final int coinCost;

  TimeOption({
    required this.type,
    required this.label,
    required this.price,
    required this.coinCost,
  });
}