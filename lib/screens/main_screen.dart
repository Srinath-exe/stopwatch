import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stopwatch/config/constants.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../widgets/button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Stopwatch stopwatch;
  AnimationController? _controller;
  AnimationController? _themecontroller;
  bool darkmode = true;
  late Timer t;
  int no = 0;
  AnimationController? _animationController;
  MyTheme theme = dark;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10))
          ..forward()
          ..addListener(() {
            if (_controller!.isCompleted) {
              _controller!.repeat();
            }
          });
    _themecontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450))
          ..forward()
          ..addListener(() {
            if (_controller!.isCompleted) {
              _controller!.repeat();
            }
          });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    stopwatch = Stopwatch();
    t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
    super.initState();
  }

  void startStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      _controller?.stop();
    } else {
      stopwatch.start();
      _controller?.forward();
    }
  }

  changeTheme() {
    setState(() {
      print("is u wokrings");
      if (darkmode = true) {
        theme = lighttheme;
      } else {
        theme = dark;
      }
    });
  }

  ScrollController _scrollController = new ScrollController();
  List<String> laps = [];
  StreamController<List<String>> lapsController =
      StreamController<List<String>>();
  onLap({bool? makeNull = false}) {
    if (makeNull == true) {
      laps = [];
    } else {
      laps.add(formattext());
    }
    lapsController.sink.add(laps);
  }

//
  String formattext(
      {bool? sec = false, bool? milli = false, bool? min = false}) {
    var time = stopwatch.elapsed.inMilliseconds;
    String milliseconds = (time % 1000).toString().padLeft(3, "0");

    String seconds = ((time ~/ 1000) % 60).toString().padLeft(2, "0");
    String minuits = ((time ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    if (milli == true) {
      return milliseconds;
    } else if (min == true) {
      return minuits;
    } else if (sec == true) {
      return seconds;
    }
    return "${((time ~/ 1000) ~/ 60)} $seconds.${milliseconds.substring(0, 2)}";
  }

  bool isEmpty() {
    return formattext() != "0 00.00" ? true : false;
  }

  bool play = false;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.secondary,
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Stopwatch",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: theme.white,
                          letterSpacing: 0.8),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    switching(
                        isEmpty(),
                        ZoomTapAnimation(
                          onTap: () {},
                          child: ThemeButton(
                            width: 80,
                            height: 60,
                            text: "Stop",
                            shape: CircleBorder(),
                            child: const Icon(
                              Icons.stop,
                              size: 20,
                            ),
                            onTap: () {
                              stopwatch.reset();
                              stopwatch.stop();
                              play = false;
                              _controller!.stop();
                              _controller!.reset();
                              _animationController!.reverse();
                              onLap(makeNull: true);
                            },
                          ),
                        )),
                    InkWell(
                      borderRadius: BorderRadius.circular(80),
                      onTap: () {
                        startStop();
                        setState(() {
                          play = !play;

                          play
                              ? _animationController!.forward()
                              : _animationController!.reverse();
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        width: play ? 140 : 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: theme.accent,
                            borderRadius: BorderRadius.circular(80)),
                        child: AnimatedIcon(
                          color: theme.black,
                          icon: AnimatedIcons.play_pause,
                          progress: _animationController!,
                        ),
                      ),
                    ),
                    switching(
                        isEmpty() || laps == [],
                        ZoomTapAnimation(
                          onTap: () {},
                          child: ThemeButton(
                            width: 80,
                            height: 60,
                            // bgColor: accent,
                            text: "Laps",
                            shape: CircleBorder(),
                            child: const Icon(
                              Icons.flag,
                              size: 20,
                            ),
                            onTap: () {
                              if (isEmpty()) {
                                onLap();
                                _controller!.forward(from: 0);
                              }
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn);
                              }
                            },
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
          // Positioned(
          //   top: 50,
          //   child: ZoomTapAnimation(
          //     onTap: () {
          //       setState(() {
          //         darkmode = !darkmode;
          //         changeTheme();
          //         darkmode
          //             ? _themecontroller!.forward()
          //             : _themecontroller!.reverse();
          //       });
          //     },
          //     child: Lottie.asset('assets/lottie/darkmode.json',
          //         repeat: true,
          //         controller: _themecontroller, onLoaded: (composition) {
          //       _controller!.stop();
          //     }, width: Config().deviceWidth(context) * 0.3),
          //   ),
          // ),
          Positioned(
            bottom: 140,
            child: StreamBuilder(
                stream: lapsController.stream,
                builder: ((context, snapshot) {
                  double h = 0;
                  snapshot.hasData ? h = 200 : h = 0;
                  if (snapshot.hasData) {
                    return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: h,
                        width: Config().deviceWidth(context),
                        child: ListWheelScrollView(
                            itemExtent: 40,
                            controller: _scrollController,
                            children:
                                List.generate(snapshot.data!.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "#${index + 1}   ",
                                      style: TextStyle(
                                          color: theme.white.withOpacity(0.6),
                                          fontSize: 12),
                                    ),
                                    Text(
                                      snapshot.data![index],
                                      style: TextStyle(
                                          color: theme.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              );
                            })));
                  } else {
                    return Container();
                  }
                })),
          ),
          Positioned(
            top: 100,
            child: Container(
              // color: Colors.red,
              width: 300,
              height: 430,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            timeanim(
                              formattext(min: true),
                              {stopwatch.elapsed.inSeconds % 2}.toString(),
                            ),
                            Row(
                              children: [
                                Text(
                                  "  :  ",
                                  style: TextStyle(
                                      fontSize: 26, color: theme.white),
                                ),
                                timeanim(
                                  formattext(sec: true),
                                  {stopwatch.elapsed.inSeconds % 2}.toString(),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "${formattext(milli: true)}",
                          style: TextStyle(
                              fontSize: 22,
                              color: theme.white.withOpacity(0.5),
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Lottie.asset(
                      'assets/lottie/timer.json',
                      repeat: true,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller!.stop();
                      },
                      width: 400,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    child: Transform.rotate(
                      angle: 3.1,
                      child: Lottie.asset('assets/lottie/timer.json',
                          repeat: true,
                          controller: _controller, onLoaded: (composition) {
                        _controller!.stop();
                      }, width: 400),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  timeanim(String fun, String key) {
    return AnimatedSwitcher(
        switchInCurve: Curves.bounceInOut,
        duration: Duration(milliseconds: 75),
        child: Text(
          fun,
          style: TextStyle(
              fontSize: 60, color: theme.white, fontWeight: FontWeight.w300),
          key: Key(fun),
        ),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        });
  }
}

switching(bool condition, Widget w1) {
  return AnimatedSwitcher(
      switchInCurve: Curves.bounceInOut,
      duration: Duration(milliseconds: 200),
      child: condition ? w1 : Container(),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      });
}
