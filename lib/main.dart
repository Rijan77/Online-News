import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/helpers/database_helper.dart';
import 'package:news_app/features/news/data/repositories/static_api.dart';
import 'package:news_app/features/news/presentation/blocs/news_fetch_cubit.dart';
import 'package:news_app/features/auth/presentation/views/registration.dart';

import 'core/common/widgets/bottom_nav.dart';
import 'features/auth/presentation/blocs/auth_cubit/login_cubit.dart';
import 'features/news/data/tryDio/show_ui.dart';
import 'features/news/presentation/views/try.dart';

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
            '/': (context) => ShowUi(),
            '/second': (context) => const Registration(),
            '/third': (context) => const BottomNav(),
          },
        ),
      ),
    );
  }
}
