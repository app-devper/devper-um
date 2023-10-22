import 'package:common/config/app_config.dart';
import 'package:common/core/theme/theme.dart';
import 'package:common/localizations/localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/core/router/router.dart';
import 'package:um/container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.forEnvironment("dev");
  di.setupLogging();
  await di.initCore(config);
  await di.initUm();
  runApp(const DevperUm());
}

class DevperUm extends StatefulWidget {
  const DevperUm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<DevperUm> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevperUM',
      theme: CustomTheme.mainTheme,
      onGenerateRoute: RouterUm.generateRoute,
      initialRoute: routeSplash,
      locale: const Locale("th"),
      localizationsDelegates: [
        CommonLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', ''),
        Locale('en', ''),
      ],
    );
  }
}
