import 'package:flutter/material.dart';
import '../../../../core/widgets/glass/glass_bottom_nav.dart';
import '../../../booking/presentation/pages/bookings_page.dart';
import '../../../hotels/presentation/pages/home_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../wishlist/presentation/pages/wishlist_page.dart';

class MainScaffoldPage extends StatefulWidget {
  final int initialIndex;

  const MainScaffoldPage({super.key, this.initialIndex = 0});

  @override
  State<MainScaffoldPage> createState() => _MainScaffoldPageState();
}

class _MainScaffoldPageState extends State<MainScaffoldPage> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    HomePage(),
    BookingsPage(),
    WishlistPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: GlassBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          GlassNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          GlassNavItem(
            icon: Icons.bookmark_border_rounded,
            activeIcon: Icons.bookmark_rounded,
            label: 'Bookings',
          ),
          GlassNavItem(
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            label: 'Wishlist',
          ),
          GlassNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
