import 'package:flutter_starter_kit/core/notifiers/auth/auth_notifiers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/notifiers/theme/theme_notifiers.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    ChangeNotifierProvider(create: (context) => AuthNotifier()),
  ];
}
