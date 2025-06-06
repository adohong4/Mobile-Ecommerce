import 'package:flutter/material.dart';

class PaymentMethodComponent extends StatelessWidget {
  final String? selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;
  final List<Map<String, dynamic>> paymentMethods;

  const PaymentMethodComponent({
    Key? key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.paymentMethods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...paymentMethods.map((method) {
            return InkWell(
              onTap: () {
                onPaymentMethodChanged(method['id'].toString());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        if (method['icon_type'] == 'text')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: method['icon_color'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              method['icon_text'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        else if (method['icon_type'] == 'image' &&
                            method['icon_asset'] != null)
                          Image.asset(
                            method['icon_asset'] as String,
                            height: 24,
                          ),
                        const SizedBox(width: 12),
                        Text(
                          method['label'] as String,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Radio<String>(
                      value: method['id'].toString(),
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        if (value != null) {
                          onPaymentMethodChanged(value);
                        }
                      },
                      activeColor: const Color(0xFFE91E63),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
