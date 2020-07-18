import 'package:flutter/material.dart';

class MoreInfo extends StatelessWidget {
 Widget _iconWithTitle({IconData icon,String title}){
   return  ListTile(leading: Icon(icon),title: Text(title,style: TextStyle(color: Colors.black,fontSize: 16),),);
 }
 Widget _daysWithAvilableTime({String dayName,String avilableTime}){
   return ListTile(
     leading: Text( dayName,style: TextStyle(color: Colors.black,fontSize: 16),),
     trailing: Text(avilableTime,style: TextStyle(color: Colors.black,fontSize: 16),),
   );
 }
 Divider _divider() {
   return Divider(
     color: Colors.grey,
     thickness: 1.0,
     height: 1,
   );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text('More Info',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body:
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                type: MaterialType.card,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 5.0),
                        child: Text('Info',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
              _divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Open ',style: TextStyle(color: Colors.blue,fontSize: 16),),
                            Text('until 9:30 PM',style: TextStyle(color: Colors.black,fontSize: 16),),
                          ],
                        ),
                      ),
                      _daysWithAvilableTime(dayName: 'Monday',avilableTime: '11:00 AM . 9:30 PM'),
                      _daysWithAvilableTime(dayName: 'Tuesday',avilableTime: '11:00 AM . 9:30 PM'),
                      _daysWithAvilableTime(dayName: 'Wednesday',avilableTime: '11:00 AM . 9:30 PM'),
                      _daysWithAvilableTime(dayName: 'Thurday',avilableTime: '11:00 AM . 9:30 PM'),
                      _daysWithAvilableTime(dayName: 'Friday',avilableTime: '11:00 AM . 9:30 PM'),
                      _daysWithAvilableTime(dayName: 'Saturday',avilableTime: '11:00 AM . 9:30 PM'),
                      _daysWithAvilableTime(dayName: 'Sunday',avilableTime: '11:00 AM . 9:30 PM'),
                    ],
                  ),
                ),
              ),
SizedBox(height: 10.0,),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                type: MaterialType.card,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 5.0),
                        child: Text('Features',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      _divider(),
                      _iconWithTitle(icon: Icons.calendar_today,title: 'Reservation'),
                      _iconWithTitle(icon: Icons.shopping_basket,title: 'Takeout'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                type: MaterialType.card,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 5.0),
                        child: Text('Payments',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      _divider(),
                     _iconWithTitle(icon: Icons.check,title: 'Credit Cards'),
                      _iconWithTitle(icon: Icons.not_interested,title: 'Apple Pay'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                type: MaterialType.card,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 5.0),
                        child: Text('Amenities',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      _divider(),
                      _iconWithTitle(icon: Icons.directions_car,title: 'No Outdoor Seating'),
                      _iconWithTitle(icon: Icons.timer,title: 'Casual Ambience'),
                      _iconWithTitle(icon: Icons.volume_up,title: 'Moderate Noise'),
                      _iconWithTitle(icon: Icons.people,title: 'Good for Groups'),
                      _iconWithTitle(icon: Icons.face,title: 'Good for Kids'),
                      _iconWithTitle(icon: Icons.favorite_border,title: 'Good for Lunch'),
                      _iconWithTitle(icon: Icons.directions_bike,title: 'Bike Parking'),
                      _iconWithTitle(icon: Icons.wifi,title: 'No Wi-Fi'),
                      _iconWithTitle(icon: Icons.beach_access,title: 'Beer & Wine Only'),
                      _iconWithTitle(icon: Icons.tv,title: 'TV'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                type: MaterialType.card,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 5.0),
                        child: Text('Specialties',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      _divider(),
                     SizedBox(height: 8.0,),
                      Text(' Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties ',maxLines: 6,style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.bold,),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                type: MaterialType.card,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 5.0),
                        child: Text('History',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      _divider(),
                      SizedBox(height: 8.0,), Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 12.0),
                        child: Text('Established in 1978',style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.bold,),),
                      ),
                      Text(' Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties  Specialties ',maxLines: 8,style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.bold,),),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 12.0),
                        child: Text('We look forward to seeing you soon!',style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }
}
