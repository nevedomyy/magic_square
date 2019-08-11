import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
          child: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: Image.asset(
                  'assets/bgr.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Square()
            ],
          )
      )
    );
  }
}

class Square extends StatefulWidget {
   @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  final List<int> _border = [0,1,2,3,4,5,6,12,18,24,30];
  List<int> _list;
  bool _win = false;

  @override
  initState() {
    super.initState();
    _list = List.generate(36, (i) => i-5-i~/6);
    _check();
  }

  _check() async{
    _border.forEach((i){_list[i] = 0;});
    for(int i=1; i<=5; i++){
      _list[0] += _list[7*i];
      for(int j=1; j<=5; j++){
        _list[i] += _list[6*j+i];
        _list[6*i] += _list[6*i+j];
      }
    }
    _win = true;
    for(int i in _border){
      if(_list[i] != 65){
        _win = false;
        break;
      }
    }
    setState(() {});
  }

  Widget _w(int index, double width){
    return SizedBox(
      width: width/6-4,
      height: width/6-4,
      child: Material(
        color: Color.fromRGBO(250, 250, 250, 0.3),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Center(
          child: Text(
            _list[index].toString(),
            style: TextStyle(color: Colors.black, fontSize: 30.0, fontFamily: 'ChinaCyr'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width-32.0;
   return Material(
     color: Colors.transparent,
     child: SafeArea(
       child: Column(
         children: <Widget>[
           SizedBox(height: 10.0),
           Center(
             child: Text(
               'Магический квадрат',
               style: TextStyle(color: Colors.black87, fontSize: 40.0, fontFamily: 'ChinaCyr'),
               textAlign: TextAlign.center,
             ),
           ),
           Spacer(),
           Padding(
             padding: EdgeInsets.all(16.0),
             child: Center(
               child: Text(
                 'Цель: расположить числа таким образом, чтобы сумма элементов в строках, столбцах и на главных диагоналях = 65',
                 style: TextStyle(color: Colors.black54, fontSize: 20.0, fontFamily: 'ChinaCyr', fontWeight: FontWeight.bold),
               ),
             ),
           ),
           Padding(
               padding: EdgeInsets.all(16.0),
               child: Wrap(
                 spacing: 2.0,
                 children: List.generate(36, (index){
                   if(_border.contains(index)){
                     return SizedBox(
                       width: width/6-4,
                       height: width/6-4,
                       child: Center(
                         child: Text(
                           _list[index].toString(),
                           style: TextStyle(color: _win ? Colors.green[900] : Colors.red[900], fontSize: 20.0, fontFamily: 'ChinaCyr'),
                         ),
                       ),
                     );
                   }
                   return DragTarget(
                       key: Key(index.toString()),
                       builder: (context, List<String> candidateData, rejectedData) {
                         return Draggable(
                           data: index.toString(),
                           child: _w(index, width),
                           feedback: _w(index, width),
                           childWhenDragging: SizedBox(width: width/6-4, height: width/6-4),
                         );
                       }, onWillAccept: (data) {
                     return true;
                   }, onAccept: (data) {
                     int i = int.parse(data);
                     int tmp = _list[i];
                     _list[i] = _list[index];
                     _list[index] = tmp;
                     _check();
                   });
                 }),
               )
           )
         ],
       ),
     ),
   );
  }
}