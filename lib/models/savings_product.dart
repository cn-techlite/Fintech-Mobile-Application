class SavingsProduct {
  const SavingsProduct({
    required this.name,
    required this.interestRate,
    required this.duration,
    required this.description,
    required this.minimumDeposit,
  });

  final String name;
  final double interestRate;
  final String duration;
  final String description;
  final double minimumDeposit;
}
