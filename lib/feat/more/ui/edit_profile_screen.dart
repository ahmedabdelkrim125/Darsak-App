import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/helper/app_validators.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../classroom/data/classroom_store.dart';
import 'widgets/image_source_sheet.dart';
import 'widgets/more_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppSession _session = AppSession.instance;
  late final TextEditingController _name = TextEditingController(
    text: _session.fullName,
  );
  late final TextEditingController _email = TextEditingController(
    text: _session.email,
  );
  late final TextEditingController _phone = TextEditingController(
    text: _session.phone,
  );
  late final TextEditingController _subject = TextEditingController(
    text: _session.subject,
  );
  late final TextEditingController _bio = TextEditingController(
    text: _session.bio,
  );
  late final bool _canEditSubject = ClassroomStore.instance.groups.isEmpty;
  late String? _avatarPath = _session.avatarPath;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _subject.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _changeAvatar() async {
    final result = await ImageSourceSheet.choose(
      context,
      canRemove: _avatarPath != null,
    );
    if (result == null || !mounted) return;
    setState(() => _avatarPath = result.path);
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _session.updateProfile(
      fullName: _name.text,
      email: _email.text,
      phone: _phone.text,
      bio: _bio.text,
      subject: _canEditSubject ? _subject.text : null,
    );
    _session.setAvatar(_avatarPath);
    AppToast.show(context, 'تم حفظ التعديلات');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'تعديل الملف الشخصي',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: MoreAvatar(
                size: 104.r,
                path: _avatarPath,
                onTap: _changeAvatar,
              ),
            ),
            verticalSpace(height: 24),
            AppTextField(
              controller: _name,
              hintText: 'الاسم الكامل',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: AppValidators.fullName,
              reserveErrorSpace: true,
            ),
            AppTextField(
              controller: _email,
              hintText: 'البريد الإلكتروني',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              validator: AppValidators.email,
              reserveErrorSpace: true,
            ),
            AppTextField(
              controller: _phone,
              hintText: 'رقم الهاتف',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              validator: AppValidators.phone,
              reserveErrorSpace: true,
            ),
            AppTextField(
              controller: _subject,
              hintText: 'المادة التي تدرسها',
              prefixIcon: Icons.menu_book_outlined,
              textInputAction: TextInputAction.next,
              enabled: _canEditSubject,
              helperText: _canEditSubject
                  ? null
                  : 'لا يمكن تغيير المادة بعد إنشاء مجموعات',
              validator: (value) => AppValidators.required(
                value,
                message: 'أدخل المادة التي تدرسها',
              ),
              reserveErrorSpace: true,
            ),
            AppTextField(
              controller: _bio,
              hintText: 'نبذة قصيرة عنك وعن أسلوبك في التدريس',
              prefixIcon: Icons.edit_note_rounded,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 4,
              maxLength: 200,
              reserveErrorSpace: true,
            ),
            verticalSpace(height: 8),
            AppButton(label: 'حفظ التعديلات', onPressed: _save, expanded: true),
          ],
        ),
      ),
    );
  }
}
