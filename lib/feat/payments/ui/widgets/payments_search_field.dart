import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/payments_content.dart';

class PaymentsSearchField extends StatelessWidget {
  const PaymentsSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: PaymentsContent.searchHint,
      prefixIcon: Icons.search_rounded,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
    );
  }
}
