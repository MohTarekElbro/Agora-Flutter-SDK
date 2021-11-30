import 'dart:convert';
import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/src/api_types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test_app/main.dart' as app;
import 'package:integration_test_app/src/fake_iris_rtc_engine.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RtcEngine rtcEngine;
  late FakeIrisRtcEngine nireHandler;

  setUp(() async {
    nireHandler = FakeIrisRtcEngine();
    await nireHandler.initialize();
  });

  tearDown(() async {
    await rtcEngine.destroy();
    nireHandler.dispose();
  });

  group('createWithContext', () {
    testWidgets('with `appId`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      final context = RtcEngineContext('123');

      rtcEngine = await RtcEngine.createWithContext(context);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineInitialize.index,
        jsonEncode({
          'context': context.toJson(),
        }),
      );

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSetAppType.index,
        jsonEncode({
          'appType': 4,
        }),
      );
    });

    testWidgets('with `appId` and `areaCode`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      final context = RtcEngineContext('123', areaCode: const [AreaCode.CN]);

      rtcEngine = await RtcEngine.createWithContext(context);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineInitialize.index,
        jsonEncode({
          'context': context.toJson(),
        }),
      );

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSetAppType.index,
        jsonEncode({
          'appType': 4,
        }),
      );
    });

    testWidgets('with `appId`, `areaCode` and `logConfig`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      final context = RtcEngineContext(
        '123',
        areaCode: const [AreaCode.CN],
        logConfig: LogConfig(filePath: '/path'),
      );

      rtcEngine = await RtcEngine.createWithContext(context);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineInitialize.index,
        jsonEncode({
          'context': context.toJson(),
        }),
      );

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSetAppType.index,
        jsonEncode({
          'appType': 4,
        }),
      );
    });
  });

  testWidgets('create', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineInitialize.index,
      jsonEncode({
        'context': RtcEngineContext('123').toJson(),
      }),
    );

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAppType.index,
      jsonEncode({
        'appType': 4,
      }),
    );
  });

  testWidgets('setChannelProfile', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    const channelProfile = ChannelProfile.LiveBroadcasting;
    await rtcEngine.setChannelProfile(channelProfile);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetChannelProfile.index,
      jsonEncode({
        'profile': 1,
      }),
    );
  });

  group('setClientRole', () {
    testWidgets('with `role`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();

      await rtcEngine.setClientRole(ClientRole.Broadcaster);
      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSetClientRole.index,
        jsonEncode({
          'role': 1,
          'options': null,
        }),
      );
    });

    testWidgets('with `role` and `options`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();

      final options = ClientRoleOptions(
        audienceLatencyLevel: AudienceLatencyLevelType.UltraLowLatency,
      );
      await rtcEngine.setClientRole(ClientRole.Broadcaster, options);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSetClientRole.index,
        jsonEncode({
          'role': 1,
          'options': options.toJson(),
        }),
      );
    });
  });

  group('joinChannel', () {
    testWidgets('with `token`, `channelName`, `optionalInfo` and `optionalUid`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.joinChannel(null, 'testapi', null, 1);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineJoinChannel.index,
        jsonEncode({
          'token': null,
          'channelId': 'testapi',
          'info': null,
          'uid': 1,
          'options': null,
        }),
      );
    });

    testWidgets(
        'with `token`, `channelName`, `optionalInfo`, `optionalUid` and `options`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final ChannelMediaOptions options =
          ChannelMediaOptions(autoSubscribeAudio: true);
      await rtcEngine.joinChannel(null, 'testapi', null, 1, options);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineJoinChannel.index,
        jsonEncode({
          'token': null,
          'channelId': 'testapi',
          'info': null,
          'uid': 1,
          'options': options.toJson(),
        }),
      );
    });
  });

  group('switchChannel', () {
    testWidgets('with `token`, `channelName`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.switchChannel(null, 'testapi');

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSwitchChannel.index,
        jsonEncode({
          'token': null,
          'channelId': 'testapi',
          'options': null,
        }),
      );
    });

    testWidgets('with `token`, `channelName`, `options`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final ChannelMediaOptions options =
          ChannelMediaOptions(autoSubscribeAudio: true);
      await rtcEngine.switchChannel(null, 'testapi', options);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineSwitchChannel.index,
        jsonEncode({
          'token': null,
          'channelId': 'testapi',
          'options': options.toJson(),
        }),
      );
    });
  });

  testWidgets('leaveChannel', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.leaveChannel();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineLeaveChannel.index,
      jsonEncode({}),
    );
  });

  testWidgets('renewToken', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.renewToken('123');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineRenewToken.index,
      jsonEncode({
        'token': '123',
      }),
    );
  });

  testWidgets('getConnectionState', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
      ApiTypeEngine.kEngineGetConnectionState.index,
      jsonEncode({}),
      3,
    );

    rtcEngine = await _createEngine();
    final ret = await rtcEngine.getConnectionState();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetConnectionState.index,
      jsonEncode({}),
    );

    expect(ret, ConnectionStateType.Connected);
  });

  testWidgets('getCallId', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiResult(
      ApiTypeEngine.kEngineGetCallId.index,
      jsonEncode({}),
      '2',
    );

    rtcEngine = await _createEngine();
    final ret = await rtcEngine.getCallId();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetCallId.index,
      jsonEncode({}),
    );

    expect(ret, '2');
  });

  group('rate', () {
    testWidgets('with `callId`, `rating`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.rate('123', 5);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineRate.index,
        jsonEncode({
          'callId': '123',
          'rating': 5,
          'description': null,
        }),
      );
    });

    testWidgets('with `callId`, `rating`, `description`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.rate('123', 5, description: 'des');

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineRate.index,
        jsonEncode({
          'callId': '123',
          'rating': 5,
          'description': 'des',
        }),
      );
    });
  });

  testWidgets('complain', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.complain('123', 'des');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineComplain.index,
      jsonEncode({
        'callId': '123',
        'description': 'des',
      }),
    );
  });

  testWidgets('setParameters', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setParameters('params');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetParameters.index,
      jsonEncode({
        'parameters': 'params',
      }),
    );
  });

  testWidgets('getUserInfoByUid', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    final expectedUserInfo = UserInfo(10, 'user1');

    nireHandler.mockCallApiResult(
      ApiTypeEngine.kEngineGetUserInfoByUid.index,
      jsonEncode({
        'uid': 10,
      }),
      jsonEncode(expectedUserInfo.toJson()),
    );

    rtcEngine = await _createEngine();
    final ret = await rtcEngine.getUserInfoByUid(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetUserInfoByUid.index,
      jsonEncode({
        'uid': 10,
      }),
    );

    expect(jsonEncode(ret), jsonEncode(expectedUserInfo.toJson()));
  });

  testWidgets('getUserInfoByUserAccount', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    final expectedUserInfo = UserInfo(10, 'user1');

    nireHandler.mockCallApiResult(
      ApiTypeEngine.kEngineGetUserInfoByUserAccount.index,
      jsonEncode({
        'userAccount': 'user1',
      }),
      jsonEncode(expectedUserInfo.toJson()),
    );

    rtcEngine = await _createEngine();
    final ret = await rtcEngine.getUserInfoByUserAccount('user1');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetUserInfoByUserAccount.index,
      jsonEncode({
        'userAccount': 'user1',
      }),
    );

    expect(jsonEncode(ret), jsonEncode(expectedUserInfo.toJson()));
  });

  group('joinChannelWithUserAccount', () {
    testWidgets('with `token`, `channelName`, `userAccount`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.joinChannelWithUserAccount(null, 'testapi', 'user1');

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineJoinChannelWithUserAccount.index,
        jsonEncode({
          'token': null,
          'channelId': 'testapi',
          'userAccount': 'user1',
          'options': null,
        }),
      );
    });

    testWidgets('with `token`, `channelName`, `userAccount`, `options`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final ChannelMediaOptions options = ChannelMediaOptions(
        autoSubscribeAudio: true,
      );
      await rtcEngine.joinChannelWithUserAccount(
          null, 'testapi', 'user1', options);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineJoinChannelWithUserAccount.index,
        jsonEncode({
          'token': null,
          'channelId': 'testapi',
          'userAccount': 'user1',
          'options': options.toJson(),
        }),
      );
    });
  });

  testWidgets('registerLocalUserAccount', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.registerLocalUserAccount('123', 'user1');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineRegisterLocalUserAccount.index,
      jsonEncode({
        'appId': '123',
        'userAccount': 'user1',
      }),
    );
  });

  testWidgets('adjustPlaybackSignalVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.adjustPlaybackSignalVolume(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAdjustPlaybackSignalVolume.index,
      jsonEncode({
        'volume': 10,
      }),
    );
  });

  testWidgets('adjustRecordingSignalVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.adjustRecordingSignalVolume(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAdjustRecordingSignalVolume.index,
      jsonEncode({
        'volume': 10,
      }),
    );
  });

  testWidgets('adjustUserPlaybackSignalVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.adjustUserPlaybackSignalVolume(123, 10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAdjustUserPlaybackSignalVolume.index,
      jsonEncode({
        'uid': 123,
        'volume': 10,
      }),
    );
  });

  testWidgets('disableAudio', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.disableAudio();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineDisableAudio.index,
      jsonEncode({}),
    );
  });

  testWidgets('enableAudio', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableAudio();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableAudio.index,
      jsonEncode({}),
    );
  });

  testWidgets('enableAudioVolumeIndication', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableAudioVolumeIndication(10, 10, true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableAudioVolumeIndication.index,
      jsonEncode({
        'interval': 10,
        'smooth': 10,
        'report_vad': true,
      }),
    );
  });

  testWidgets('enableLocalAudio', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableLocalAudio(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableLocalAudio.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('muteAllRemoteAudioStreams', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.muteAllRemoteAudioStreams(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineMuteAllRemoteAudioStreams.index,
      jsonEncode({
        'mute': true,
      }),
    );
  });

  testWidgets('muteLocalAudioStream', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.muteLocalAudioStream(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineMuteLocalAudioStream.index,
      jsonEncode({
        'mute': true,
      }),
    );
  });

  testWidgets('muteRemoteAudioStream', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.muteRemoteAudioStream(10, true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineMuteRemoteAudioStream.index,
      jsonEncode({
        'userId': 10,
        'mute': true,
      }),
    );
  });

  testWidgets('setAudioProfile', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setAudioProfile(
      AudioProfile.Default,
      AudioScenario.Default,
    );

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAudioProfile.index,
      jsonEncode({
        'profile': 0,
        'scenario': 0,
      }),
    );
  });

  testWidgets('disableVideo', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.disableVideo();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineDisableVideo.index,
      jsonEncode({}),
    );
  });

  testWidgets('enableLocalVideo', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableLocalVideo(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableLocalVideo.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('enableVideo', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableVideo();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableVideo.index,
      jsonEncode({}),
    );
  });

  testWidgets('muteAllRemoteVideoStreams', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.muteAllRemoteVideoStreams(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineMuteAllRemoteVideoStreams.index,
      jsonEncode({
        'mute': true,
      }),
    );
  });

  testWidgets('muteLocalVideoStream', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.muteLocalVideoStream(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineMuteLocalVideoStream.index,
      jsonEncode({
        'mute': true,
      }),
    );
  });

  testWidgets('muteRemoteVideoStream', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.muteRemoteVideoStream(10, true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineMuteRemoteVideoStream.index,
      jsonEncode({
        'userId': 10,
        'mute': true,
      }),
    );
  });

  testWidgets('setBeautyEffectOptions', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    BeautyOptions options =
        BeautyOptions(lighteningContrastLevel: LighteningContrastLevel.High);
    await rtcEngine.setBeautyEffectOptions(true, options);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetBeautyEffectOptions.index,
      jsonEncode({
        'enabled': true,
        'options': options.toJson(),
      }),
    );
  });

  testWidgets('setVideoEncoderConfiguration', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    VideoEncoderConfiguration config = VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 10, height: 10));
    await rtcEngine.setVideoEncoderConfiguration(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetVideoEncoderConfiguration.index,
      jsonEncode({
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('startPreview', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.startPreview();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStartPreview.index,
      jsonEncode({}),
    );
  });

  testWidgets('stopPreview', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopPreview();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopPreview.index,
      jsonEncode({}),
    );
  });

  testWidgets('adjustAudioMixingPlayoutVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.adjustAudioMixingPlayoutVolume(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAdjustAudioMixingPlayoutVolume.index,
      jsonEncode({
        'volume': 10,
      }),
    );
  });

  testWidgets('adjustAudioMixingPublishVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.adjustAudioMixingPublishVolume(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAdjustAudioMixingPublishVolume.index,
      jsonEncode({
        'volume': 10,
      }),
    );
  });

  testWidgets('adjustAudioMixingVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.adjustAudioMixingVolume(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAdjustAudioMixingVolume.index,
      jsonEncode({
        'volume': 10,
      }),
    );
  });

  testWidgets('getAudioMixingCurrentPosition', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
        ApiTypeEngine.kEngineGetAudioMixingCurrentPosition.index,
        jsonEncode({}),
        10);

    rtcEngine = await _createEngine();

    final ret = await rtcEngine.getAudioMixingCurrentPosition();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetAudioMixingCurrentPosition.index,
      jsonEncode({}),
    );

    expect(ret, 10);
  });

  testWidgets('getAudioMixingDuration', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
        ApiTypeEngine.kEngineGetAudioMixingDuration.index, jsonEncode({}), 10);

    rtcEngine = await _createEngine();

    final ret = await rtcEngine.getAudioMixingDuration();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetAudioMixingDuration.index,
      jsonEncode({}),
    );

    expect(ret, 10);
  });

  testWidgets('getAudioMixingPlayoutVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
        ApiTypeEngine.kEngineGetAudioMixingPlayoutVolume.index,
        jsonEncode({}),
        10);

    rtcEngine = await _createEngine();

    final ret = await rtcEngine.getAudioMixingPlayoutVolume();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetAudioMixingPlayoutVolume.index,
      jsonEncode({}),
    );

    expect(ret, 10);
  });

  testWidgets('getAudioMixingPublishVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
        ApiTypeEngine.kEngineGetAudioMixingPublishVolume.index,
        jsonEncode({}),
        10);

    rtcEngine = await _createEngine();

    final ret = await rtcEngine.getAudioMixingPublishVolume();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetAudioMixingPublishVolume.index,
      jsonEncode({}),
    );

    expect(ret, 10);
  });

  testWidgets('pauseAudioMixing', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.pauseAudioMixing();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEnginePauseAudioMixing.index,
      jsonEncode({}),
    );
  });

  testWidgets('resumeAudioMixing', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.resumeAudioMixing();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineResumeAudioMixing.index,
      jsonEncode({}),
    );
  });

  testWidgets('setAudioMixingPosition', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setAudioMixingPosition(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAudioMixingPosition.index,
      jsonEncode({
        'pos': 10,
      }),
    );
  });

  group('startAudioMixing', () {
    testWidgets('with `filePath`, `loopback`, `replace`, `cycle`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();

      await rtcEngine.startAudioMixing('/path', true, true, 10);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartAudioMixing.index,
        jsonEncode({
          'filePath': '/path',
          'loopback': true,
          'replace': true,
          'cycle': 10,
        }),
      );
    });

    testWidgets('with `filePath`, `loopback`, `replace`, `cycle`, `startPos`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();

      await rtcEngine.startAudioMixing('/path', true, true, 10, 20);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartAudioMixing.index,
        jsonEncode({
          'filePath': '/path',
          'loopback': true,
          'replace': true,
          'cycle': 10,
        }),
      );
    });
  });

  testWidgets('stopAudioMixing', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopAudioMixing();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopAudioMixing.index,
      jsonEncode({}),
    );
  });

  testWidgets('addInjectStreamUrl', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    final LiveInjectStreamConfig config =
        LiveInjectStreamConfig(width: 10, height: 10);

    await rtcEngine.addInjectStreamUrl('https://example.com', config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAddInjectStreamUrl.index,
      jsonEncode({
        'url': 'https://example.com',
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('addPublishStreamUrl', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.addPublishStreamUrl('https://example.com', true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAddPublishStreamUrl.index,
      jsonEncode({
        'url': 'https://example.com',
        'transcodingEnabled': true,
      }),
    );
  });

  testWidgets('addVideoWatermark', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    final WatermarkOptions options = WatermarkOptions(visibleInPreview: true);
    await rtcEngine.addVideoWatermark('https://example.com', options);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineAddVideoWaterMark.index,
      jsonEncode({
        'watermarkUrl': 'https://example.com',
        'options': options.toJson(),
      }),
    );
  });

  testWidgets('clearVideoWatermarks', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.clearVideoWatermarks();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineClearVideoWaterMarks.index,
      jsonEncode({}),
    );
  });

  testWidgets('createDataStream', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
        ApiTypeEngine.kEngineCreateDataStream.index,
        jsonEncode({
          'reliable': true,
          'ordered': true,
        }),
        10);

    rtcEngine = await _createEngine();

    final ret = await rtcEngine.createDataStream(true, true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineCreateDataStream.index,
      jsonEncode({
        'reliable': true,
        'ordered': true,
      }),
    );

    expect(ret, 10);
  });

  testWidgets('disableLastmileTest', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.disableLastmileTest();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineDisableLastMileTest.index,
      jsonEncode({}),
    );
  });

  testWidgets('enableDualStreamMode', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.enableDualStreamMode(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableDualStreamMode.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('enableInEarMonitoring', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.enableInEarMonitoring(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableInEarMonitoring.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('enableLastmileTest', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.enableLastmileTest();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableLastMileTest.index,
      jsonEncode({}),
    );
  });

  testWidgets('enableSoundPositionIndication', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.enableSoundPositionIndication(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableSoundPositionIndication.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('isSpeakerphoneEnabled', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiReturnCode(
      ApiTypeEngine.kEngineIsSpeakerPhoneEnabled.index,
      jsonEncode({}),
      1,
    );

    rtcEngine = await _createEngine();

    final ret = await rtcEngine.isSpeakerphoneEnabled();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineIsSpeakerPhoneEnabled.index,
      jsonEncode({}),
    );

    expect(ret, true);
  });

  testWidgets('pauseAllEffects', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.pauseAllEffects();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEnginePauseAllEffects.index,
      jsonEncode({}),
    );
  });

  testWidgets('pauseEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.pauseEffect(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEnginePauseEffect.index,
      jsonEncode({
        'soundId': 10,
      }),
    );
  });

  group('playEffect', () {
    testWidgets(
        'with `soundId`, `filePath`, `loopCount`, `pitch`, `pan`, `gain`, `publish`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();

      await rtcEngine.playEffect(10, '/path', 10, 1.0, 2.0, 3.0, true);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEnginePlayEffect.index,
        jsonEncode({
          'soundId': 10,
          'filePath': '/path',
          'loopCount': 10,
          'pitch': 1.0,
          'pan': 2.0,
          'gain': 3.0,
          'publish': true,
          'startPos': null,
        }),
      );
    });

    testWidgets(
        'with `soundId`, `filePath`, `loopCount`, `pitch`, `pan`, `gain`, `publish`, `startPos`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();

      await rtcEngine.playEffect(10, '/path', 10, 1.0, 2.0, 3.0, true, 20);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEnginePlayEffect.index,
        jsonEncode({
          'soundId': 10,
          'filePath': '/path',
          'loopCount': 10,
          'pitch': 1.0,
          'pan': 2.0,
          'gain': 3.0,
          'publish': true,
          'startPos': 20,
        }),
      );
    });
  });

  testWidgets('setEffectPosition', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setEffectPosition(10, 20);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetEffectPosition.index,
      jsonEncode({
        'soundId': 10,
        'pos': 20,
      }),
    );
  });

  testWidgets('getEffectDuration', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.getEffectDuration('/path');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetEffectDuration.index,
      jsonEncode({
        'filePath': '/path',
      }),
    );
  });

  testWidgets('getEffectCurrentPosition', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.getEffectCurrentPosition(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineGetEffectCurrentPosition.index,
      jsonEncode({
        'soundId': 10,
      }),
    );
  });

  testWidgets('preloadEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.preloadEffect(10, '/path');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEnginePreloadEffect.index,
      jsonEncode({
        'soundId': 10,
        'filePath': '/path',
      }),
    );
  });

  testWidgets('preloadEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.preloadEffect(10, '/path');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEnginePreloadEffect.index,
      jsonEncode({
        'soundId': 10,
        'filePath': '/path',
      }),
    );
  });

  testWidgets('registerMediaMetadataObserver', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.registerMediaMetadataObserver();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineRegisterMediaMetadataObserver.index,
      jsonEncode({}),
    );
  });

  testWidgets('removeInjectStreamUrl', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.removeInjectStreamUrl('https://example.com');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineRemoveInjectStreamUrl.index,
      jsonEncode({
        'url': 'https://example.com',
      }),
    );
  });

  testWidgets('removePublishStreamUrl', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.removePublishStreamUrl('https://example.com');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineRemovePublishStreamUrl.index,
      jsonEncode({
        'url': 'https://example.com',
      }),
    );
  });

  testWidgets('resumeAllEffects', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.resumeAllEffects();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineResumeAllEffects.index,
      jsonEncode({}),
    );
  });

  testWidgets('resumeEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.resumeEffect(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineResumeEffect.index,
      jsonEncode({
        'soundId': 10,
      }),
    );
  });

  testWidgets('sendMetadata', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    final bytes = Uint8List.fromList([1, 1, 1, 1, 1]);

    nireHandler.setExplicitBufferSize(
        ApiTypeEngine.kEngineResumeEffect.index,
        jsonEncode({
          'metadata': {
            'size': bytes.length,
          },
        }),
        bytes.length);

    rtcEngine = await _createEngine();

    await rtcEngine.sendMetadata(bytes);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSendMetadata.index,
      jsonEncode({
        'metadata': {
          'size': bytes.length,
        },
      }),
      buffer: bytes,
      bufferSize: bytes.length,
    );
  });

  testWidgets('sendStreamMessage', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    final bytes = Uint8List.fromList([1, 1, 1, 1, 1]);

    nireHandler.setExplicitBufferSize(
        ApiTypeEngine.kEngineSendStreamMessage.index,
        jsonEncode({
          'streamId': 10,
          'length': bytes.length,
        }),
        bytes.length);

    rtcEngine = await _createEngine();

    await rtcEngine.sendStreamMessage(10, bytes);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSendStreamMessage.index,
      jsonEncode({
        'streamId': 10,
        'length': bytes.length,
      }),
      buffer: bytes,
      bufferSize: bytes.length,
    );
  });

  testWidgets('setCameraCapturerConfiguration', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    final CameraCapturerConfiguration config = CameraCapturerConfiguration(
        preference: CameraCaptureOutputPreference.Performance);
    await rtcEngine.setCameraCapturerConfiguration(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetCameraCapturerConfiguration.index,
      jsonEncode({
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('setDefaultAudioRoutetoSpeakerphone',
      (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setDefaultAudioRoutetoSpeakerphone(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetDefaultAudioRouteToSpeakerPhone.index,
      jsonEncode({
        'defaultToSpeaker': true,
      }),
    );
  });

  testWidgets('setEffectsVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setEffectsVolume(10.0);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetEffectsVolume.index,
      jsonEncode({
        'volume': 10.0,
      }),
    );
  });

  testWidgets('setEnableSpeakerphone', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setEnableSpeakerphone(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetEnableSpeakerPhone.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('setInEarMonitoringVolume', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setInEarMonitoringVolume(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetInEarMonitoringVolume.index,
      jsonEncode({
        'volume': 10,
      }),
    );
  });

  testWidgets('setLiveTranscoding', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final LiveTranscoding transcoding =
        LiveTranscoding([TranscodingUser(100)], width: 10, height: 10);
    await rtcEngine.setLiveTranscoding(transcoding);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetLiveTranscoding.index,
      jsonEncode({
        'transcoding': transcoding.toJson(),
      }),
    );
  });

  testWidgets('setLocalPublishFallbackOption', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine
        .setLocalPublishFallbackOption(StreamFallbackOptions.AudioOnly);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetLocalPublishFallbackOption.index,
      jsonEncode({
        'option': 2,
      }),
    );
  });

  testWidgets('setLocalVoiceEqualization', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setLocalVoiceEqualization(
      AudioEqualizationBandFrequency.Band4K,
      10,
    );

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetLocalVoiceEqualization.index,
      jsonEncode({
        'bandFrequency': 7,
        'bandGain': 10,
      }),
    );
  });

  testWidgets('setLocalVoicePitch', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setLocalVoicePitch(10.0);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetLocalVoicePitch.index,
      jsonEncode({
        'pitch': 10.0,
      }),
    );
  });

  testWidgets('setLocalVoiceReverb', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setLocalVoiceReverb(AudioReverbType.RoomSize, 10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetLocalVoiceReverb.index,
      jsonEncode({
        'reverbKey': 2,
        'value': 10,
      }),
    );
  });

  testWidgets('setMaxMetadataSize', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setMaxMetadataSize(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetMaxMetadataSize.index,
      jsonEncode({
        'size': 10,
      }),
    );
  });

  testWidgets('setRemoteDefaultVideoStreamType', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setRemoteDefaultVideoStreamType(VideoStreamType.High);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetRemoteDefaultVideoStreamType.index,
      jsonEncode({
        'streamType': 0,
      }),
    );
  });

  testWidgets('setRemoteSubscribeFallbackOption', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine
        .setRemoteSubscribeFallbackOption(StreamFallbackOptions.AudioOnly);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetRemoteSubscribeFallbackOption.index,
      jsonEncode({
        'option': 2,
      }),
    );
  });

  testWidgets('setRemoteUserPriority', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setRemoteUserPriority(10, UserPriority.High);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetRemoteUserPriority.index,
      jsonEncode({
        'uid': 10,
        'userPriority': 50,
      }),
    );
  });

  testWidgets('setRemoteVideoStreamType', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setRemoteVideoStreamType(10, VideoStreamType.High);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetRemoteVideoStreamType.index,
      jsonEncode({
        'uid': 10,
        'streamType': 0,
      }),
    );
  });

  testWidgets('setRemoteVoicePosition', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setRemoteVoicePosition(10, 1.0, 2.0);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetRemoteVoicePosition.index,
      jsonEncode({
        'uid': 10,
        'pan': 1.0,
        'gain': 2.0,
      }),
    );
  });

  testWidgets('setVolumeOfEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setVolumeOfEffect(10, 10.0);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetVolumeOfEffect.index,
      jsonEncode({
        'soundId': 10,
        'volume': 10.0,
      }),
    );
  });

  testWidgets('startAudioRecordingWithConfig', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final AudioRecordingConfiguration config =
        AudioRecordingConfiguration('/path');
    await rtcEngine.startAudioRecordingWithConfig(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStartAudioRecording.index,
      jsonEncode({
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('startChannelMediaRelay', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final ChannelMediaRelayConfiguration config =
        ChannelMediaRelayConfiguration(
      ChannelMediaInfo('testapi', 10),
      [ChannelMediaInfo('testapi', 100)],
    );
    await rtcEngine.startChannelMediaRelay(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStartChannelMediaRelay.index,
      jsonEncode({
        'configuration': config.toJson(),
      }),
    );
  });

  testWidgets('startEchoTest', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.startEchoTest(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStartEchoTest.index,
      jsonEncode({
        'intervalInSeconds': 10,
      }),
    );
  });

  testWidgets('startLastmileProbeTest', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    final LastmileProbeConfig config = LastmileProbeConfig(true, true, 10, 20);

    await rtcEngine.startLastmileProbeTest(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStartLastMileProbeTest.index,
      jsonEncode({
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('stopAllEffects', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopAllEffects();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopAllEffects.index,
      jsonEncode({}),
    );
  });

  testWidgets('stopAudioRecording', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopAudioRecording();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopAudioRecording.index,
      jsonEncode({}),
    );
  });

  testWidgets('stopChannelMediaRelay', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopChannelMediaRelay();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopChannelMediaRelay.index,
      jsonEncode({}),
    );
  });

  testWidgets('stopEchoTest', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopEchoTest();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopEchoTest.index,
      jsonEncode({}),
    );
  });

  testWidgets('stopEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopEffect(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopEffect.index,
      jsonEncode({
        'soundId': 10,
      }),
    );
  });

  testWidgets('stopLastmileProbeTest', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.stopLastmileProbeTest();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopLastMileProbeTest.index,
      jsonEncode({}),
    );
  });

  testWidgets('switchCamera', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.switchCamera();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSwitchCamera.index,
      jsonEncode({}),
    );
  });

  testWidgets('unloadEffect', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.unloadEffect(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineUnloadEffect.index,
      jsonEncode({
        'soundId': 10,
      }),
    );
  });

  testWidgets('unregisterMediaMetadataObserver', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.unregisterMediaMetadataObserver();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineUnRegisterMediaMetadataObserver.index,
      jsonEncode({}),
    );
  });

  testWidgets('updateChannelMediaRelay', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final ChannelMediaRelayConfiguration config =
        ChannelMediaRelayConfiguration(
      ChannelMediaInfo('testapi', 10),
      [ChannelMediaInfo('testapi', 10)],
    );
    await rtcEngine.updateChannelMediaRelay(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineUpdateChannelMediaRelay.index,
      jsonEncode({
        'configuration': config.toJson(),
      }),
    );
  });

  testWidgets('enableFaceDetection', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.enableFaceDetection(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableFaceDetection.index,
      jsonEncode({
        'enable': true,
      }),
    );
  });

  testWidgets('setAudioMixingPitch', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();

    await rtcEngine.setAudioMixingPitch(10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAudioMixingPitch.index,
      jsonEncode({
        'pitch': 10,
      }),
    );
  });

  testWidgets('enableEncryption', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final EncryptionConfig config =
        EncryptionConfig(encryptionMode: EncryptionMode.AES128ECB);
    await rtcEngine.enableEncryption(true, config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableEncryption.index,
      jsonEncode({
        'enabled': true,
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('sendCustomReportMessage', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.sendCustomReportMessage(
        '123', 'category', 'event', 'label', 10);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSendCustomReportMessage.index,
      jsonEncode({
        'id': '123',
        'category': 'category',
        'event': 'event',
        'label': 'label',
        'value': 10,
      }),
    );
  });

  testWidgets('setAudioSessionOperationRestriction',
      (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setAudioSessionOperationRestriction(
        AudioSessionOperationRestriction.All);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAudioSessionOperationRestriction.index,
      jsonEncode({
        'restriction': 1 << 7,
      }),
    );
  });

  testWidgets('setAudioEffectParameters', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setAudioEffectParameters(
        AudioEffectPreset.AudioEffectOff, 1, 2);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAudioEffectParameters.index,
      jsonEncode({
        'preset': 0x00000000,
        'param1': 1,
        'param2': 2,
      }),
    );
  });

  testWidgets('setAudioEffectPreset', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setAudioEffectPreset(AudioEffectPreset.PitchCorrection);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetAudioEffectPreset.index,
      jsonEncode({
        'preset': 0x02040100,
      }),
    );
  });

  testWidgets('setVoiceBeautifierPreset', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine
        .setVoiceBeautifierPreset(VoiceBeautifierPreset.SingingBeautifier);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetVoiceBeautifierPreset.index,
      jsonEncode({
        'preset': 0x01020100,
      }),
    );
  });

  testWidgets('createDataStreamWithConfig', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final DataStreamConfig config = DataStreamConfig(true, true);
    await rtcEngine.createDataStreamWithConfig(config);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineCreateDataStream.index,
      jsonEncode({
        'config': config.toJson(),
      }),
    );
  });

  testWidgets('enableDeepLearningDenoise', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableDeepLearningDenoise(true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableDeepLearningDenoise.index,
      jsonEncode({
        'enabled': true,
      }),
    );
  });

  testWidgets('enableRemoteSuperResolution', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.enableRemoteSuperResolution(10, true);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineEnableRemoteSuperResolution.index,
      jsonEncode({
        'uid': 10,
        'enable': true,
      }),
    );
  });

  testWidgets('setCloudProxy', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setCloudProxy(CloudProxyType.TCP);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetCloudProxy.index,
      jsonEncode({
        'proxyType': 2,
      }),
    );
  });

  testWidgets('uploadLogFile', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    nireHandler.mockCallApiResult(
      ApiTypeEngine.kEngineUploadLogFile.index,
      jsonEncode({}),
      '1',
    );

    rtcEngine = await _createEngine();
    final ret = await rtcEngine.uploadLogFile();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineUploadLogFile.index,
      jsonEncode({}),
    );

    expect(ret, '1');
  });

  testWidgets('setVoiceBeautifierParameters', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setVoiceBeautifierParameters(
        VoiceBeautifierPreset.SingingBeautifier, 1, 2);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetVoiceBeautifierParameters.index,
      jsonEncode({
        'preset': 0x01020100,
        'param1': 1,
        'param2': 2,
      }),
    );
  });

  testWidgets('setVoiceConversionPreset', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setVoiceConversionPreset(VoiceConversionPreset.Sweet);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetVoiceConversionPreset.index,
      jsonEncode({
        'preset': 50397696,
      }),
    );
  });

  testWidgets('pauseAllChannelMediaRelay', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.pauseAllChannelMediaRelay();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEnginePauseAllChannelMediaRelay.index,
      jsonEncode({}),
    );
  });

  testWidgets('resumeAllChannelMediaRelay', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.resumeAllChannelMediaRelay();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineResumeAllChannelMediaRelay.index,
      jsonEncode({}),
    );
  });

  testWidgets('setLocalAccessPoint', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setLocalAccessPoint(['127.0.0.1'], 'example.com');

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetLocalAccessPoint.index,
      jsonEncode({
        'ips': ['127.0.0.1'],
        'domain': 'example.com',
      }),
    );
  });

  testWidgets('setScreenCaptureContentHint', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.setScreenCaptureContentHint(VideoContentHint.Motion);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineSetScreenCaptureContentHint.index,
      jsonEncode({
        'contentHint': 1,
      }),
    );
  });

  group('startScreenCaptureByDisplayId', () {
    testWidgets('with `displayId`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.startScreenCaptureByDisplayId(
        10,
      );

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByDisplayId.index,
        jsonEncode({
          'displayId': 10,
          'regionRect': null,
          'captureParams': null,
        }),
      );
    });

    testWidgets('with `displayId`, `regionRect`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final rect = Rectangle(x: 10, y: 10);
      await rtcEngine.startScreenCaptureByDisplayId(10, rect);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByDisplayId.index,
        jsonEncode({
          'displayId': 10,
          'regionRect': rect.toJson(),
          'captureParams': null,
        }),
      );
    });

    testWidgets('with `displayId`, `regionRect`, `captureParams`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final rect = Rectangle(x: 10, y: 10);
      final ScreenCaptureParameters params = ScreenCaptureParameters(
          dimensions: VideoDimensions(width: 10, height: 10));
      await rtcEngine.startScreenCaptureByDisplayId(10, rect, params);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByDisplayId.index,
        jsonEncode({
          'displayId': 10,
          'regionRect': rect.toJson(),
          'captureParams': params.toJson(),
        }),
      );
    });
  });

  group('startScreenCaptureByScreenRect', () {
    testWidgets('with `screenRect`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final rect = Rectangle(x: 10, y: 10);
      final ScreenCaptureParameters params = ScreenCaptureParameters(
          dimensions: VideoDimensions(width: 10, height: 10));
      await rtcEngine.startScreenCaptureByScreenRect(rect);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByScreenRect.index,
        jsonEncode({
          'screenRect': rect.toJson(),
          'regionRect': null,
          'captureParams': null,
        }),
      );
    });

    testWidgets('with `screenRect`, `regionRect`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final screenRect = Rectangle(x: 10, y: 10);
      final regionRect = Rectangle(x: 20, y: 20);

      await rtcEngine.startScreenCaptureByScreenRect(screenRect, regionRect);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByScreenRect.index,
        jsonEncode({
          'screenRect': screenRect.toJson(),
          'regionRect': regionRect.toJson(),
          'captureParams': null,
        }),
      );
    });

    testWidgets('with `screenRect`, `regionRect`, `captureParams`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final screenRect = Rectangle(x: 10, y: 10);
      final regionRect = Rectangle(x: 20, y: 20);
      final ScreenCaptureParameters params = ScreenCaptureParameters(
          dimensions: VideoDimensions(width: 10, height: 10));
      await rtcEngine.startScreenCaptureByScreenRect(
          screenRect, regionRect, params);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByScreenRect.index,
        jsonEncode({
          'screenRect': screenRect.toJson(),
          'regionRect': regionRect.toJson(),
          'captureParams': params.toJson(),
        }),
      );
    });
  });

  group('startScreenCaptureByWindowId', () {
    testWidgets('with `windowId`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final screenRect = Rectangle(x: 10, y: 10);
      final regionRect = Rectangle(x: 20, y: 20);
      final ScreenCaptureParameters params = ScreenCaptureParameters(
          dimensions: VideoDimensions(width: 10, height: 10));
      await rtcEngine.startScreenCaptureByWindowId(10);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByWindowId.index,
        jsonEncode({
          'windowId': 10,
          'regionRect': null,
          'captureParams': null,
        }),
      );
    });

    testWidgets('with `windowId`, `regionRect`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final regionRect = Rectangle(x: 20, y: 20);
      final ScreenCaptureParameters params = ScreenCaptureParameters(
          dimensions: VideoDimensions(width: 10, height: 10));
      await rtcEngine.startScreenCaptureByWindowId(10, regionRect);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByWindowId.index,
        jsonEncode({
          'windowId': 10,
          'regionRect': regionRect.toJson(),
          'captureParams': null,
        }),
      );
    });

    testWidgets('with `windowId`, `regionRect`, `captureParams`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final regionRect = Rectangle(x: 20, y: 20);
      final ScreenCaptureParameters params = ScreenCaptureParameters(
          dimensions: VideoDimensions(width: 10, height: 10));
      await rtcEngine.startScreenCaptureByWindowId(10, regionRect, params);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCaptureByWindowId.index,
        jsonEncode({
          'windowId': 10,
          'regionRect': regionRect.toJson(),
          'captureParams': params.toJson(),
        }),
      );
    });
  });

  testWidgets('stopScreenCapture', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    await rtcEngine.stopScreenCapture();

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineStopScreenCapture.index,
      jsonEncode({}),
    );
  });

  testWidgets('updateScreenCaptureParameters', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final ScreenCaptureParameters params = ScreenCaptureParameters(
        dimensions: VideoDimensions(width: 10, height: 10));
    await rtcEngine.updateScreenCaptureParameters(params);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineUpdateScreenCaptureParameters.index,
      jsonEncode({
        'captureParams': params.toJson(),
      }),
    );
  });

  testWidgets('updateScreenCaptureRegion', (WidgetTester tester) async {
    // app.main();
    // await tester.pumpAndSettle();

    rtcEngine = await _createEngine();
    final Rectangle rect = Rectangle(width: 10, height: 10);
    await rtcEngine.updateScreenCaptureRegion(rect);

    nireHandler.expectCalledApi(
      ApiTypeEngine.kEngineUpdateScreenCaptureRegion.index,
      jsonEncode({
        'regionRect': rect.toJson(),
      }),
    );
  });

  group('startScreenCapture', () {
    testWidgets('with `windowId`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.startScreenCapture(10);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCapture.index,
        jsonEncode({
          'windowId': 10,
          'captureFreq': null,
          'rect': null,
          'bitrate': null,
        }),
      );
    });

    testWidgets('with `windowId`, `captureFreq`', (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      await rtcEngine.startScreenCapture(10, 20);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCapture.index,
        jsonEncode({
          'windowId': 10,
          'captureFreq': 20,
          'rect': null,
          'bitrate': null,
        }),
      );
    });

    testWidgets('with `windowId`, `captureFreq`, `rect`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final rect = Rect(left: 10, right: 10);
      await rtcEngine.startScreenCapture(10, 20, rect);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCapture.index,
        jsonEncode({
          'windowId': 10,
          'captureFreq': 20,
          'rect': rect.toJson(),
          'bitrate': null,
        }),
      );
    });

    testWidgets('with `windowId`, `captureFreq`, `rect`, `bitrate`',
        (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();

      rtcEngine = await _createEngine();
      final rect = Rect(left: 10, right: 10);
      await rtcEngine.startScreenCapture(10, 20, rect, 30);

      nireHandler.expectCalledApi(
        ApiTypeEngine.kEngineStartScreenCapture.index,
        jsonEncode({
          'windowId': 10,
          'captureFreq': 20,
          'rect': rect.toJson(),
          'bitrate': 30,
        }),
      );
    });
  });
}

Future<RtcEngine> _createEngine() async {
  return RtcEngine.create('123');
}
