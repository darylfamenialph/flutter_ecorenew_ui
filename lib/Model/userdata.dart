class UserData{
   String _isTimeIn;
   String _method;
   String _time_stamp;
   String _full_name;
   String _id_number;
   String _shift_id;

  UserData(this._isTimeIn,this._method,this._time_stamp,this._full_name,this._id_number,this._shift_id);

  factory UserData.fromJson(Map<String,dynamic> json){
    if(json == null){
      return null;
    }else{
      return UserData(json["isTimeIn"],json["method"],json["time_stamp"],json["full_name"],json["id_number"],json["shift_id"]);
    }
  }

   get isTimeIn => this._isTimeIn;
   get method => this._method;
   get time_stamp => this._time_stamp;
   get full_name => this._full_name;
   get id_number => this._id_number;
   get shift_id => this._shift_id;

}