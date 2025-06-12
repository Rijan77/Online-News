import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/presentation/views/widgets/home_layouts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/api/model_api.dart';
import '../bloc/fetch_cubit.dart';
import '../bloc/fetch_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final favoriteStatusList = <String>[];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<FetchNewsCubit>();
      await cubit.fetchNews();
      await cubit.updateFavoriteCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isPortrait ? kToolbarHeight : kToolbarHeight * 0.5,
        backgroundColor: Colors.blueGrey.shade200,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: isPortrait ? 35 : 25),
        ),
        title: Center(
          child: Expanded(
            child: Text(
              "Online News",
              style: TextStyle(
                fontWeight: isPortrait ? FontWeight.w700 : FontWeight.bold,
                fontSize: isPortrait ? 20 : 20,
              ),
            ),
          ),
        ),
        actions: [
          BlocBuilder<FetchNewsCubit, FetchNews>(
            builder: (context, state) {
              final cubit = context.read<FetchNewsCubit>();
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/fourth');
                      await cubit.refreshFavorites();
                      await cubit.fetchNews();
                    },
                    icon: Icon(Icons.favorite, size: isPortrait ? 30 : 20),
                  ),
                  if (cubit.favoriteCount > 0)
                    Positioned(
                      right: isPortrait ? 2 : 1,
                      top: isPortrait ? 2 : 0,
                      child: Container(
                        padding: EdgeInsets.all(isPortrait ? 2 : 0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(isPortrait ? 30 : 80),
                        ),
                        constraints: BoxConstraints(
                          minHeight: isPortrait ? 20 : 15,
                          minWidth: isPortrait ? 20 : 15,
                        ),
                        child: Center(
                          child: Text(
                            cubit.favoriteCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isPortrait ? 12 : 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FetchNewsCubit, FetchNews>(
        builder: (context, state) {
          if (state is InitialFetchNews || state is LoadingFetchNews) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (state is ErrorFetchNews) {
            return Center(child: Text(state.message));
          } else if (state is SuccessFetchNews) {
            final news = state.newModel;
            final cubit = context.read<FetchNewsCubit>();

            return buildLandscapeGridView(news, cubit, screenHeight, context);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
