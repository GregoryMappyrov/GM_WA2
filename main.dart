import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:io';
import 'dart:math';
import 'dart:async';

var version = 39;

void main() => runApp(MaterialApp(
      title: 'Repeating Strategy',
      home: new RepeatingTest(),
    ));

var signals = <String>[];
BluetoothDevice device;
var scanSubscription;
var deviceConnection;
bool connected = false;

AppBar WhiteAB(){
  var ab;
  return AppBar(backgroundColor: Colors.white);
}

void sleep1() {
  sleep(const Duration(seconds: 1));
  print('w8ed???');
}
///////////////////////////////////////////////////////////////
void _mainAction(var context) async {
  connected = false;
  signals.clear();
  print('Score ' + '$score');
  print('Start main action');
  
  _startS(context); 
}

var charW;

void secondStep(var context) async {
  print('Second step begin');
  var rng = new Random();
  if(connected){

    //sleep1(); //DELETE
    print('bzz');


    List<BluetoothService> services = await device.discoverServices();
    await services.forEach((service) {
      print('SERVICE');
    // do something with service
        if (service.uuid == new Guid('713D0000-503E-4C75-BA94-3148F18D941E')) {
          print('first step vibro');
          scanCh(service);
        }
    });

    await sendSig(context, rng);

    await _disC();

    //await print('ss disc.');

    _goAction(context, new Screen3State());
  }
}

void sendSig(var context, var rng) async {
  print('start sending SIGNALS');
    for(var j = 1; j <= roundSignals; j++ ) {
        var ss = rng.nextInt(4) + 1;
        print('sendSignal' + '$ss'); //SUBSTITUTE WITH SENDING SIGNAL
        signals.add('sendSignal' + '$ss');
        signalsCounter += 1;
        setChar(ss);
        sleep1();
        //await device.writeCharacteristic(charW, vib);
        sleep1();
        await device.writeCharacteristic(charW, [0x00, 00, 00, 00]);
    }
}

var vib;

void setChar(var ss) {
  print('set char');

if( ss == 1)
  vib = [0xff, 0x00, 0x00, 0x00]; //front
else if(ss == 2)
  vib =  [0x00, 0xff, 0x00, 0x00]; //right
else if(ss == 3)
  vib =  [0x00, 0x00, 0x00, 0xff]; //left
else 
  vib =  [0x00, 0x00, 0xff, 0x00];//back

}

void scanCh(var service) async {
        print('start scanning CH');
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
            //List<int> value = await device.readCharacteristic(c);
            //print('ch-value: ' + '$value');
            if (c != null && c.uuid == new Guid('713D0003-503E-4C75-BA94-3148F18D941E')) {
              print('second step vibro');
              charW = await c;
              //await device.writeCharacteristic(c, [0x00, 15, 00, 00]);
              //sleep1();
              //await device.writeCharacteristic(c, [0x00, 00, 00, 00]);
            }
            else {print('null CHAR');}
        }
}

FlutterBlue flutterBlue = FlutterBlue.instance;

void _startS(var context) async {
  //print('STARTING SCANNING_________________________');
  //if (device == null) {
    scanSubscription = await flutterBlue.scan().listen((scanResult) {
      // do something with scan result
      device = scanResult.device;
      print('device name: ' + scanResult.device.name);
      forConnection(scanResult, device, context); 
    });
 // }
  //else {
  //  print('way around');
 //   flutterBlue.connect(device);
  //  connected = true;
    //suspendedConnection(flutterBlue, device, context);
  //  secondStep(context);
 // }
}

void forConnection(var scanResult, var device, var context) async {
    if(scanResult.device.name.length > 12 && scanResult.device.name.substring(0,15) == "TECO Wearable 1") { 
      await assign(device, scanResult.device);
      print('found ' + device.name);
      _stopS();
      await suspendedConnection(device, context);
     // print('suspended connection success');
    }
}

void suspendedConnection(var device, var context) async {
  print('starting susp connection');
  deviceConnection = await flutterBlue.connect(device).listen((s) {
      if(!connected) {
          print('connected suspended ' + device.name);
          
          connected = true;
          //_inConnection(device);

          secondStep(context);
      }
  });
}

void assign(var d1, var d2) async {
  print('assigned');
  d1 = d2;
}

void _disC() async {
  deviceConnection.cancel();
  print('disconnected');
  connected = false;
}

void _stopS() async {
  scanSubscription.cancel();
  print('STOP SCANNING_____________________________');
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
        print('check' + '$version');
        if (device != null)
          _disC();
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
                        child: new Text('Human\'s working memory\'s capacity is restricted, but can be trained', 
                            style: TextStyle(fontSize: 22, color: Colors.black), textAlign: TextAlign.center,
                        ),
                    ),
                    new Row(),
                    new ChangeButton(onPressed: (){     
                          _goAction(context, new Screen2State());
                        }, name: 'Let\'s do it!'
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
    //if(device != null) {
    //  device.discoverServices();
    //}
    var n = signals.length;
    print('new button and signals ' + '$n');
    return RaisedButton(
      color: Colors.green,
      onPressed: onPressed,
      child: new Text(name, style: TextStyle(color: Colors.white)),
    );
  }
}
void reset() {
    signals = <String>[];
    score = 0;
    signalsCounter = 0;
    roundSignals = 3;
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
                      new Text('Remember the sequence', style: TextStyle(fontSize: 32, color: Colors.green), textAlign: TextAlign.center,),
                      new Row(),
                      new Row(),
                      new ChangeButton(
                          onPressed: () {
                              _mainAction(context); 
                          },
                          name: 'Connect Device and Send Signals',
                      ),
                      new ChangeButton(
                          onPressed: () {
                              _goAction(context, new RepeatingTest());
                              reset();
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
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 1, context);
                          },
                          name: 'front',
                    ),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Padding(padding:  EdgeInsets.all(40.0),
                    child:
                    new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 3, context);
                          },
                          name: 'left',
                    ),
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 2, context);
                          },
                          name: 'right',
                    ),
                    ],),),
                    new Row(),
                    new Row(),
                    new Row(),
                    new ChangeButton(
                          onPressed: () {
                              _addSignal(buttonsPressed, 4, context);
                          },
                          name: 'back',
                    ),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
                    new Row(),
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

void _addSignal(var bpA, var sN, var context) {
    bpA.add('sendSignal' + '$sN');
    if(bpA.length == signals.length) {
        print('next:Score' + '$score');
        score += rightAnswers(signals, bpA);
        if (signalsCounter < 25) {
          _goAction(context, new Screen4State());
        }
        else {
          _goAction(context, new Screen5State());
        }
    }
}

int signalsCounter = 0;
int roundSignals = 3;

class Screen4State extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
      return new Center(
          child: new Scaffold(
              appBar: WhiteAB(),
              body: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      new Row(),
                      new Text('Result: ' + '$score/$signalsCounter', style: new TextStyle(fontSize: 50)),
                      new Row(),
                      new ChangeButton(
                          onPressed: () {
                              _goAction(context, new Screen2State());
                              roundSignals += 1;
                          },
                          name: 'Next Round',
                      ),
                      new Row(),
                  ]
              )
          )
        );
  }
}
//3+4+5+6+7=25
class Screen5State extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
      var finalScore = (score/0.25).round();
      var honesty = '';
      if(finalScore < 40) {
        honesty = 'You have to work on your working memory';
      }
      else if(finalScore < 80) {
        honesty = 'Your working memory is good';
      }
      else {
        honesty = 'Excellent working memory';
      }
      return new Center(
          child: new Scaffold(
              appBar: WhiteAB(),
              body: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      new Row(),
                      new Text('Final Score: ' + '$finalScore%', style: new TextStyle(fontSize: 49)),
                      new Text(honesty, style: new TextStyle(fontSize: 22), textAlign: TextAlign.center,),
                      new ChangeButton(
                          onPressed: () {
                              _goAction(context, new RepeatingTest());
                              reset();
                          },
                          name: 'Exit',
                      ),
                      new Row(),
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
  
  //var scanSubscriptionS;
  //var deviceConnection;
  BluetoothDevice device;
  var scanSubscription;
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

