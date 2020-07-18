import 'package:checkandchat/chats/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/Activities/activitiesScreens.dart';
import '../Screens/Me/meScreens.dart';
import '../Screens/nearBy.dart';
import '../Providers/change_index_page.dart';
import 'Search/searchScreen.dart';
import '../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  bool isCommingFromFriendPage;
  final String title;
  HomeScreen({Key key, this.title , this.isCommingFromFriendPage = false}): super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 int _selectedIndex = 0;

  List<Widget> _widgets = [
    NearBy(),
    Search(),
    HomeChatScreen(),
    ActivitiesScreen(),
    MeScreens(),
  ];


 @override
 void initState() {
   super.initState();
   if(Provider.of<ChangeIndex>(context, listen: false).index == 4 && widget.isCommingFromFriendPage ==false){
     Provider.of<ChangeIndex>(context, listen: false).changeIndexFunctionWithOutNotify(0);
   }
 }

 bool _pinned;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final _textStyle = Theme.of(context).textTheme.title;
    
    return SafeArea(
          child: Consumer<ChangeIndex>(
            builder: (context,changeIndex,child)=>
            Scaffold(
            body: _widgets[changeIndex.index],
            bottomNavigationBar:
            BottomNavigationBar(
                items:  <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('images/NavBar/nearby.png'),size: _width*0.05,),
                    title: Text(LocaleKeys.nearBy,style: TextStyle(fontSize: _width*0.03),).tr(context: context),
                    activeIcon: ImageIcon(AssetImage('images/NavBar/nearbyfilled.png'),size: _width*0.05,),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search,size: _width*0.06,),
                    title: Text(LocaleKeys.searchBar,style: TextStyle(fontSize: _width*0.03),).tr(context: context),
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('images/meScreenIcons/talk.png'),size: _width*0.06,),
                    title: Text(LocaleKeys.chat,style: TextStyle(fontSize: _width*0.03),).tr(context: context),
                    activeIcon: ImageIcon(AssetImage('images/meScreenIcons/talk.png')),
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('images/NavBar/activity.png'),size: _width*0.06,),
                    title: Text(LocaleKeys.activities,style: TextStyle(fontSize: _width*0.03),).tr(context: context),
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('images/NavBar/me.png'),size: _width*0.06),
                    title: Text(LocaleKeys.me,style: TextStyle(fontSize: _width*0.03),).tr(context: context),
                  ),
                  
                  

                ],
                currentIndex: changeIndex.index,
                onTap: changeIndex.changeIndexFunction,
                type: BottomNavigationBarType.fixed,
                selectedIconTheme: IconThemeData(color: Color(0xffc62828) ,size: 25 ),
                unselectedIconTheme: IconThemeData(color: Colors.black45, size: 25),
                selectedItemColor: Color(0xffc62828),
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),

              ),
            ),

        
      ),
    );
  }
}