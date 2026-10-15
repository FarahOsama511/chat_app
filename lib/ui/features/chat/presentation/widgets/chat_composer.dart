import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatComposer extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSend;
  final VoidCallback? onAttachmentTap;
  final bool isSending;

  const ChatComposer({
    super.key,
    required this.hintText,
    required this.onSend,
    this.onAttachmentTap,
    this.isSending = false,
  });

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) {
        setState(() => _hasText = has);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (widget.isSending) return;
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1.w,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Add attachment (+)
              IconButton(
                onPressed: widget.onAttachmentTap,
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 26.sp,
                  color: colorScheme.outlineVariant,
                ),
              ),
              SizedBox(width: 4.w),

              // Message field container (pill)
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.outlineVariant.withValues(alpha: .2),
                    hintText: widget.hintText,
                    hintStyle: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.outlineVariant,
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Send button (circular 44x44)
              InkWell(
                onTap: (_hasText && !widget.isSending) ? _handleSend : null,
                borderRadius: BorderRadius.circular(999.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: _hasText && !widget.isSending
                        ? colorScheme.primary
                        : colorScheme.primary.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: widget.isSending
                        ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
                            Icons.arrow_upward_rounded,
                            size: 22.sp,
                            color: colorScheme.onPrimary,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
