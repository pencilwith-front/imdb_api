import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_api/models/movie2.dart';
import 'dart:convert' as convert;
//import 'package:imdb_api/models/movies.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String api = 'c37834aa9bf95cc6bc23487a57bc4bc7';
  //String requestURL = 'https://api.themoviedb.org/3/movie/top_rated?api_key=';
  String requestURL =
      'https://api.themoviedb.org/3/movie/now_playing?language=ko&page=1%C2%AEion=KR&api_key=';

  String postURL = 'https://image.tmdb.org/t/p/original/';
  //Future<Movies> moviesList;
  Future<Movies2> moviesList;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    moviesList = _getMovieList();
    moviesList.then((value) => print('aaaa'));
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
          Row(), //센터로 감싸기 싫어서.
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      width: 350.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                                aspectRatio: 14 / 12,
                                enlargeCenterPage: true, //양옆의 이미지 붙는거.
                                enableInfiniteScroll: true,
                                initialPage: 0,
                                autoPlay: false,
                                viewportFraction: 0.62,
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
                                              snapshot.data.results[index]
                                                  .posterPath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: DataTable(
                                headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                headingRowHeight: 30,
                                dataRowHeight: 30,
                                columnSpacing: 50,
                                headingRowColor:
                                    MaterialStateProperty.all(Colors.grey[200]),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      '구분',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      '내용',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Text('제   목')),
                                    DataCell(Container(
                                      width: 250,
                                      child: Text(
                                        '${snapshot.data.results[selectedIndex].title}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('개봉일')),
                                    DataCell(Text(
                                        '${snapshot.data.results[selectedIndex].releaseDate}')),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('평   점')),
                                    DataCell(Text(
                                        '${snapshot.data.results[selectedIndex].voteAverage}/10')),
                                  ]),
                                ]),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 40.0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisSize: MainAxisSize.max,
                          //     children: [
                          //       Row(),
                          //       RichText(
                          //           text: TextSpan(
                          //               text: 'TITLE:',
                          //               style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold),
                          //               children: [
                          //             TextSpan(
                          //                 text:
                          //                     '${snapshot.data.results[selectedIndex].title}',
                          //                 style: TextStyle(color: Colors.black54))
                          //           ])),
                          //       RichText(
                          //           text: TextSpan(
                          //               text: 'releaseDate:',
                          //               style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold),
                          //               children: [
                          //             TextSpan(
                          //                 text:
                          //                     '${snapshot.data.results[selectedIndex].releaseDate}',
                          //                 style: TextStyle(color: Colors.black54))
                          //           ])),
                          //       RichText(
                          //           text: TextSpan(
                          //               text: 'voteAverage:',
                          //               style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold),
                          //               children: [
                          //             TextSpan(
                          //                 text:
                          //                     '${snapshot.data.results[selectedIndex].voteAverage}/10',
                          //                 style: TextStyle(color: Colors.black54))
                          //           ])),
                          //       RichText(
                          //           text: TextSpan(
                          //               text: 'popularity:',
                          //               style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontWeight: FontWeight.bold),
                          //               children: [
                          //             TextSpan(
                          //                 text:
                          //                     '${snapshot.data.results[selectedIndex].popularity}',
                          //                 style: TextStyle(color: Colors.black54))
                          //           ])),
                          //     ],
                          //   ),
                          // )
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 0.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            height: 100,
                            width: double.infinity, //데이터 없는애들때문에;
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: snapshot.data.results[selectedIndex]
                                          .overview !=
                                      ''
                                  ? Text(
                                      '${snapshot.data.results[selectedIndex].overview}',
                                      maxLines: 4, //아하.
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text('줄거리 준비중 입니다.'),
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
          ),
        ],
      ),
    );
  }

  Future<Movies2> _getMovieList() async {
    var response = await http.get(requestURL + api);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return Movies2.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
