abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

// enum ResponseEnum{
// //   initial, success, loading, failure
// }
// class LoginState{
//   final ResponseEnum status;
//   finsl is
//   cop
// }
