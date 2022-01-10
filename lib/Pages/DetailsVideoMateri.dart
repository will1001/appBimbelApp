// import 'dart:html';

import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:fisikamu/Provider/GlobalProvider.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:fisikamu/Widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class DetailsVideoMateri extends StatefulWidget {
  const DetailsVideoMateri({Key? key}) : super(key: key);

  @override
  _DetailsVideoMateriState createState() => _DetailsVideoMateriState();
}

class _DetailsVideoMateriState extends State<DetailsVideoMateri> {
  Map args = {};
  var _chewieController;
  var vPlayerController;

  initialVideo(Map _arg) async {
    var globalProvider = Provider.of<GlobalProvider>(context, listen: false);

    vPlayerController = VideoPlayerController.network(
        globalProvider.baseUrl + _arg['link_video']);

    await vPlayerController.initialize();

    if (mounted) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: vPlayerController,
          // aspectRatio: 5 / 8,
          autoInitialize: true,
          autoPlay: false,
          looping: false,
          allowPlaybackSpeedChanging: false,
          materialProgressColors: ChewieProgressColors(
              handleColor: Colors.red.shade300,
              backgroundColor: Colors.red.shade300,
              playedColor: Colors.red.shade300,
              bufferedColor: Colors.red.shade300),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // print("_chewieController1212");
    // print(_chewieController);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);

      if (mounted) {
        setState(() {
          args = arguments;
        });
      }
      // print(jsonDecode(arguments['poin']).length);
      initialVideo(arguments);
    });
  }

  void dispose() {
    super.dispose();
    if (_chewieController != null) {
      _chewieController.dispose();
      _chewieController.pause();
    }
    if (vPlayerController != null) {
      vPlayerController.dispose();
      vPlayerController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _chewieController == null
          ? Loading()
          : _chewieController.autoInitialize
              ? Stack(
                  children: [
                    background(context, Color(0xFFffffff)),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: ListView(
                              children: [
                                // buttonStyle1(context, 100, "coba", Colors.white,Colors.black,
                                //     () {
                                //   if (mounted) {
                                //     setState(() {
                                //       _chewieController = ChewieController(
                                //         videoPlayerController:
                                //             vPlayerController,
                                //         // aspectRatio:5/8,
                                //         autoInitialize: true,
                                //         autoPlay: false,
                                //         looping: false,
                                //         allowPlaybackSpeedChanging: false,
                                //         startAt:
                                //             Duration(minutes: 3, seconds: 3),
                                //         materialProgressColors:
                                //             ChewieProgressColors(
                                //                 handleColor:
                                //                     Colors.red.shade300,
                                //                 backgroundColor:
                                //                     Colors.red.shade300,
                                //                 playedColor:
                                //                     Colors.red.shade300,
                                //                 bufferedColor:
                                //                     Colors.red.shade300),
                                //         errorBuilder: (context, errorMessage) {
                                //           return Center(
                                //             child: Text(
                                //               errorMessage,
                                //               style: TextStyle(
                                //                   color: Colors.white),
                                //             ),
                                //           );
                                //         },
                                //       );
                                //     });
                                //   }
                                // }),
                                // Chewie(
                                //   controller: _chewieController,
                                // ),
                                // Stack(
                                //   alignment: Alignment.center,
                                //   children: [
                                //     Container(
                                //       color: Colors.black,
                                //       width: MediaQuery.of(context).size.width,
                                //       height: 245,
                                //     ),
                                //     Image.asset(
                                //       'assets/images/PlayVideo.png',
                                //       width: 16,
                                //       height: 16,
                                //     )
                                //   ],
                                // ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Chewie(
                                      controller: _chewieController,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).size.height *
                                            0.4,
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, top: 15),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // customText(
                                                //     context,
                                                //     'Judul :',
                                                //     TextAlign.start,
                                                //     16,
                                                //     FontWeight.w400),
                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            70,
                                                    child: customText(
                                                        context,
                                                        '${args['judul']}',
                                                        TextAlign.start,
                                                        14,
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            children: [
                                              // customText(
                                              //     context,
                                              //     'Tutor :',
                                              //     TextAlign.start,
                                              //     16,
                                              //     FontWeight.w400),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70,
                                                  child: customText(
                                                      context,
                                                      '${args['tutor']}',
                                                      TextAlign.start,
                                                      14,
                                                      FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       left: 15.0, top: 30),
                                        //   child: customText(context, 'Deskripsi :',
                                        //       TextAlign.start, 16, FontWeight.w400),
                                        // ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Html(
                                              data: args['Deskripsi'] == null
                                                  ? ""
                                                  : args['Deskripsi']),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: (jsonDecode(args['poin'])
                                                    as List)
                                                .map((e) => GestureDetector(
                                                    onTap: () {
                                                      if (mounted) {
                                                        setState(() {
                                                          _chewieController =
                                                              ChewieController(
                                                            videoPlayerController:
                                                                vPlayerController,
                                                            // aspectRatio:5/8,
                                                            deviceOrientationsAfterFullScreen: [
                                                              DeviceOrientation
                                                                  .portraitUp,
                                                              DeviceOrientation
                                                                  .portraitDown
                                                            ],
                                                            deviceOrientationsOnEnterFullScreen: [
                                                              DeviceOrientation
                                                                  .portraitUp,
                                                              DeviceOrientation
                                                                  .portraitDown
                                                            ],
                                                            autoInitialize:
                                                                true,
                                                            autoPlay: false,
                                                            looping: false,
                                                            allowPlaybackSpeedChanging:
                                                                false,
                                                            startAt: Duration(
                                                                minutes: int.parse(e[
                                                                            'poin']
                                                                        .toString()
                                                                        .split(
                                                                            ":")[
                                                                    0]),
                                                                seconds: int.parse(e[
                                                                        'poin']
                                                                    .toString()
                                                                    .split(
                                                                        ":")[1])),
                                                            materialProgressColors: ChewieProgressColors(
                                                                handleColor:
                                                                    Colors.red
                                                                        .shade300,
                                                                backgroundColor:
                                                                    Colors.red
                                                                        .shade300,
                                                                playedColor:
                                                                    Colors.red
                                                                        .shade300,
                                                                bufferedColor:
                                                                    Colors.red
                                                                        .shade300),
                                                            errorBuilder: (context,
                                                                errorMessage) {
                                                              return Center(
                                                                child: Text(
                                                                  errorMessage,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      // child: Text(
                                                      //     "${e['keterangan']} (${e['poin']})"),
                                                      child: RichText(
                                                          text: TextSpan(
                                                        text:
                                                            '${e['keterangan']} ( ',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  '${e['poin']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                              )),
                                                          TextSpan(
                                                              text: ' )',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ],
                                                      )),
                                                    )))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // BottomNav()
                      ],
                    ),
                  ],
                )
              : Loading(),
    );
  }

  // Widget basicOverlayWidget() {
  //   return Stack(
  //     children: [VideoProgressIndicator(_controller, allowScrubbing: true)],
  //   );
  // }
}
