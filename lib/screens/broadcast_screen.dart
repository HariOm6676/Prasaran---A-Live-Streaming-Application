import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_conferencing/config/appid.dart';
import 'package:video_conferencing/providers/user_provider.dart';
import 'package:video_conferencing/resources/firestore_methods.dart';
import 'package:video_conferencing/responsive/responsive_layout.dart';
import 'package:video_conferencing/screens/home_screen.dart';
import 'package:video_conferencing/widgets/chat.dart';
import 'package:video_conferencing/widgets/custom_button.dart';

class BroadcastScreen extends StatefulWidget {
  final bool isBrodcaster;
  final String channelId;

  const BroadcastScreen(
      {super.key, required this.isBrodcaster, required this.channelId});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  bool switchCamera = true;
  bool isMuted = false;
  bool isScreenSharing = false;
  List<int> remoteUid = [];
  void _initEngine() async {
    print("inside init engine");
    _engine = await RtcEngine.createWithContext(
      RtcEngineContext(appId),
    );

    print("engine 2");
    _addListener();
    await _engine.enableVideo();
    await _engine.startPreview();
    print("engine 3");
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    print("engine 4");
    if (widget.isBrodcaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = "https://prasaran-go-server.onrender.com";
  String? token;
  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(baseUrl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          Provider.of<UserProvider>(context, listen: false).user.uid +
          '/'),
    );
    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
        print("tokne $token");
      });
    } else {
      debugPrint('Failed to fetch Token ');
    }
  }

  void _addListener() {
    _engine.setEventHandler(
      RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
      }, userJoined: (uid, elapsed) {
        debugPrint('userJoined $uid $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      }, userOffline: (uid, reason) {
        debugPrint('userOffline $uid $reason');
        setState(() {
          remoteUid.remove((element) => element == uid);
        });
      }, leaveChannel: (stats) {
        debugPrint('leaveChannel $stats');
        setState(() {
          remoteUid.clear();
        });
      }, tokenPrivilegeWillExpire: (token) async {
        await getToken();
        await _engine.renewToken(token);
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    print("initializing engine");
    _initEngine();
  }

  void _joinChannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
      await _engine.joinChannelWithUserAccount(token, widget.channelId,
          Provider.of<UserProvider>(context, listen: false).user.uid);
    }
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  _startScreenShare() async {
    final helper = await _engine.getScreenShareHelper(
        appGroup: kIsWeb || Platform.isWindows ? null : 'io.agora');
    await helper.disableAudio();
    await helper.enableVideo();
    await helper.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await helper.setClientRole(ClientRole.Broadcaster);
    var windowId = 0;
    var random = Random();
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isAndroid)) {
      final windows = _engine.enumerateWindows();
      if (windows.isEmpty) {
        final index = random.nextInt(windows.length - 1);
        debugPrint("Screening window with index");
        windowId = windows[index].id;
      }
    }
    await helper.startScreenCaptureByWindowId(windowId);
    setState(() {
      isScreenSharing = true;
    });
    await helper.joinChannelWithUserAccount(token, widget.channelId,
        Provider.of<UserProvider>(context, listen: false).user.uid);
  }

  _stopScreenShare() async {
    final helper = await _engine.getScreenShareHelper();
    await helper.destroy().then((value) {
      setState(() {
        isScreenSharing = false;
      });
    }).catchError((err) {
      debugPrint('Stop ScreenShare $err');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if ('${Provider.of<UserProvider>(context, listen: false).user.uid}${Provider.of<UserProvider>(context, listen: false).user.username}' ==
        widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    var isMuted2 = isMuted;
    return PopScope(
      onPopInvoked: (didPop) async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: widget.isBrodcaster
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomButton(onTap: _leaveChannel, text: 'End Stream'),
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ResponsiveLayout(
            dekstopbody: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _renderVideo(user, isScreenSharing),
                        if ("${user.uid}${user.username}" == widget.channelId)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: _switchCamera,
                                child: const Text('Switch Camera'),
                              ),
                              InkWell(
                                onTap: onToggleMute,
                                child: Text((isMuted2) ? 'Unmute' : 'Mute'),
                              ),
                              InkWell(
                                onTap: isScreenSharing
                                    ? _stopScreenShare
                                    : _startScreenShare,
                                child: Text(isScreenSharing
                                    ? "Stop ScreenSharing"
                                    : 'ScreenSharing'),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Chat(channelId: widget.channelId),
              ],
            ),
            mobilebody: Column(
              children: [
                _renderVideo(user, isScreenSharing),
                if ("${user.uid}${user.username}" == widget.channelId)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: _switchCamera,
                        child: const Text('Switch Camera'),
                      ),
                      InkWell(
                        onTap: onToggleMute,
                        child: Text((isMuted2) ? 'Unmute' : 'Mute'),
                      )
                    ],
                  ),
                Expanded(
                  child: Chat(
                    channelId: widget.channelId,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderVideo(user, isScreenSharing) {
    return AspectRatio(
      aspectRatio: 16 / 8,
      child: "${user.uid}${user.username}" == widget.channelId
          ? isScreenSharing
              ? kIsWeb
                  ? const RtcLocalView.SurfaceView.screenShare()
                  : const RtcLocalView.SurfaceView.screenShare()
              : RtcLocalView.SurfaceView(
                  zOrderMediaOverlay: true,
                  zOrderOnTop: true,
                )
          : isScreenSharing
              ? kIsWeb
                  ? const RtcLocalView.SurfaceView.screenShare()
                  : const RtcLocalView.SurfaceView.screenShare()
              : remoteUid.isNotEmpty
                  ? kIsWeb
                      ? RtcRemoteView.SurfaceView(
                          uid: remoteUid[0],
                          channelId: widget.channelId,
                        )
                      : RtcRemoteView.TextureView(
                          uid: remoteUid[0],
                          channelId: widget.channelId,
                        )
                  : Container(),
    );
  }
}
// flutter build web --web-renderer html 