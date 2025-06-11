import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/data/api/static_api.dart';
import 'package:news_app/features/presentation/views/favorites_page.dart';
import 'package:news_app/features/presentation/views/home.dart';
import 'package:news_app/features/presentation/views/registration.dart';
import 'database/database_helper.dart';
import 'features/presentation/bloc/fetch_cubit.dart';
import 'features/presentation/bloc/login_cubit.dart';
// Make sure this exists or remove

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  // await DatabaseHelper.instance.queryAllFavorite();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => FetchNewsCubit(NewsApi())),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (contex) =>  Home(),
          '/second': (context)=> const Registration(),
          '/third': (context)=>const Home(),
          '/fourth': (context)=>const FavoritesPage(),
          // '/fifth': (context)=>

        },
        debugShowCheckedModeBanner: false,
        // home: const Home(), // or Home(), based on auth state
      ),
    );
  }
}