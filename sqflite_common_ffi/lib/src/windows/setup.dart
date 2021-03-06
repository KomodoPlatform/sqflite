import 'dart:ffi';
import 'dart:io';

import 'package:moor_ffi/database.dart';
import 'package:moor_ffi/open_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/src/windows/setup_impl.dart';

/// One windows load the embedded sqlite3.dll for convenience
void windowsInit() {
  var location = findPackagePath(Directory.current.path);
  var path = normalize(join(location, 'src', 'windows', 'sqlite3.dll'));
  open.overrideFor(OperatingSystem.windows, () {
    // devPrint('loading $path');
    try {
      return DynamicLibrary.open(path);
    } catch (e) {
      stderr.writeln('Failed to load sqlite3.dll at $path');
      rethrow;
    }
  });

  // Force an open in the main isolate
  // Loading from an isolate seems to break on windows
  Database.memory()..close();
}
