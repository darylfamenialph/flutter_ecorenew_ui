
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:ecorenew_ui/Model/userdata.dart';
import 'package:ecorenew_ui/Utilities/api_preferences.dart';
import 'package:ecorenew_ui/Utilities/size_preferences.dart';
import 'package:ecorenew_ui/View/Common/concave_decorator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecorenew_ui/View/Common/neumorph.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget{
  final String userID;
  const DashboardPage({Key key, @required this.userID}):
  super(key:key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver{
  List<UserData> _userData;

   Future<List<UserData>> fetchUserData() async{
   final urlString = ApiConfig.securedPrefix + ApiConfig.host + ApiConfig.getUserDataURL;
    var map = new Map<String, dynamic>();
    map['user_id'] = widget.userID;
    var response = await http.post(urlString,body: map,);
    if(response.statusCode == 200){
      List<dynamic> raw = jsonDecode(response.body.toString());
      return raw.map((e) => UserData.fromJson(e)).toList();
    }
  }

  Future setCurrentData(String isTimeIn, String isStart) async{
   final urlString = ApiConfig.securedPrefix + ApiConfig.host + ApiConfig.setCurrentDataURL;
    var map = new Map<String, dynamic>();
    map['user_id'] = widget.userID;
    map['isTimeIn'] = isTimeIn;
    map['isStart'] = isStart;
    var response = await http.post(urlString,body: map,);
    if(response.statusCode == 200){
      if(response.body.toString() == "Success"){
        print('Data Inserted');
        _getUserData(); 
      }else{
        print('Data Not Inserted');
      }
    }
  }
  
  bool _isBackPressed = false;
  bool _isTimeInPressed = false;
  bool _isTimeOutPressed = true;
  bool _isTimeInButtonDisabled = false;
  bool _isTimeOutButtonDisabled = true;
  bool _isShowWeekPressed = true;
  bool hasConnectivity = false;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  void _onBackPointerDown(PointerDownEvent event){
    setState(() {
      _isBackPressed = true;
    }); 
  }

  void _onBackPointerUp(PointerUpEvent event){
   setState(() {
      _isBackPressed = false;
      Navigator.pop(context);
   });
  }

  void _onShowAttendancePointerDown(PointerDownEvent event){
    setState(() {
      _isShowWeekPressed = true;
    });
  }

  void _onShowAttendancePointerUp(PointerUpEvent event){
    setState(() {
       _isShowWeekPressed = false;
    });
  }

  void _onTimePointerDown(PointerDownEvent event)
  {
    setState(() {
      if(hasConnectivity)
      {
          if(_isTimeInButtonDisabled == false && _isTimeOutButtonDisabled == true) 
          {
            _isTimeInPressed = true;
            _isTimeOutPressed = false;
            _isTimeInButtonDisabled = true;
            _isTimeOutButtonDisabled = false;
            print('Time-In Pressed');
            setCurrentData("1","1");
            
          // _userData = fetchUserData();
          }
          else 
          {
            _isTimeInPressed = false;
            _isTimeOutPressed = true;
            _isTimeInButtonDisabled = false;
            _isTimeOutButtonDisabled = true;
            print('Time-Out Pressed');
            setCurrentData("0","0");
          }
      }else{
        _showDialog('Connection Error', 'No Internet Connectivity');
      }
    });
  }

  void _getUserData(){
     fetchUserData().then((value) {
      setState(() {
        _userData = value;
        print(_userData[0].isTimeIn);
        if(_userData[0].isTimeIn == '1') 
        {
          _isTimeInPressed = true;
          _isTimeOutPressed = false;
          _isTimeInButtonDisabled = true;
          _isTimeOutButtonDisabled = false;
        }else{
          _isTimeInPressed = false;
          _isTimeOutPressed = true;
          _isTimeInButtonDisabled = false;
          _isTimeOutButtonDisabled = true;
        }
      });
    });
  }

  void _showDialog(String _title, String _text){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: new Text(_title),
        content: new Text(_text),
        actions: <Widget>[
          new FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('OK'))
        ],

      );
    });
  }

  _checkInternetConnectivity()  {
     _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) { 
      print(result.toString());
      if(result == ConnectivityResult.none)
        {
          setState(() {
            hasConnectivity = false;
          });
        }else{
          setState(() {
            hasConnectivity = true;
          });
        } 
    });
  }


  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
     _checkInternetConnectivity();
   _getUserData();
    super.initState();
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print('state = $state');
    if(state == AppLifecycleState.resumed){
      _checkInternetConnectivity(); 
    }
    //_checkInternetConnectivity(); 
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: mC,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                    Listener(
                      onPointerDown: _onBackPointerDown,
                      onPointerUp: _onBackPointerUp,
                      child: NMButton(icon: Icons.arrow_back,isPressed: _isBackPressed,)),
                  /*  Listener(
                      onPointerDown: (PointerDownEvent event)=>{print('Pressed Down')},
                      onPointerUp: (PointerUpEvent event)=>{print('Pressed Up')},
                      child:  NMButton(icon: Icons.menu,isPressed: false,),
                    ),
                   */
                  ],
                ),

                AvatarImage(),
                SizedBox(height: 15,),
                Text(
                  _userData[0].full_name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700,color: Colors.grey.shade600),
                ),
                Text(
                    _userData[0].id_number,
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 15,),
                Text(
                   _userData[0].isTimeIn == '1' ? 'Last Time-In: ' +  _userData[0].time_stamp : 'Last Time-Out: ' + _userData[0].time_stamp,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14,color: Colors.grey.shade400),
                ),
                SizedBox(height: 35,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Listener(
                      onPointerDown: _isTimeInButtonDisabled? null : _onTimePointerDown,
                      child: NMRectButton
                      (
                        text: 'Time-In',
                        deviceWidth: SizeConfig.fullWidth,
                        textStyle: TextStyle(
                          color: Colors.blue.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                        isPressed: _isTimeInPressed,
                      ),
                    ),
                    SizedBox(width: 25,),
                    Listener(
                      onPointerDown: _isTimeOutButtonDisabled? null : _onTimePointerDown,
                      child: NMRectButton(
                        text: 'Time-Out',
                        deviceWidth: SizeConfig.fullWidth,
                        textStyle: TextStyle(
                          color: Colors.red.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          shadows: [Shadow(color: Colors.white),]
                        ),
                        isPressed: _isTimeOutPressed,
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Listener(
                        //  onPointerDown: _onShowAttendancePointerDown,
                         // onPointerUp: _onShowAttendancePointerUp,
                          child: NMRectButton(
                            deviceWidth: SizeConfig.fullWidth * 2.4,
                            text: 'Show Weekly Attendance',
                            textStyle: TextStyle(color: Colors.grey.shade500),
                            isPressed: _isShowWeekPressed,),
                      ),
                    ),
                  ],
                )
              ],
            ),
            )
        ],
      ),
    );
  }
}



class NMButton extends StatelessWidget {
  final IconData icon;
  final bool isPressed;
  const NMButton({this.icon,this.isPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: isPressed? null : nMbox,
      child: Icon(
        icon,
        color: fCL,
      ),
    );
  }
}

class NMRectButton extends StatelessWidget {
  final String text;
  final double deviceWidth;
  final TextStyle textStyle;
  final bool isPressed;
  NMRectButton({this.text,this.deviceWidth,this.textStyle,this.isPressed});

   var innerShadow = ConcaveDecoration(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),colors: [mCD,mCL],
  depression: 3,);
 
  @override
  Widget build(BuildContext context) {
   double rectWidth = (deviceWidth/2) - deviceWidth*0.15;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      width: rectWidth,
      height: 55,
      decoration: isPressed? innerShadow : nMRectBtn,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}

class NMCard extends StatelessWidget {
  final String text;
  final double deviceWidth;
  const NMCard({this.text,this.deviceWidth});
  @override
  Widget build(BuildContext context) {
    double cardWidth = deviceWidth - deviceWidth*0.15;
    return Container(
      padding: const EdgeInsets.all(15),
      width: cardWidth,
      height: 170,
      decoration: nMCard,
      child: Column(
        children: <Widget>[
          Text(text),
        ],
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: nMbox,
      child: Container(
        decoration: nMbox,
        padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/avatar.JPG'),
            ),
          ),
        ),
      ),
    );
  }
}