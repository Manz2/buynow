import 'package:buynow/src/db_service_firebase.dart';
import 'package:buynow/src/login/login_model.dart';

class LoginController {
  final LoginModel _model;
  final DbServiceFirebase _dbService;
    LoginController()
      : _model = LoginModel(password: "", mail: ""),
        _dbService = DbServiceFirebase();

  LoginModel get model => _model;
  

Future<void> createUserData(String uid) async {
    await _dbService.createUserData(uid);
  }

}
