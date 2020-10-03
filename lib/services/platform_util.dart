import 'dart:io';

bool get isDesktop {
  return (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
}

bool get isMobile {
  return (Platform.isAndroid || Platform.isIOS);
}