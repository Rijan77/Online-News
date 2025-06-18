import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/presentation/views/favorites_page.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../core/common/widgets/bottom_nav.dart';
import '../bloc/news_fetch_cubit.dart';
import '../bloc/news_fetch_state.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({super.key});

  @override
  State<SettingsPages> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  List languageList = ['English', 'Nepali', 'Hindi'];
  String selectedLanguage = "English";

  final currentUser = FirebaseAuth.instance.currentUser;

  late bool isDark = false;

  void showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
            itemCount: languageList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(languageList[index]),
                trailing: languageList[index] == selectedLanguage
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = languageList[index];
                  });
                  Navigator.pop(context);
                },
              );
            });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    String emailAddress = currentUser?.email ?? "No User Found";
    final splitted = emailAddress.split('@');



    return Scaffold(
        appBar: AppBar(
          toolbarHeight: isPortrait ? kToolbarHeight : kToolbarHeight * 0.5,
          leading: Icon(Icons.settings),
          title: Text(
            "Settings",
            style: TextStyle(
              fontWeight: isPortrait ? FontWeight.w700 : FontWeight.bold,
              fontSize: isPortrait ? 20 : 20,
            ),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, size: 35),
          //   onPressed: () => Navigator.pop(context),
          // ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 26),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade400,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                          child: Image.asset(
                        "Assets/user-profile-icon.png",
                        color: Colors.grey,
                      )),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello, \n ${splitted[0]}",
                            style: TextStyle(color: Colors.white, fontSize: 20))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<NewsFetchCubit, NewsFetchState>(builder: (
                context,
                state,
              ) {
                return SettingsList(
                  sections: [
                    SettingsSection(
                      title: Text(
                        'Common',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: Icon(Icons.language),
                          title: Text('Language'),
                          value: Text(selectedLanguage),
                          onPressed: (context) => showLanguageSelector(),
                        ),
                        SettingsTile.switchTile(
                          onToggle: (value) {
                            setState(() {
                              isDark = value;
                            });
                          },
                          initialValue: isDark,
                          leading: Icon(Icons.dark_mode),
                          title: Text('Dark Mode'),
                        ),
                        SettingsTile.navigation(
                          leading: Icon(Icons.favorite_rounded),
                          title: Text("Favorite News"),
                          onPressed: (context) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => FavoritesPage()),
                            );
                          },
                          trailing: Container(
                            padding: EdgeInsets.all(isPortrait ? 2 : 0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.circular(isPortrait ? 30 : 80),
                            ),
                            constraints: BoxConstraints(
                              minHeight: isPortrait ? 25 : 15,
                              minWidth: isPortrait ? 25 : 15,
                            ),
                            child: Center(
                              child: Text(
                                state.articleIds.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isPortrait ? 12 : 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: Text(
                        "Account",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      tiles: [
                        SettingsTile.navigation(
                          title: Text("Edit Profile"),
                          leading: Icon(Icons.edit),
                        ),
                        SettingsTile.navigation(
                          leading: Icon(Icons.logout),
                          title: Text("Logout"),
                          onPressed: (context) {
                            Navigator.pop(context, '/');
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),

    );
  }
}
