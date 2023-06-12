import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'auth_methods.dart';
import 'firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      Map<FeatureFlag, Object> featureFlags = {
        FeatureFlag.isWelcomePageEnabled: false,
        FeatureFlag.isNotificationsEnabled: false,
      };
      // featureFlag.welcomePageEnabled = false;
      // featureFlag.resolution = FeatureFlagVideoResolution
      //     .MD_RESOLUTION; // Limit video resolution to 360p
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }
      // var options = JitsiMeetingOptions(room: roomName)
      //   ..userDisplayName = name
      //   ..userEmail = _authMethods.user.email
      //   ..userAvatarURL = _authMethods.user.photoURL
      //   ..audioMuted = isAudioMuted
      //   ..videoMuted = isVideoMuted;

      var options = JitsiMeetingOptions(
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        userDisplayName: name,
        userEmail: _authMethods.user.email,
        featureFlags: featureFlags,
        roomNameOrUrl: roomName,
      );

      _firestoreMethods.addToMeetingHistory(roomName);
      await JitsiMeetWrapper.joinMeeting(options: options);
    } catch (error) {
      print("error: $error");
    }
  }
}
