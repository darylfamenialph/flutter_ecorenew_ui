import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:ecorenew_ui/Utilities/size_preferences.dart';
import 'package:ecorenew_ui/View/Common/concave_decorator.dart';
import 'package:ecorenew_ui/View/Dashboard/dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecorenew_ui/View/Common/neumorph.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecorenew_ui/Utilities/api_preferences.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future validateEmail(String email) async{
    try 
    {
    final urlString = ApiConfig.securedPrefix + ApiConfig.host + ApiConfig.validateEmailURL;
      var map = new Map<String, dynamic>();
      map['email'] = email;
      var response = await http.post(urlString,body: map,);
      if(response.statusCode == 200){
        print(response.body.toString());
        if(response.body != "none") validatePassword(_password,response.body.toString());
        else _showDialog('API Warning','Invalid Email');
      }else{
        _showDialog('API ERROR','Unable to Connect');
      }
       
    } catch (e) {
       _showDialog('API FETCH ERROR', e.toString());
    }

  }

  Future validatePassword(String password, String userID) async{
    try 
    {
       final urlString = ApiConfig.securedPrefix + ApiConfig.host + ApiConfig.validatePasswordURL;
      var map = new Map<String, dynamic>();
      map['password'] = password;
      map['user_id'] = userID;
      var response = await http.post(urlString,body: map,);
      if(response.statusCode == 200){
        if(response.body != "0")
        {
        // print(userID);
        if(userID != "none"){
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => DashboardPage(userID: userID,)));
        }
        }else{
          _showDialog('API WARNING','Invalid Password');
        }
      }else{
        _showDialog('API ERROR','Unable to Connect');
      }
    } catch (e) {
       _showDialog('API FETCH ERROR', e.toString());
    }
  }

  bool hasConnectivity = false;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  bool _isPressed = false;
  String _email,_password;
  var _emailController = new TextEditingController();
  var _passwordController = new TextEditingController();

  void _onPointerDown(PointerDownEvent event){
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event){
    setState(() {
      _isPressed = false;
      _email = _emailController.text.trim();
      _password = _passwordController.text.trim();
      if(hasConnectivity)
      {
        if(_email.length > 0 && _password.length > 0) validateEmail(_email);
        else _showDialog('Error','Must Complete All Fields');
      }else{
        _showDialog('Connection Error','No Internet Connectivity');
      }
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
   _checkInternetConnectivity();
    super.initState();
  }

  @override
  void dispose(){
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: mC,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode())
          },
          child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center
              (
                  child: Container
                  (
                    padding: const EdgeInsets.all(15),
                    width: (SizeConfig.fullWidth - SizeConfig.fullWidth*0.15),
                    height: (SizeConfig.fullHeight - SizeConfig.fullHeight*0.2),
                    //decoration: nMCard,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image(image: AssetImage('assets/ecorenewlogo.png')),
                        Text('Authentication',style: 
                          TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w800,
                          ),),
                        SizedBox(height: 15,),
                        NMTextInput(hintText: 'Email',controller: _emailController,isPassword: false,),
                        SizedBox(height: 15,),
                        NMTextInput(hintText: 'Password',controller: _passwordController,isPassword: true,),
                        SizedBox(height: 15,),
                        Listener
                        (
                          onPointerDown: _onPointerDown,
                         // onPointerDown: (PointerDownEvent event) => {print(_emailController.text)},
                          onPointerUp: _onPointerUp,
                          child: NMRectButton(text: 'Login',deviceWidth: SizeConfig.fullWidth,isPressed: _isPressed,)
                        ),
                        SizedBox(height: 25,),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(color: hasConnectivity? Colors.green : Colors.red),
                          child: Text(
                            hasConnectivity? 'Internet Connected' : 'No Internet Connectivity',
                            style: TextStyle(
                              color: Colors.white,
                            ),),
                        ),
                        SizedBox(height: 25,),
                        Text(
                          'App ver: 1.0.0',
                          style: TextStyle(color: Colors.grey.shade500
                          ),
                        ),
                    ],
                    ),
                  ),
              ),
              )
          ],
        ),
      ),
    );
  }
}




class NMButton extends StatelessWidget {
  final IconData icon;
  
  const NMButton({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: nMbox,
      child: Icon(
        icon,
        color: fCL,
      ),);
  }
}


class NMRectButton extends StatelessWidget {
  
  final String text;
  final double deviceWidth;
  final bool isPressed;
   NMRectButton({this.text,this.deviceWidth,this.isPressed});
 
  var innerShadow = ConcaveDecoration(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),colors: [mCD,mCL],
  depression: 3,);
  
  @override
  Widget build(BuildContext context) {
   double rectWidth = deviceWidth - deviceWidth*0.3;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      width: rectWidth,
      height: 55,
      decoration: isPressed? innerShadow: nMRectBtn,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green,fontSize: 15,fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class NMTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  double rectWidth = SizeConfig.fullWidth - SizeConfig.fullWidth*0.3;
  NMTextInput({this.hintText,this.controller,this.isPassword});

   var innerShadow = ConcaveDecoration(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),colors: [mCD,mCL],
  depression: 1,);

  @override
  Widget build(BuildContext context)
  {
    
    return Container
    (
      padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
      width: rectWidth,
      decoration: innerShadow,
       child: TextField(
         controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color:Colors.grey.shade500),
          ),
          obscureText: isPassword,
      ),
    );
  }
}


