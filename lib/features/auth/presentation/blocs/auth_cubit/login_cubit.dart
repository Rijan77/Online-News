
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';


class LoginCubit extends Cubit<LoginState>{
  LoginCubit(): super(LoginInitial());


  Future<void> login(String email, String password) async{
    emit(LoginLoading());

    await Future.delayed(const Duration(seconds: 2));

    if(email == "test@example.com" && password== "password"){
      emit(LoginSuccess());
    } else{
      emit(LoginFailure("Invalid Credentials"));
    }
  }

}