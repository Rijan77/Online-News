import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fetch_cubit.dart';
import '../bloc/fetch_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ValueNotifier<bool>> favoriteStatusList = [];

  @override
  void dispose() {
    for (var notifier in favoriteStatusList) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final cubit = context.read<FetchNewsCubit>();
      cubit.fetchNews();

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Online News",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.favorite, size: 35, color: Colors.redAccent),
          )
        ],
      ),
      body: BlocBuilder<FetchNewsCubit, FetchNews>(
        builder: (context, state) {
          if (state is InitialFetchNews || state is LoadingFetchNews) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (state is ErrorFetchNews) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is SuccessFetchNews) {
            final news = state.newModel;

            log("Length of API${news.length}");

            // Initialize favorite status list if empty
            if (favoriteStatusList.isEmpty) {
              favoriteStatusList.addAll(
                List.generate(news.length, (_) => ValueNotifier<bool>(false)),
              );
            }


            return ListView.builder(
              itemCount:  news.length,
              itemBuilder: (BuildContext context, int index) {
                final item = news[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // // News Image
                      if (item.imageUrl != null)

                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.25,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: screenHeight * 0.25,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      // News Details (Title, Date, Favorite)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? "No title available",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.pubDate ?? "Date not available",
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                                // Favorite Button
                                ValueListenableBuilder<bool>(
                                  valueListenable: favoriteStatusList[index],
                                  builder: (context, isFavorite, _) {
                                    return IconButton(
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () {
                                        favoriteStatusList[index].value = !isFavorite;
                                      },
                                    );
                                  },
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}