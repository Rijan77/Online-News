import 'package:flutter/material.dart';
import 'package:news_app/features/news/data/tryDio/dio_api.dart';
import 'package:news_app/features/news/data/tryDio/dio_model.dart';

class ShowUi extends StatefulWidget {
  const ShowUi({super.key});

  @override
  State<ShowUi> createState() => _ShowUiState();
}

class _ShowUiState extends State<ShowUi> {
  final DioApi _dioApi = DioApi();
  late Future<List<DioModel>> _dioModel;

  @override
  void initState() {
    // TODO: implement initState
    _dioModel = _dioApi.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder(future: _dioModel, builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text("No data found"));
        } else if(snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"),);
        }

        final posts = snapshot.data!;


        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.blueGrey.shade100,
              

              
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Dio Example", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600), ),
                centerTitle: true,
              ),
              
            ),
            SliverList(delegate: SliverChildBuilderDelegate((context, index){
              final post = posts[index];

              return 
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.title.toUpperCase(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                          SizedBox(height: 10,),
                          Text(post.body)
                        ],
                      ),
                    ),
                  ); 
            },
              childCount: posts.length
            )
            )
            
          ],
        );
      }),

    );

  }
}
