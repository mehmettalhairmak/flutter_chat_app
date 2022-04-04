import 'package:flutter/material.dart';
import 'package:flutter_chat_app/items/tab_item.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/app/pages/profile.dart';
import 'package:flutter_chat_app/app/pages/users.dart';
import 'package:flutter_chat_app/app/widgets/custom_bottom_navigation.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final UserModel? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Users: const UsersPage(),
      TabItem.Profile: const ProfilePage()
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CustomBottomNavigation(
        currentTab: _currentTab,
        navigatorKeys: navigatorKeys,
        pageCreator: allPages(),
        onSelectedTab: (selectedTab) {
          if (selectedTab == _currentTab) {
            navigatorKeys[selectedTab]!
                .currentState!
                .popUntil((route) => route.isFirst);
          }
          setState(() {
            _currentTab = selectedTab;
          });

          debugPrint('Seçilen Tab Item : ${selectedTab.toString()}');
        },
      ),
    );
  }
}
