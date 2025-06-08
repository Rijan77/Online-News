import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/presentation/views/login.dart';
import 'package:news_app/features/presentation/views/favorites_page.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/api/model_api.dart';
import '../bloc/fetch_cubit.dart';
import '../bloc/fetch_state.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> toggleFavorite(NewsData news, bool isCurrentlyFavorite) async {
  final favoriteRef = FirebaseFirestore.instance.collection('favorites');

  try {
    if (isCurrentlyFavorite) {
      // Remove from favorites
      await favoriteRef.doc(news.articleId).delete();
    } else {
      // Add to favorites
      if (news.articleId != null) {
        await favoriteRef.doc(news.articleId).set(news.toJson());
      }
    }
  } catch (e) {
    log("Error toggling favorite: $e");
    rethrow;
  }
}



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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade200,
        leading: InkWell(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Login()));
          },
            child: const Icon(Icons.arrow_back, size: 30,)),
        title: const Center(
          child: Text(
            "Online News",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            }, icon: const Icon(Icons.favorite, size: 35,))
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
              // favoriteStatusList.clear();
              favoriteStatusList.addAll(
                List.generate(news.length, (_) => ValueNotifier<bool>(false)),
              );
            }


            return RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.white,
              backgroundColor: Colors.blueGrey,
              strokeWidth: 3.0,
              onRefresh: ()async {
                 // return Future<void>.delayed(Duration(seconds: 3));
                await context.read<FetchNewsCubit>().fetchNews();
              },
              child: ListView.builder(
                itemCount:  news.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = news[index];

                  // log("Total Items ${item.toJson()}");
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


                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

                            child:
                            item.imageUrl != null
                                ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: screenHeight * 0.25,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: screenHeight * 0.25,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                            )
                                : Container(
                              height: screenHeight * 0.25,
                              color: Colors.grey[200],
                              child: const Center(child: Text("No Image Available")),
                            )

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
                                    // item.pubDate ?? "Date not available",
                                    // style: TextStyle(color: Colors.grey[600], fontSize: 14),

                                    item.pubDate != null
                                        ? timeago.format(DateTime.parse(item.pubDate!), allowFromNow: true)
                                    : "Date not available",
                                      style: const TextStyle(color: Colors.blueGrey, fontSize: 15)
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
                                        onPressed: () async {
                                          favoriteStatusList[index].value = !isFavorite;


                                            showTopSnackBar(
                                              Overlay.of(context),
                                              const CustomSnackBar.info(
                                                message: "News Added to Favorite",
                                                backgroundColor: Colors.blueGrey,

                                              ),
                                            );


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
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}