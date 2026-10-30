import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../classroom/ui/widgets/classroom_action_row.dart';
import '../../data/more_icons.dart';

enum ImageSourceChoice { gallery, camera, remove }

class PickedImage {
  const PickedImage({this.path});

  final String? path;
}

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key, required this.canRemove});

  final bool canRemove;

  static Future<PickedImage?> choose(
    BuildContext context, {
    bool canRemove = false,
  }) async {
    final choice = await AppBottomSheet.show<ImageSourceChoice>(
      context,
      title: 'اختيار صورة',
      child: ImageSourceSheet(canRemove: canRemove),
    );
    if (choice == null || !context.mounted) return null;
    if (choice == ImageSourceChoice.remove) return const PickedImage();
    try {
      final file = await ImagePicker().pickImage(
        source: choice == ImageSourceChoice.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1280,
        imageQuality: 85,
      );
      if (file == null) return null;
      return PickedImage(path: file.path);
    } catch (_) {
      if (context.mounted) AppToast.show(context, 'تعذر الوصول إلى الصورة');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClassroomActionRow(
          icon: MoreIcons.gallery,
          label: 'اختيار من المعرض',
          color: palette.textPrimary,
          onTap: () => Navigator.of(context).pop(ImageSourceChoice.gallery),
        ),
        verticalSpace(height: 8),
        ClassroomActionRow(
          icon: MoreIcons.cameraOutline,
          label: 'التقاط صورة',
          color: palette.textPrimary,
          onTap: () => Navigator.of(context).pop(ImageSourceChoice.camera),
        ),
        if (canRemove) ...[
          verticalSpace(height: 8),
          ClassroomActionRow(
            icon: MoreIcons.remove,
            label: 'إزالة الصورة',
            color: palette.error,
            onTap: () => Navigator.of(context).pop(ImageSourceChoice.remove),
          ),
        ],
      ],
    );
  }
}
