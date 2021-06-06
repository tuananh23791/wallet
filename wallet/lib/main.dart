import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'struct/router.dart';
import 'utils/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: purple,
        systemNavigationBarColor: purple,
        systemNavigationBarIconBrightness: Brightness.light),
    child: router(),
  ));
}
