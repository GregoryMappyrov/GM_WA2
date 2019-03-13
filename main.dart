import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:io';

void main() => runApp(MaterialApp(
      title: 'Repeating Strategy',
      home: new RepeatingTest(),
    ));

var signals = <String>[];

AppBar WhiteAB(){
  var ab;
  return AppBar(backgroundColor: Colors.white);
}

void sleep1() {
  sleep(const Duration(seconds: 3));
  print('w8ed');
}

void _mainAction(var context){
  signals.clear();
  print('Score ' + '$score');
  print('scan, connect, get properties, set ready');
      
      sleep1();

      print('sendSignal1');
      signals.add('sendSignal1');
      print('sendSignal2');
      signals.add('sendSignal2');
      print('sendSignal3');
      signals.add('sendSignal3');
      print('sendSignal4');
      signals.add('sendSignal4');

      _goAction(context, new Screen3State());

}

void _goAction(var context, StatelessWidget sw) {
      print('next');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sw),
      );
      
} 

class RepeatingTest extends StatelessWidget {



    @override
    Widget build(BuildContext context) {
        return new Center(
            child: new Scaffold(
              appBar: WhiteAB(),
              body: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    new Row(),
                    new Text('Repeating Strategy Test', style: TextStyle(fontSize: 32, color: Colors.green), textAlign: TextAlign.center,),
                    new Row(),
                    new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: new Text('Human\'s working memory capacity is restricted, but can be trained', 
                            style: TextStyle(fontSize: 22, color: Colors.black), textAlign: TextAlign.center,
                        ),
                    ),
                    new Row(),
                    new ChangeButton(onPressed: (){     
                          _goAction(context, new Screen2State());
                        }, name: 'Let\'s do it'
                    ),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                ]
              )
            )
        );
    }
}



class ChangeButton extends StatelessWidget {
  ChangeButton({this.onPressed, this.name});

  var name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var n = signals.length;
    print('new button and signals ' + '$n');
    return RaisedButton(
      color: Colors.green,
      onPressed: onPressed,
      child: new Text(name, style: TextStyle(color: Colors.white)),
    );
  }
}

class Screen2State extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return new Center(
          child: new Scaffold(
              appBar: WhiteAB(),
              body: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new ChangeButton(
                          onPressed: () {
                              _mainAction(context); 
                          },
                          name: ' Connect Device and Send Signals',
                      ),
                      new Text('Remember the sequence', style: TextStyle(fontSize: 32, color: Colors.green), textAlign: TextAlign.center,),
                      new Row(),
                      new Row(),
                      new Row(),
                      new ChangeButton(
                          onPressed: () {
                              _goAction(context, new RepeatingTest());
                              signals = <String>[];
                              score = 0;
                          },
                          name: 'Exit',
                      ),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Container(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                      new Row(),
                  ]
              )
          )
        );
  }
}
int score = 0;
int rightAnswers(var s, var p) {
  var c = 0;
  if(s.length == p.length){
      for(var i = 0; i < s.length; i++) {
        if (s[i] == p[i]) {
          c++;
        }
      }
  }
  return c;
}

class Screen3State extends StatelessWidget {
  var buttonsPressed = <String>[];
  @override
  Widget build(BuildContext context) {
      return new Center(
          child: new Scaffold(
              appBar: WhiteAB(),
              body: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 1, context);
                          },
                          name: 'front',
                    ),
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 2, context);
                          },
                          name: 'right',
                    ),
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 3, context);
                          },
                          name: 'left',
                    ),
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 4, context);
                          },
                          name: 'back',
                    ),
                  ]
              )
          )
        );
  }
}

void _addSignal(var bpA, var sN, var context) {
    bpA.add('sendSignal' + '$sN');
    if(bpA.length == signals.length) {
        print('next:Score' + '$score');
        score += rightAnswers(signals, bpA);
        _goAction(context, new Screen4State());
    }
}



class Screen4State extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
      return new Center(
          child: new Scaffold(
              appBar: WhiteAB(),
              body: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      new Text('Result: ' + '$score'),
                      new ChangeButton(
                          onPressed: () {
                              _goAction(context, new Screen2State());
                          },
                          name: 'Next Round',
                    ),
                  ]
              )
          )
        );
  }
}




/*

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController (
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          bottom: new TabBar(
            tabs: <Widget>[new Tab(icon: new Icon(Icons.home)), new Tab(text: 'List'), new Tab(text: 'BLE')],
          )
        ),
        body: new MyTabBarView()
      )
    );
  }
}

class MyList extends StatefulWidget{
  @override
  MyListState createState()=>new MyListState();
}

class MyListState extends State<MyList> with AutomaticKeepAliveClientMixin<MyList> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(); 

        final index = i ~/ 2; 
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }
  
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyTabBarView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      children: <Widget>[new Counter(),
      new MyList(), new BLE()],
    );
  }
}

class BLE extends StatefulWidget {
  @override
  BLEState createState()=>BLEState();
}

class BLEState extends State<BLE>  with AutomaticKeepAliveClientMixin<BLE> {
  //FlutterBlue flutterBlue = FlutterBlue.instance;
  var scanSubscription;
  //var scanSubscriptionS;
  //var deviceConnection;
  BluetoothDevice device;
  //List<BluetoothDevice> devices;

  /// Start scanning
  void _startS(){
    print('STARTING SCANNING_________________________');
    FlutterBlue flutterBlue = FlutterBlue.instance;
    scanSubscription = flutterBlue.scan().listen((scanResult) {
    // do something with scan result
    //device = scanResult.device;
    print('device name: ' + scanResult.device.name);
    if(scanResult.device.name.length > 12 && scanResult.device.name.substring(0,13) == "TECO Wearable") { 
      device = scanResult.device;
      print('found');
      _stopS();
      var deviceConnection = flutterBlue.connect(device).listen((s) {
        if(_getConnection(s, device)) {
          print('connectedABC ' + device.name);
          //_inConnection(device);
        }
      });
    }
    });
  }

void _inConnection(var device) {
  // device is connected, do something
          //print('connected ' + device.name);
          var services; 
          _readServices(services, device);
          for(var j = 0; j < services.length; j++) {
            // do something with service
            var characteristics;
            _readCharacteristics(characteristics, services[j]);
            for(BluetoothCharacteristic c in characteristics) {
                var values;
                _readCharacteristic(values, device, c);
                for(var i = 0; i < values.length; i++) {
                  print(i);
                }
            }
          }
}

_getConnection(var s, var device) {
  if(s == device.state.connected) {
    return true;
  }
  return false;
}
void _readServices(var services, var device) async {
  services = await device.discoverServices();
}
void _readCharacteristic(var values, var device, var c) async {
  values = device.readCharacteristic(c);
}
void _readCharacteristics(var c, var service) async {
  c = await service.characteristics;
}

   //Stop scanning
  void _stopS() {
    scanSubscription.cancel();
    print(' ');
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
              new ChangeCounterButton(onPressed: _startS, name: 'Scan'),]
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter>  with AutomaticKeepAliveClientMixin<Counter>{
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  void _decrement() {
    setState(() {
      --_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text(' ')]
          ),
          new Text(
            'Counter: ' + '$_counter', 
            style: TextStyle(fontSize: 25)
          ),
          new Container(height: 20.0),
          new Padding (
            padding: EdgeInsets.all(0.0),
            child:
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new ChangeCounterButton(onPressed: _decrement, name: '--'),
                new ChangeCounterButton(onPressed: _increment, name: '++'),
              ]
            ),
          ),
        ],
      ),
    );
  }

  

  @override
  bool get wantKeepAlive => true;
}

class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.counter});

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Text('$counter');
  }
}
*/

