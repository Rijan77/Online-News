import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/presentation/views/favorites_page.dart';
import 'package:news_app/features/presentation/views/settings_pages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../features/presentation/views/home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
      Home(
        controller: (_controller),
      ),
      FavoritesPage(),
      SettingsPages(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      // extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.blueGrey.shade100,
              // showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 20.0,

              notchColor: Color(0xff578FCA),
              removeMargins: true,
              bottomBarWidth: MediaQuery.of(context).size.width,
              showShadow: true,
              durationInMilliSeconds: 300,
              textAlign: TextAlign.center,
              itemLabelStyle: const TextStyle(fontSize: 10, height: 1.5),
              elevation: 1,
              bottomBarItems:  [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                    size: 28,
                  ),
                  activeItem: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.home_filled,
                      color: Colors.black,
                      // size: 24,
                    ),
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(

                  inActiveItem: Icon(
                    Icons.favorite,
                    color: Colors.blueGrey,
                    size: 28,
                  ),
                  activeItem: Icon(
                    Icons.favorite,
                    // size: 30,
                    color: Colors.black,
                  ),
                  itemLabel: "Favorite",
                ),
                BottomBarItem(
                  inActiveItem: FaIcon(
                    FontAwesomeIcons.userAstronaut,
                    color: Colors.blueGrey,
                    size: 28,
                  ),
                  activeItem: FaIcon(
                    FontAwesomeIcons.user,
                    color: Colors.black,
                    // size: 30,
                  ),
                  itemLabel: 'Profile',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 26.0,
            )
          : null,
    );
  }
}
