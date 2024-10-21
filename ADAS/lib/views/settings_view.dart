// ignore_for_file: use_build_context_synchronously

import 'package:adas/app_localizations.dart';
import 'package:adas/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adas/main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final Uri _url = Uri.parse('https://www.adas.amr512.com/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                AppLocalizations.of(context).translate('settings'),
                style: TextStyle(fontSize: 50),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<UiProvider>(
                        builder: (context, UiProvider notifier, child) {
                      return Column(
                        children: [
                          Center(
                            child: DropdownButton<Locale>(
                              value: Localizations.localeOf(context),
                              onChanged: (Locale? newLocale) {
                                MyApp.setLocale(context, newLocale!);
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: Locale('en', ''),
                                  child: Text('English'),
                                ),
                                DropdownMenuItem(
                                  value: Locale('ar', ''),
                                  child: Text('العربية'),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.dark_mode),
                            title: Text(
                                AppLocalizations.of(context).translate('dark')),
                            trailing: Switch(
                                value: notifier.isDark,
                                onChanged: (value) => notifier.changeTheme()),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'ADAS',
                                applicationVersion: '1.0.0',
                                applicationIcon: const Icon(Icons.info),
                                children: [
                                  const Text(
                                      'Welcome to ADAS APP, your ultimate companion for a safer and smarter driving experience.\n Our Team: \n We are a group of dedicated students passionate about technology and innovation. This project is a culmination of our efforts to apply what we’ve learned in our courses to a real-world application. We hope you find our app useful and enjoyable!')
                                  // Add more details about your team here
                                ],
                              );
                            },
                            child: Text(AppLocalizations.of(context)
                                .translate('about')),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: _launchUrl,
                              child: Text(AppLocalizations.of(context)
                                  .translate('visit'))),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
