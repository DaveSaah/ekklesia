import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionService {
  Future<bool> isOnline() async {
    final connectivityChecker = InternetConnectionChecker.createInstance();
    return await connectivityChecker.hasConnection;
  }
}
