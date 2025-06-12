import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../database/database_helper.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade200,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, size: 30),
        ),
        title: const Center(
          child: Text(
            "Online News",
            style: TextStyle(fontWeight: FontWeight.w700),
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
                    icon: const Icon(Icons.favorite, size: 35),
                  ),
                  if (cubit.favoriteCount > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          cubit.favoriteCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
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

            return RefreshIndicator(
              onRefresh: () async {
                await cubit.fetchNews();
                await cubit.updateFavoriteCount();
              },
              child: ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final item = news[index];
                  final isFavorite =
                      cubit.favoriteArticleIds.contains(item.articleId);

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: item.imageUrl != null
                              ? Image.network(item.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: screenHeight * 0.25,
                                  errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Container(
                                      height: screenHeight * 0.25,
                                      // color: Colors.red[200],
                                      child: Center(
                                        child: const Icon(
                                            Icons.image_aspect_ratio_outlined,
                                            color: Colors.black45,
                                            size: 50),
                                      ),
                                    ),
                                  );
                                })
                              : Container(
                                  height: screenHeight * 0.25,
                                  color: Colors.grey[200],
                                  child: const Center(
                                      child: Text("No Image Available")),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title ?? "No title available",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.pubDate != null
                                        ? timeago.format(
                                            DateTime.parse(item.pubDate!),
                                            allowFromNow: true)
                                        : "Date not available",
                                    style: const TextStyle(
                                        color: Colors.blueGrey, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () =>
                                        cubit.toggleFavorite(item, context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
