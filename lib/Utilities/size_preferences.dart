import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeConfig
{
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;


  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static double fullWidth;
  static double fullHeight;

  void init(BoxConstraints constraints, Orientation orientation)
  {
    if(orientation == Orientation.portrait)
    {
      isPortrait = true;
      
    }else
    {
      isPortrait = false;
      isMobilePortrait = false;
    }

    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    fullWidth = _screenWidth;
    fullHeight = _screenHeight;
    print(_screenWidth);
  }
  
  
}