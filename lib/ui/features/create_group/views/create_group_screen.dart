import 'package:chatapp/data/models/group_model.dart';
import 'package:chatapp/ui/features/create_group/cubit/create_group_cubit.dart';
import 'package:chatapp/ui/features/create_group/cubit/create_group_state.dart';
import 'package:chatapp/ui/features/create_group/cubit/users_cubit.dart';
import 'package:chatapp/ui/features/create_group/cubit/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../auth/data/models/login_response_model.dart';
import '../../../core/widgets/app_text_field.dart';
import '../widgets/contact_selection_tile.dart';
import '../widgets/group_avatar_picker.dart';
import '../widgets/member_chip.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final List<User> _selectedContacts = [];
  @override
  void initState() {
    BlocProvider.of<UsersCubit>(context).emitGetUsers();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _toggleContact(User contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  void _removeContact(User user) {
    setState(() {
      _selectedContacts.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<CreateGroupCubit, CreateGroupState>(
      listener: (context, state) {
        if (state is CreateGroupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message ?? 'Group created successfully',
              ),
              backgroundColor: colorScheme.tertiary,
            ),
          );
          Navigator.pop(context);
        } else if (state is CreateGroupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 64.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Center(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: colorScheme.onSurface,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ),
          title: Text('New Group', style: textTheme.titleLarge),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(color: colorScheme.outline, height: 1.h),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GroupAvatarPicker(),
                    SizedBox(height: 24.h),
                    AppTextField(
                      controller: _nameController,
                      hintText: 'Group name',
                    ),
                    SizedBox(height: 12.h),
                    AppTextField(
                      controller: _descController,
                      hintText: 'Group description (optional)',
                    ),
                    SizedBox(height: 24.h),
                    if (_selectedContacts.isNotEmpty) ...[
                      Text(
                        'MEMBERS ADDED (${_selectedContacts.length})',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _selectedContacts.map((user) {
                          return MemberChip(
                            contact: user,
                            onRemove: () => _removeContact(user),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),
                    ],
                    Text(
                      'SELECT CONTACTS',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    BlocBuilder<UsersCubit, UsersState>(
                      builder: (context, state) {
                        if (state is UsersSuccess) {
                          if (state.users.isEmpty) {
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                final contact = state.users[index];
                                final isSelected = _selectedContacts.contains(
                                  contact,
                                );
                                return ContactSelectionTile(
                                  member: contact,
                                  isSelected: isSelected,
                                  onTap: () => _toggleContact(contact),
                                );
                              },
                            );
                          }
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(context, _selectedContacts.length),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 8.h
            : 16.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline, width: 1.h)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: BlocBuilder<CreateGroupCubit, CreateGroupState>(
          builder: (context, state) {
            final isLoading = state is CreateGroupLoading;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<CreateGroupCubit>().emitCreateGroup(
                        request: CreateGroupRequestModel(
                          name: _nameController.text.trim(),
                          members: _selectedContacts
                              .map((contact) => contact.id ?? 0)
                              .toList(),
                          description: _descController.text.trim(),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.primary.withValues(
                  alpha: 0.6,
                ),
                elevation: 4,
                shadowColor: colorScheme.primary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5.w,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      count > 0 ? 'Create Group ($count)' : 'Create Group',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
