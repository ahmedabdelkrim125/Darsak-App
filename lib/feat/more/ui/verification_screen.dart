import 'package:flutter/material.dart';
import '../../../core/const/app_assets.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../../core/widgets/app_toast.dart';
import '../../schedule/ui/widgets/schedule_card.dart';
import '../data/more_icons.dart';
import 'widgets/doc_upload_tile.dart';
import 'widgets/image_source_sheet.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? _idPath;
  String? _certificatePath;
  String? _error;

  Future<void> _pick({required bool isId}) async {
    final current = isId ? _idPath : _certificatePath;
    final result = await ImageSourceSheet.choose(
      context,
      canRemove: current != null,
    );
    if (result == null || !mounted) return;
    setState(() {
      if (isId) {
        _idPath = result.path;
      } else {
        _certificatePath = result.path;
      }
      _error = null;
    });
  }

  void _submit() {
    if (_idPath == null || _certificatePath == null) {
      setState(() => _error = 'أرفق الصورتين لإكمال الطلب');
      return;
    }
    AppSession.instance.markVerified();
    AppToast.show(context, 'تم توثيق حسابك');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final session = AppSession.instance;

    return AppPageScaffold(
      title: 'توثيق المعلم',
      child: ListenableBuilder(
        listenable: session,
        builder: (context, _) {
          if (session.isVerified) {
            return _VerifiedView(date: session.verifiedAt!);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScheduleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'وثّق هويتك كمعلم',
                      style: AppFonts.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    verticalSpace(height: 6),
                    Text(
                      'أرفق المستندات التالية لتحصل على شارة "حساب موثق" وتزيد ثقة الطلاب.',
                      style: AppFonts.bodyMedium.copyWith(
                        color: palette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    verticalSpace(height: 12),
                    for (final benefit in const [
                      'شارة التوثيق تظهر في ملفك العام',
                      'ثقة أكبر من الطلاب وأولياء الأمور',
                      'وصول كامل إلى جميع المميزات',
                    ])
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          children: [
                            Icon(
                              MoreIcons.check,
                              size: 18.r,
                              color: palette.success,
                            ),
                            horizontalSpace(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: AppFonts.bodyMedium.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              verticalSpace(height: 14),
              DocUploadTile(
                title: 'صورة بطاقة الهوية',
                subtitle: 'صورة واضحة للوجه الأمامي للبطاقة',
                path: _idPath,
                onTap: () => _pick(isId: true),
              ),
              verticalSpace(height: 10),
              DocUploadTile(
                title: 'كارنيه النقابة أو شهادة التدريس',
                subtitle: 'أي مستند يثبت أنك معلم',
                path: _certificatePath,
                onTap: () => _pick(isId: false),
              ),
              if (_error != null)
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    _error!,
                    style: AppFonts.bodySmall.copyWith(color: palette.error),
                  ),
                ),
              verticalSpace(height: 18),
              AppButton(
                label: 'إرسال طلب التوثيق',
                onPressed: _submit,
                expanded: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VerifiedView extends StatelessWidget {
  const _VerifiedView({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        verticalSpace(height: 10),
        Image.asset(AppAssets.verifiedBadge, width: 220.w, fit: BoxFit.contain),
        verticalSpace(height: 10),
        Text(
          'تم توثيق حسابك',
          style: AppFonts.headlineMedium.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 8),
        Text(
          'تم التحقق من بياناتك كمعلم، ويظهر الآن شارة التوثيق في ملفك العام.',
          textAlign: TextAlign.center,
          style: AppFonts.bodyMedium.copyWith(
            color: palette.textSecondary,
            height: 1.6,
          ),
        ),
        verticalSpace(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: palette.success.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            'تاريخ التوثيق: ${DateFormatter.shortDate(date)}',
            style: AppFonts.bodyMedium.copyWith(color: palette.success),
          ),
        ),
      ],
    );
  }
}
