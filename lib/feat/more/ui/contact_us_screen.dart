import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../classroom/ui/widgets/classroom_chip.dart';
import '../../classroom/ui/widgets/sheet_label.dart';
import '../data/models/contact_type.dart';
import '../data/more_content.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _message = TextEditingController();
  ContactType _type = ContactType.message;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final session = AppSession.instance;
    final sender = session.email.isEmpty
        ? session.fullName
        : '${session.fullName} (${session.email})';
    final subject = '[${_type.label}] ${MoreContent.appName}';
    final body = '${_message.text.trim()}\n\n— $sender';
    final uri = Uri.parse(
      'mailto:${MoreContent.supportEmail}?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    var opened = false;
    try {
      opened = await launchUrl(uri);
    } catch (_) {
      opened = false;
    }
    if (!mounted) return;
    if (opened) {
      _message.clear();
      AppToast.show(context, 'تم فتح تطبيق البريد لإرسال رسالتك');
      return;
    }
    await Clipboard.setData(ClipboardData(text: body));
    if (!mounted) return;
    AppToast.show(context, 'تعذر فتح تطبيق البريد، تم نسخ رسالتك');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPageScaffold(
      title: 'تواصل معنا',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'نسعد بسماع رأيك. اختر نوع رسالتك واكتبها لنا.',
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 16),
            const SheetLabel('نوع الرسالة'),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final type in ContactType.values)
                  ClassroomChip(
                    label: type.label,
                    selected: type == _type,
                    onTap: () => setState(() => _type = type),
                  ),
              ],
            ),
            verticalSpace(height: 16),
            AppTextField(
              controller: _message,
              hintText: 'اكتب رسالتك هنا',
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
              maxLength: 600,
              validator: (value) => (value?.trim().length ?? 0) < 10
                  ? 'اكتب 10 أحرف على الأقل'
                  : null,
              reserveErrorSpace: true,
            ),
            verticalSpace(height: 8),
            AppButton(label: 'إرسال', onPressed: _send, expanded: true),
          ],
        ),
      ),
    );
  }
}
