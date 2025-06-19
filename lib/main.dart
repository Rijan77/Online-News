import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/database/database_helper.dart';
import 'package:news_app/features/data/api/static_api.dart';
import 'package:news_app/features/presentation/bloc/login_cubit.dart';
import 'package:news_app/features/presentation/bloc/news_fetch_cubit.dart';
import 'package:news_app/features/presentation/views/registration.dart';

import 'core/common/widgets/bottom_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DatabaseHelper.instance.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => NewsApi()),
        RepositoryProvider(create: (_) => DatabaseHelper.instance),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginCubit()),
          BlocProvider(
            create: (context) => NewsFetchCubit(
              newsApi: context.read<NewsApi>(),
              databaseHelper: context.read<DatabaseHelper>(),
            )..newsFetch(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => BottomNav(),
            '/second': (context) => const Registration(),
            '/third': (context) => const BottomNav(),
          },
        ),
      ),
    );
  }
}
