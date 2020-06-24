import 'package:flutter/material.dart';

class ContainerDollars extends StatefulWidget {
  @override
  _ContainerDollarsState createState() => _ContainerDollarsState();
}

class _ContainerDollarsState extends State<ContainerDollars> {
  List<String> _dolarsCount = ['free','inexpensive','moderate','expensive','veryExpensive'];
  List<bool> _changeContainerColor = List.generate(5, (index)=>false);
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width,
      height: 40,
      child: Center(
        child: ListView.builder(shrinkWrap: true,itemBuilder: (ctx,index){
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: (){
                setState(() {
                  _changeContainerColor[index] = !_changeContainerColor[index];
                });
              },
              child: Container(
                height: 35,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
                  ,color: _changeContainerColor[index] == false ?Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(child: Text(_dolarsCount[index])),
              ),
            ),
          );
        }
          ,scrollDirection: Axis.horizontal,itemCount: 4,),
      ),
    );
  }
}
