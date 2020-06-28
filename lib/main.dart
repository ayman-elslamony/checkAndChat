import 'package:checkandchat/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import './Providers/Auth.dart';
import './Screens/Collections/collections.dart';
import './Screens/Me/meScreens.dart';
import './Screens/sign_up/sign_up.dart';
import 'Providers/Auth.dart';
import 'Providers/change_index_page.dart';
import 'Providers/list_of_photos.dart';
import 'Providers/resturants.dart';
import 'Providers/user_data.dart';
import 'Screens/Activities/activitiesScreens.dart';
import 'Screens/Search/searchScreen.dart';
import 'Screens/homeScreen.dart';
import 'Screens/splash_screen.dart';
import './services/services.dart';
import 'package:flutter/services.dart' ;
import 'package:checkandchat/chats/const.dart';
import 'dart:ui';
import 'dart:developer';
import 'generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';



void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    setupServiceLocator();
    runApp(EasyLocalization(

        child: MyApp(),
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'DZ'),
          Locale('de', 'DE'),
          Locale('ru', 'RU')
        ],

        path: 'resources/langs/langs.csv', //'resources/langs',
        // fallbackLocale: Locale('en', 'US'),
        // startLocale: Locale('de', 'DE'),
        // saveLocale: false,
        // useOnlyLangCode: true,
        // preloaderColor: Colors.black,
        // preloaderWidget: CustomPreloaderWidget(),

        // optional assetLoader default used is RootBundleAssetLoader which uses flutter's assetloader
        // install easy_localization_loader for enable custom loaders
        // assetLoader: RootBundleAssetLoader()
        // assetLoader: HttpAssetLoader()
        // assetLoader: FileAssetLoader()
        assetLoader: CsvAssetLoader()
      // assetLoader: YamlAssetLoader() //multiple files
      // assetLoader: YamlSingleAssetLoader() //single file
      // assetLoader: XmlAssetLoader() //multiple files
      // assetLoader: XmlSingleAssetLoader() //single file
      // assetLoader: CodegenLoader()
    ));
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      child:MaterialApp(
        title: 'Check And Chat',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          primaryColor: themeColor,
          fontFamily: 'Cairo',
          primarySwatch: Colors.red,
          accentColor: Colors.white,
          cardTheme: CardTheme(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
                title: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xffc62828),
                    fontWeight: FontWeight.bold,
                    fontSize: 19)),
            color: Colors.red,
            iconTheme: IconThemeData(
              color: Color(0xffc62828),

            ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
              display1: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 19,
                  color: Color(0xffc62828),
                  fontWeight: FontWeight.bold),
              display2: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              display3: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
              body2: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 19,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
              body1: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              title: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold)),
        ),
        home:CheckAndChat(),
        routes: <String, WidgetBuilder>{
          'NearBy': (BuildContext context) => HomeScreen(),
          'Me': (BuildContext context) => MeScreens(),
          'Activities': (BuildContext context) => ActivitiesScreen(),
          'Collections': (BuildContext context) => Collections(),
          Search.routeName: (BuildContext context) => Search(),
        },
      ), providers: [
      ChangeNotifierProvider.value(
        value: Auth(),
      ),
      ChangeNotifierProvider.value(
        value: UserData(),
      ),
      ChangeNotifierProvider.value(value: ChangeIndex(),),
      ChangeNotifierProvider.value(value: ListOfPhotos(),),
      ChangeNotifierProvider.value(value: Categorys(),),
    ],

    );
  }
}
class CheckAndChat extends StatefulWidget {
  @override
  _CheckAndChatState createState() => _CheckAndChatState();
}

class _CheckAndChatState extends State<CheckAndChat> {
  Auth _auth ;//= GetIt.instance<Auth>();
  @override
  void initState() {
    _auth =Provider.of<Auth>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return _auth.isAuth? HomeScreen():
    FutureBuilder(
        future: _auth.tryToLogin(),
        builder: (ctx, authResultSnapshot) {
          if (authResultSnapshot.connectionState ==
              ConnectionState.done && _auth.isAuth) {
            return HomeScreen();
          }else if (authResultSnapshot.connectionState ==
              ConnectionState.waiting ||
              authResultSnapshot.connectionState ==
                  ConnectionState.active && !_auth.isAuth) {
            return Splash();
          }
          else{
            return SignUp();
          }
        }
    );
  }
}