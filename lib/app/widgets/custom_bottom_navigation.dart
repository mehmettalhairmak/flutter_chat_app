import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/items/tab_item.dart';

class CustomBottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomBottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.pageCreator,
    required this.navigatorKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _bottomNavigationBarItem(TabItem.Users),
          _bottomNavigationBarItem(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final currentItem = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[currentItem],
          builder: (context) => pageCreator[currentItem]!,
        );
      },
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(TabItem item) {
    final _currentTab = TabItemData.allTabs[item];

    return BottomNavigationBarItem(
      icon: Icon(_currentTab!.icon),
      label: _currentTab.title,
    );
  }
}
