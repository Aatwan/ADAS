import 'package:adas/provider/provider.dart';
import 'package:adas/provider/bluetooth_provider.dart';
import 'package:adas/provider/guide_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UiProvider()..init()),
        ChangeNotifierProvider(create: (context) => BluetoothProvider()),
        ChangeNotifierProvider(create: (context) => GuideProvider()),
      ],
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ADAS',
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme:
                notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            locale: _locale,
            home: const AppRouter(),
          );
        },
      ),
    );
  }
}
