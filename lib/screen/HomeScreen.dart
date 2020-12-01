import 'package:flutter/material.dart';
import 'package:flutter_localization_app/Widget/RadioItem.dart';
import 'package:flutter_localization_app/constant/Constant.dart';
import 'package:flutter_localization_app/localization/localizations.dart';
import 'package:flutter_localization_app/model/LanguageModel.dart';
import 'package:flutter_localization_app/screen/SplashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  AppLocalizationsDelegate _localeOverrideDelegate =
      AppLocalizationsDelegate(Locale('en', 'US'));

  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();

    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
          title: 'Localization Demo',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(primarySwatch: Colors.blue),
          home: new SplashScreen(),
          localizationsDelegates: [
            _localeOverrideDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English
            const Locale('hi', ''),
            const Locale('ar', ''), // Hindi
          ],
          locale: locale,
          routes: <String, WidgetBuilder>{
            HOME_SCREEN: (BuildContext context) => new HomeScreen(),
          });
    }
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    return Locale(
        prefs.getString('languageCode'), prefs.getString('countryCode'));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<LanguageModel> _langList = new List<LanguageModel>();

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _initLanguage();
  }

  bool isDevicePlatformAndroid() {
    return Theme.of(context).platform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: AppBar(
          elevation: isDevicePlatformAndroid() ? 0.2 : 0.0,
          backgroundColor: const Color(0xFFF6F8FA),
          title: new Center(
            child: new Text(
              AppLocalizations.of(context).appNameShort,
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: new Container(
            child: new Column(
          children: <Widget>[
            _buildMainWidget(),
            _buildLanguageWidget(),
          ],
        )));
  }

  Widget _buildMainWidget() {
    return new Flexible(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildHeaderWidget(),
            _buildTitleWidget(),
            _buildDescWidget(),
          ],
        ),
      ),
      flex: 9,
    );
  }

  Widget _buildHeaderWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
        height: 160.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(
            new Radius.circular(8.0),
          ),
          image: new DecorationImage(
            fit: BoxFit.contain,
            image: new AssetImage(
              'assets/images/ic_banner.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return new Container(
      margin: EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
      child: Text(
        AppLocalizations.of(context).title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
        child: Text(
          AppLocalizations.of(context).desc,
          style: TextStyle(
              color: Colors.black87,
              inherit: true,
              fontSize: 13.0,
              wordSpacing: 8.0),
        ),
      ),
    );
  }

  Widget _buildLanguageWidget() {
    return new Flexible(
      child: Container(
        padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        margin: EdgeInsets.only(left: 4.0, right: 4.0),
        color: Colors.grey[100],
        child: ListView.builder(
          itemCount: _langList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              splashColor: Colors.blueAccent,
              onTap: () {
                setState(() {
                  _langList.forEach((element) => element.isSelected = false);
                  _langList[index].isSelected = true;
                  _index = index;
                  _handleRadioValueChanged();
                });
              },
              child: RadioItem(_langList[index]),
            );
          },
        ),
      ),
    );
  }

  Future<String> _getLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    return prefs.getString('languageCode');
  }

  void _initLanguage() async {
    Future<String> status = _getLanguageCode();
    status.then((result) {
      if (result != null && result.compareTo('en') == 0) {
        setState(() {
          _index = 0;
        });
      }
      if (result != null && result.compareTo('hi') == 0) {
        setState(() {
          _index = 2;
        });
      }
      if (result != null && result.compareTo('ar') == 0) {
        setState(() {
          _index = 1;
        });
      } else {
        setState(() {
          _index = 0;
        });
      }
      _setupLangList();
    });
  }

  void _setupLangList() {
    setState(() {
      _langList = LanguageModel.langList;
    });
  }

  void _updateLocale(String lang, String country) async {
    print(lang + ':' + country);

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', lang);
    prefs.setString('countryCode', country);
    AppLocalizations.of(context).load(Locale(lang, country));
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());
    state.setState(() {
      state.locale = AppLocalizations.of(context).locale;
    });
  }

  void _handleRadioValueChanged() {
    setState(() {
      switch (_index) {
        case 0:
          _updateLocale('en', '');
          break;
        case 1:
          _updateLocale('ar', '');
          break;
        case 2:
          _updateLocale('hi', '');
          break;
      }
    });
  }
}
