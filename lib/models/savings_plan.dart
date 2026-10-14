class SavingsPlan {
  const SavingsPlan({
    required this.id,
    required this.name,
    required this.productType,
    required this.targetAmount,
    required this.monthlyContribution,
    required this.durationMonths,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String productType;
  final double targetAmount;
  final double monthlyContribution;
  final int durationMonths;
  final DateTime createdAt;

  factory SavingsPlan.fromJson(Map<String, dynamic> json) => SavingsPlan(
    id: json['id'] as String,
    name: json['name'] as String,
    productType: json['productType'] as String,
    targetAmount: (json['targetAmount'] as num).toDouble(),
    monthlyContribution: (json['monthlyContribution'] as num).toDouble(),
    durationMonths: json['durationMonths'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'productType': productType,
    'targetAmount': targetAmount,
    'monthlyContribution': monthlyContribution,
    'durationMonths': durationMonths,
    'createdAt': createdAt.toIso8601String(),
  };
}
