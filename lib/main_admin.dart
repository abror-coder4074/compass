import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'admin/admin_app.dart';
import 'admin/supabase_admin_repository.dart';
import 'data/compass_models.dart';

const Size _adminWindowSize = Size(1440, 900);
const Size _adminMinimumWindowSize = Size(1180, 720);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: CompassConfig.supabaseUrl,
    anonKey: CompassConfig.supabasePublishableKey,
  );
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: _adminWindowSize,
    minimumSize: _adminMinimumWindowSize,
    center: true,
    title: 'Compass Admin',
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitle('Compass Admin');
    await windowManager.setResizable(true);
    await windowManager.setMinimizable(true);
    await windowManager.setMaximizable(true);
    await windowManager.setPreventClose(false);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(AdminApp(repository: SupabaseAdminRepository()));
}
