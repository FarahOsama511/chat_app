import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({super.key});

  static Future<SelectedAttachment?> show(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<SelectedAttachment>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => const AttachmentBottomSheet(),
    );
  }

  Future<void> _pickCamera(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.camera);
      if (file != null && context.mounted) {
        Navigator.pop(
          context,
          SelectedAttachment(type: 'image', path: file.path, name: file.name),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take photo: $e')),
        ); //return object contain all data of file
      }
    }
  }

  Future<void> _pickGalleryImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null && context.mounted) {
        Navigator.pop(
          context,
          SelectedAttachment(type: 'image', path: file.path, name: file.name),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickVideo(source: ImageSource.gallery);
      if (file != null && context.mounted) {
        Navigator.pop(
          context,
          SelectedAttachment(type: 'video', path: file.path, name: file.name),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick video: $e')));
      }
    }
  }

  Future<void> _pickAudio(BuildContext context) async {
    try {
      final file = await FilePicker.pickFile(type: FileType.audio);
      if (file != null && file.path != null && context.mounted) {
        Navigator.pop(
          context,
          SelectedAttachment(type: 'audio', path: file.path!, name: file.name),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick audio: $e')));
      }
    }
  }

  Future<void> _pickDocument(BuildContext context) async {
    try {
      final file = await FilePicker.pickFile(type: FileType.any);
      if (file != null && file.path != null && context.mounted) {
        Navigator.pop(
          context,
          SelectedAttachment(type: 'file', path: file.path!, name: file.name),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick document: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final options = [
      _OptionItem(
        icon: Icons.camera_alt_rounded,
        label: 'Camera',
        color: colorScheme.primary,
        onTap: () => _pickCamera(context),
      ),
      _OptionItem(
        icon: Icons.photo_library_rounded,
        label: 'Gallery',
        color: colorScheme.secondary,
        onTap: () => _pickGalleryImage(context),
      ),
      _OptionItem(
        icon: Icons.videocam_rounded,
        label: 'Video',
        color: colorScheme.error,
        onTap: () => _pickVideo(context),
      ),
      _OptionItem(
        icon: Icons.mic_rounded,
        label: 'Audio',
        color: colorScheme.tertiary,
        onTap: () => _pickAudio(context),
      ),
      _OptionItem(
        icon: Icons.insert_drive_file_rounded,
        label: 'Document',
        color: colorScheme.primary,
        onTap: () => _pickDocument(context),
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              'Share Content',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 20.h),

            // Options Row / Wrap
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              alignment: WrapAlignment.center,
              children: options
                  .map((opt) => _buildOptionButton(context, opt))
                  .toList(),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, _OptionItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: 68.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(item.icon, size: 24.sp, color: item.color),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class SelectedAttachment {
  final String type;
  final String path;
  final String name;

  const SelectedAttachment({
    required this.type,
    required this.path,
    required this.name,
  });
}
