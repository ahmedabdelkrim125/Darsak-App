import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../schedule/ui/widgets/schedule_card.dart';
import '../data/more_faq.dart';
import 'contact_us_screen.dart';
import 'more_navigator.dart';
import 'widgets/faq_tile.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = _query.trim();
    final items = MoreFaq.items
        .where(
          (item) =>
              text.isEmpty ||
              item.question.contains(text) ||
              item.answer.contains(text),
        )
        .toList();

    return AppPageScaffold(
      title: 'مركز المساعدة',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            hintText: 'ابحث في الأسئلة الشائعة',
            prefixIcon: Icons.search_rounded,
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _query = value),
          ),
          verticalSpace(height: 6),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                'لا توجد نتائج مطابقة',
                textAlign: TextAlign.center,
                style: AppFonts.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            )
          else
            for (final item in items) ...[
              FaqTile(key: ValueKey(item.question), item: item),
              verticalSpace(height: 10),
            ],
          verticalSpace(height: 8),
          ScheduleCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'لم تجد إجابتك؟',
                  style: AppFonts.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                verticalSpace(height: 4),
                Text(
                  'فريق الدعم جاهز لمساعدتك.',
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                verticalSpace(height: 12),
                AppButton(
                  label: 'تواصل معنا',
                  expanded: true,
                  onPressed: () =>
                      MoreNavigator.push(context, const ContactUsScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
