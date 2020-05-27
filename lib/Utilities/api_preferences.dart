

class ApiConfig
{
 // static String securedPrefix = 'http://';
  static String securedPrefix = 'https://';
  //static String host = '192.168.1.3:8888';
 static String host = 'ecodashboard.rnplti.com:9234';

  static String validateEmailURL = '/ecorenew_ui/services/php/login/validate_email.php';
  static String validatePasswordURL = '/ecorenew_ui/services/php/login/validate_password.php';
  static String getUserDataURL = '/ecorenew_ui/services/php/login/getUserData.php';
  static String setCurrentDataURL = '/ecorenew_ui/services/php/main/setCurrentData.php';
  
}