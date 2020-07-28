import 'package:flutter/material.dart';
import '../../../Screens/Me/meWidgets/moreWidgets.dart/settings.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    bool _isTapped = false;


  Divider _divider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1.0,
      height: 1,
    );
  }    

  Widget _createListButton({Widget icon1,IconData icon2, Text text, Function function , Widget route}){
      return InkWell(
        onTap:function,
        child: ListTile(
          dense: true,
          title: Row(
                    children: <Widget>[
                      icon1,
                      Padding(padding: EdgeInsets.only(right:_width*0.03),),
                      text,
                      Spacer(),
                      Icon(icon2,color: Colors.black38,size: 15,)
                    ],
                  ),
        )
        );
    }


    Widget _expantion ({Widget icon1,IconData icon2, Text titleText, Widget text, Function function }){
      return ExpansionTile(
        trailing: Icon(icon2,color: Colors.black38),
        title: Row(
                    children: <Widget>[
                      icon1,
                      Padding(padding: EdgeInsets.only(right:_width*0.03),),
                      titleText,
                      
                      
                    ],
                  ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text,
          )
        ],
        
        );
    }
    return Scaffold(
      appBar: AppBar(
    automaticallyImplyLeading: false,        
        titleSpacing: 0.0,
        title:Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      Text(LocaleKeys.more.tr(),style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
    ],
  ),
        backgroundColor: Color(0xffc62828),
      ),
      body: ListView(
        children: <Widget>[
          _divider(),          
          // _createListButton(
          //             icon1: ImageIcon(AssetImage('images/meScreenIcons/app.png')),
          //             icon2: Icons.arrow_forward_ios,
          //             text: Text('Settings',style: TextStyle(color: Colors.grey[850],fontSize: _width*0.035,fontWeight: FontWeight.w700)),
          //             function: (){
          //               Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
          //             }
          //              ),
          //  _divider(),          
          _expantion(
                      icon1: ImageIcon(AssetImage('images/meScreenIcons/instractions.png')),
                      icon2: Icons.expand_more,
                      titleText:  Text(LocaleKeys.instructions.tr(),style: TextStyle(color: Colors.grey[700],fontSize: _width*0.035,fontWeight: FontWeight.w700,fontFamily: 'Cairo')),
                      text: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(LocaleKeys.instructionsDsc.tr(),
                        style: TextStyle(color: Colors.grey[700],fontSize: _width*0.035)),
                      ) 
                    ),
          _divider(),
          _expantion(
                      icon1: ImageIcon(AssetImage('images/meScreenIcons/instractions.png')),
                      icon2: Icons.expand_more,
                      titleText:  Text(LocaleKeys.about.tr(),style: TextStyle(color: Colors.grey[700],fontSize: _width*0.035,fontWeight: FontWeight.w700,fontFamily: 'Cairo')),
                      text: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(LocaleKeys.aboutDsc.tr(),
                        style: TextStyle(color: Colors.grey[700],fontSize: _width*0.035,)),
                      ) 
                      
                       ),
          _divider(),
                                                
        ],
      ),
    
    );
  }
}