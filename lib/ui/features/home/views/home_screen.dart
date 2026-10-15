import 'package:chatapp/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_bar_header.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../chats/views/chats_view.dart';
import '../../groups/views/groups_view.dart';
import '../../profile/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const HomeScreen({super.key, this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 0: Chats, 1: Groups, 2: Profile
  bool _isSearchOpen = false;

  void _navigateToCreateGroup() {
    context.push(Routes.createGroup);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final List<Widget> screens = [
      const ChatsView(),
      GroupsView(onCreateGroupTap: _navigateToCreateGroup),
      ProfileScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      appBar: _currentIndex != 2
          ? AppBarHeader(
              isSearchOpen: _isSearchOpen,
              onSearchToggle: (isOpen) {
                setState(() => _isSearchOpen = isOpen);
              },
              onProfileTap: () {
                setState(() => _currentIndex = 2);
              },
              profileAvatarUrl:
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
            )
          : AppBar(
              centerTitle: true,
              title: Text('Profile', style: textTheme.titleLarge),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.h),
                child: Container(color: colorScheme.outline, height: 1.h),
              ),
            ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_isSearchOpen) {
              _isSearchOpen = false;
            }
          });
        },
      ),
    );
  }
}
