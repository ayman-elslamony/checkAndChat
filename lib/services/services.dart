import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator(){
  //getIt.resetLazySingleton<Auth>(instance: Auth());
  GetIt.I.registerLazySingleton<Auth>(() =>Auth());
  GetIt.I.registerLazySingleton<Categorys>(() =>Categorys());

}