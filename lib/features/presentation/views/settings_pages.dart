import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/presentation/views/favorites_page.dart';
import 'package:settings_ui/settings_ui.dart';

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isPortrait ? kToolbarHeight : kToolbarHeight * 0.5,
        backgroundColor: Colors.blueGrey.shade200,
        title: Padding(
          padding: const EdgeInsets.only(left: 85),
          child: Text(
            "Settings",
            style: TextStyle(
              fontWeight: isPortrait ? FontWeight.w700 : FontWeight.bold,
              fontSize: isPortrait ? 20 : 20,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<NewsFetchCubit, NewsFetchState>(
        builder: (context, state) {
          return SettingsList(
            sections: [
              SettingsSection(
                title: Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    value: Text(selectedLanguage),
                    onPressed: (context) => showLanguageSelector(),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {},
                    initialValue: true,
                    leading: Icon(Icons.dark_mode),
                    title: Text('Dark Mode'),
                  ),
                  SettingsTile.navigation(
                    leading: Icon(Icons.favorite_rounded),
                    title: Text("Favorite News"),
                    onPressed: (context) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FavoritesPage()),
                      );
                    },
                    trailing: Container(
                      padding: EdgeInsets.all(isPortrait ? 2 : 0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(
                            isPortrait ? 30 : 80),
                      ),
                      constraints: BoxConstraints(
                        minHeight: isPortrait ? 20 : 15,
                        minWidth: isPortrait ? 20 : 15,
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
                  )
                ],
              ),
            ],
          );
        }
      )
    );
  }
}
