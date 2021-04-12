import 'package:flutter/material.dart';
import 'package:notes/animations/routing/BlurRoute.dart';
import 'package:notes/screen/TopWidget.dart';
import 'package:notes/screen/TopWidgetBase.dart';

class NotesRoutes {
  static const hiddenScreen = '/hidden'; //b
  static const lockScreen = '/lock';
  static const setpassScreen = '/setpass';
  static const homeScreen = '/'; //b
  static const archiveScreen = '/archive'; //b
  static const backupScreen = '/backup';
  static const trashScreen = '/trash'; //b
  static const aboutMeScreen = '/about';
  static const settingsScreen = '/settings';
  static const suggestScreen = '/suggestion';
}

class RouteGenerator {
  /*static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NotesRoutes.hiddenScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Hidden,
            ),
          );
        }
        break;
      case NotesRoutes.lockScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Lock,
            ),
          );
        }
        break;
      case NotesRoutes.homeScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Home,
            ),
          );
        }
        break;
      case NotesRoutes.archiveScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Archive,
            ),
          );
        }
        break;
      case NotesRoutes.backupScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Backup,
            ),
          );
        }
        break;
      case NotesRoutes.trashScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Trash,
            ),
          );
        }
        break;
      case NotesRoutes.aboutMeScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.AboutMe,
            ),
          );
        }
        break;
      case NotesRoutes.settingsScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Settings,
            ),
          );
        }
        break;
      case NotesRoutes.setpassScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Setpass,
            ),
          );
        }
        break;
      default:
        return _errorRoute();
    }
  }*/
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NotesRoutes.hiddenScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Hidden,
            ),
          );
        }
        break;
      case NotesRoutes.lockScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Lock,
            ),
          );
        }
        break;
      case NotesRoutes.homeScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Home,
            ),
          );
        }
        break;
      case NotesRoutes.archiveScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Archive,
            ),
          );
        }
        break;
      case NotesRoutes.backupScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Backup,
            ),
          );
        }
        break;
      case NotesRoutes.trashScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Trash,
            ),
          );
        }
        break;
      case NotesRoutes.aboutMeScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.AboutMe,
            ),
          );
        }
        break;
      case NotesRoutes.settingsScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Settings,
            ),
          );
        }
        break;
      case NotesRoutes.setpassScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Setpass,
            ),
          );
        }
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return BlurPageRoute(builder: (context) {
      return const ErrorScreen();
    });
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Are you lost baby girl ?'),
      ),
    );
  }
}
