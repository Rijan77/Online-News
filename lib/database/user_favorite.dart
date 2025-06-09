//
// class UserFavorite{
//   final int? id;
//   final String email;
//   final bool? isFavorite;
//
//   UserFavorite({this.id, required this.email, this.isFavorite});
//
//   Map<String, dynamic> toMap(){
//     return {'id': id, 'email': email, 'isFavorite': isFavorite};
//   }
//
//   factory UserFavorite.fromMap(Map<String, dynamic> map){
//     return UserFavorite(
//       id: map['id'],
//       email: map['email'],
//       isFavorite: map['isFavorite']
//     );
//   }
// }