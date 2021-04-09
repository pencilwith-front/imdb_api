import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:imdb_api/models/movies.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String api = 'c37834aa9bf95cc6bc23487a57bc4bc7';
  String requestURL = 'https://api.themoviedb.org/3/movie/top_rated?api_key=';
  String postURL = 'https://image.tmdb.org/t/p/original/';
  Future<Movies> moviesList;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    moviesList = _getMovieList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Size allSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Container(
                height: 50,
                child: Center(child: Text('이쪽에 조회조건 들어갈꺼야')),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    width: 350.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              aspectRatio: 0.8,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              initialPage: 0,
                              autoPlay: true,
                              onPageChanged: (index, realIndex) {
                                setState(() {
                                  selectedIndex = index;
                                });
                              }),
                          items: List.generate(
                              snapshot.data.results.length,
                              (index) => Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        postURL +
                                            snapshot
                                                .data.results[index].posterPath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(),
                              RichText(
                                  text: TextSpan(
                                      text: 'TITLE:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text:
                                            '${snapshot.data.results[selectedIndex].title}',
                                        style: TextStyle(color: Colors.black54))
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      text: 'releaseDate:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text:
                                            '${snapshot.data.results[selectedIndex].releaseDate}',
                                        style: TextStyle(color: Colors.black54))
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      text: 'voteAverage:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text:
                                            '${snapshot.data.results[selectedIndex].voteAverage}/10',
                                        style: TextStyle(color: Colors.black54))
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      text: 'popularity:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text:
                                            '${snapshot.data.results[selectedIndex].popularity}',
                                        style: TextStyle(color: Colors.black54))
                                  ])),
                            ],
                          ),
                        )
                      ],
                    ));
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      strokeWidth: 20,
                    ),
                  ),
                );
              }
            },
            future: moviesList,
          ),
        ],
      ),
    );
  }

  Widget _getCarousel(Movies snapshot) {}

  Future<Movies> _getMovieList() async {
    var response = await http.get(requestURL + api);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return Movies.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
