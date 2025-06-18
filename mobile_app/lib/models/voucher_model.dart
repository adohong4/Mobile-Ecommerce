class VoucherModel {
  final String? id;
  final String code;
  final String discountType;
  final double discountValue;
  final double minOrderValue;
  final double maxDiscountAmount;
  final List<String> applicableProducts;
  final List<String> applicableCategories;
  final int usageLimit;
  final int usedCount;
  final List<String> userUsed;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;

  VoucherModel({
    this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue = 0,
    this.maxDiscountAmount = 0,
    this.applicableProducts = const [],
    this.applicableCategories = const [],
    this.usageLimit = 0,
    this.usedCount = 0,
    this.userUsed = const [],
    required this.startDate,
    required this.endDate,
    this.active = true,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['_id'] as String?,
      code: json['code'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble() ?? 0,
      maxDiscountAmount: (json['maxDiscountAmount'] as num?)?.toDouble() ?? 0,
      applicableProducts:
          (json['applicableProducts'] as List<dynamic>?)?.cast<String>() ?? [],
      applicableCategories:
          (json['applicableCategories'] as List<dynamic>?)?.cast<String>() ??
          [],
      usageLimit: (json['usageLimit'] as num?)?.toInt() ?? 0,
      usedCount: (json['usedCount'] as num?)?.toInt() ?? 0,
      userUsed: (json['userUsed'] as List<dynamic>?)?.cast<String>() ?? [],
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'code': code,
    'discountType': discountType,
    'discountValue': discountValue,
    'minOrderValue': minOrderValue,
    'maxDiscountAmount': maxDiscountAmount,
    'applicableProducts': applicableProducts,
    'applicableCategories': applicableCategories,
    'usageLimit': usageLimit,
    'usedCount': usedCount,
    'userUsed': userUsed,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'active': active,
  };

  String get formattedDiscount {
    if (discountType == 'PERCENTAGE') {
      return '${discountValue.toStringAsFixed(0)}%';
    } else {
      return '${discountValue.toStringAsFixed(0)} VNĐ'; 
    }
  }

  String get formattedMaxDiscount {
    return maxDiscountAmount > 0
        ? '${maxDiscountAmount.toStringAsFixed(0)} VNĐ'
        : 'Không giới hạn';
  }

  String get formattedEndDate {
    return '${endDate.day}/${endDate.month}/${endDate.year}';
  }

  String get formattedStartDate {
    return '${startDate.day}/${startDate.month}/${startDate.year}';
  }
}
