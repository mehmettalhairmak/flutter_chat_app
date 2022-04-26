// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TabItem { Users, MyChat, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users: TabItemData('Kullanıcılar', Icons.supervised_user_circle),
    TabItem.MyChat: TabItemData("Konuşmalarım", Icons.chat),
    TabItem.Profile: TabItemData('Profil', Icons.person)
  };
}
