import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/utils/constants.dart';
import 'core/di/injection_container.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();

  runApp(
    isDevelopment
        ? DevicePreview(enabled: true, builder: (context) => const MyApp())
        : const MyApp(),
  );
}
