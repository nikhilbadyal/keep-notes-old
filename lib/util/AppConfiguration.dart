import 'package:flutter/material.dart';
import 'package:notes/util/Utilites.dart';

Color defaultPrimary = Colors.deepPurple;
Color selectedPrimaryColor;

Color defaultAccent = Colors.yellow;
Color selectedAccentColor;

IconColorStatus selectedIconColorStatus;
Color selectedIconColor;

AppTheme selectedAppTheme;

const Color greyColor = Color(0xFFEAEAEA);
const Color blackColor = Color(0xFF1C1C1C);

List<Color> appColors = <Color>[
  Colors.red,
// Colors.redAccent,
  Colors.pink,
// Colors.pinkAccent,
  Colors.purple,
// Colors.purpleAccent,
  Colors.deepPurple,
// Colors.deepPurpleAccent,
  Colors.indigo,
// Colors.indigoAccent,
  Colors.blue,
// Colors.blueAccent,
  Colors.lightBlue,
// Colors.lightBlueAccent,
  Colors.cyan,
// Colors.cyanAccent,
  Colors.teal,
// Colors.tealAccent,
  Colors.green,
// Colors.greenAccent,
  Colors.lightGreen,
// Colors.lightGreenAccent,
  Colors.lime,
// Colors.limeAccent,
//   Colors.yellow,
// Colors.yellowAccent,
//   Colors.amber,
// Colors.amberAccent,
  Colors.orange,
// Colors.orangeAccent,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  //TODO fix this
  // Colors.black,

// Colors.deepOrangeAccent,
];

var shadow = [
  BoxShadow(
    color: Colors.grey[200],
    blurRadius: 30,
    offset: const Offset(0, 10),
  )
];
/*
Color darken(Color color, [double amount = .1],) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1],) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}*/
Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  final f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  final p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

enum AppTheme { Dark, Black, Light }

class AppConfiguration with ChangeNotifier {
  AppConfiguration() {
    initConfig();
  }

  Color _primaryColor;
  Color _accentColor;
  AppTheme _appTheme;
  IconColorStatus _iconColorStatus;
  Color _iconColor;

  AppTheme get appTheme => _appTheme;

  IconColorStatus get iconColorStatus => _iconColorStatus;

  Color get primaryColor => _primaryColor;

  Color get accentColor => _accentColor;

  Color get iconColor => _iconColor;

  void changePrimaryColor(Color primary, {bool write = false}) {
    _primaryColor = primary;

    if (write) {
      Utilities.addIntToSF('primaryColor', selectedPrimaryColor.value);
    } else {
      debugPrint('Notifying listener');
      notifyListeners();
    }
  }

  void changeAccentColor(Color accentColor, {bool write = false}) {
    _accentColor = accentColor;
    if (write) {
      Utilities.addIntToSF('accentColor', selectedAccentColor.value);
    } else {
      notifyListeners();
    }
  }

  void changeAppThemeColor(AppTheme appTheme, {bool write = false}) {
    _appTheme = appTheme;

    if (write) {
      Utilities.addIntToSF('appTheme', _appTheme.index);
    }
    notifyListeners();
  }

  void changeIconColor(IconColorStatus iconColorStatus, {Color pickedColor}) {
    _iconColorStatus = iconColorStatus;
    Utilities.addIntToSF('iconColorStatus', iconColorStatus.index);
    if (_iconColorStatus == IconColorStatus.PickedColor) {
      Utilities.addIntToSF('iconColor', pickedColor.value);
    }
  }

  void initConfig() {
    var intVal = Utilities.getIntValuesSF('primaryColor');
    if (intVal == null) {
      _primaryColor = defaultPrimary;
    } else {
      _primaryColor = Color(intVal);
    }
    selectedPrimaryColor = _primaryColor;

    intVal = null;
    intVal = Utilities.getIntValuesSF('accentColor');
    if (intVal == null) {
      _accentColor = defaultAccent;
    } else {
      _accentColor = Color(intVal);
    }
    selectedAccentColor = _accentColor;

    intVal = null;
    intVal = Utilities.getIntValuesSF('appTheme');
    if (intVal == null) {
      _appTheme = AppTheme.Light;
    } else {
      _appTheme = AppTheme.values[intVal];
    }
    selectedAppTheme = _appTheme;

    intVal = null;
    intVal = Utilities.getIntValuesSF('iconColorStatus');
    if (intVal == null) {
      _iconColorStatus = IconColorStatus.NoColor;
    } else {
      _iconColorStatus = IconColorStatus.values[intVal];
    }
    selectedIconColorStatus = _iconColorStatus;

    intVal = null;
    intVal = Utilities.getIntValuesSF('iconColor');
    if (intVal == null) {
      switch (_iconColorStatus) {
        case IconColorStatus.NoColor:
          _iconColor =
              _appTheme == AppTheme.Light ? Colors.black : Colors.black;
          break;
        case IconColorStatus.RandomColor:
          _iconColor = getRandomColor();
          break;
        case IconColorStatus.UiColor:
          _iconColor = primaryColor;
          break;
        default:
          break;
      }
    } else {
      _iconColor = Color(intVal);
    }
    selectedIconColor = _iconColor;
  }
}
