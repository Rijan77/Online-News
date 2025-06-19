import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/utils/response_enum.dart';
import '../blocs/news_fetch_cubit.dart';
import '../blocs/news_fetch_state.dart';
import '../widgets/home_layouts.dart';


class Home extends StatefulWidget {
  final NotchBottomBarController? controller;

  const Home({super.key, this.controller});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<NewsFetchCubit>().newsFetch();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: isPortrait ? 35 : 25),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            "Online News",
            style: TextStyle(
              fontWeight: isPortrait ? FontWeight.w700 : FontWeight.bold,
              fontSize: isPortrait ? 20 : 20,
            ),
          ),
        ),
        actions: [
          BlocBuilder<NewsFetchCubit, NewsFetchState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/fourth');
                      context.read<NewsFetchCubit>().refreshData();
                    },
                    // icon: Icon(Icons.notifications_on_rounded, size: isPortrait ? 30 : 20),
                    icon: FaIcon(
                      FontAwesomeIcons.bell,
                      size: isPortrait ? 30 : 20,
                    ),
                  ),
                  if (state.articleIds.isNotEmpty)
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
                            state.articleIds.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isPortrait ? 12 : 8,
                            ),
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
      body: BlocBuilder<NewsFetchCubit, NewsFetchState>(
        builder: (context, state) {
          if (state.newsFetchStatus == ResponseEnum.initial ||
              state.newsFetchStatus == ResponseEnum.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (state.newsFetchStatus == ResponseEnum.failure) {
            return Center(child: Text(state.error));
          } else if (state.newsFetchStatus == ResponseEnum.success &&
              state.newsModel != null) {
            return buildLandscapeGridView(
              state.newsModel!.results,
              context.read<NewsFetchCubit>(),
              screenHeight,
              context,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
