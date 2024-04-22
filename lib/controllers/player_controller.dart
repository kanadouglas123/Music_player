import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioplayer= AudioPlayer();
  var playIndex=0.obs;
  var isPlaying=false.obs;
  var duration="".obs;
  var position="".obs; 
  var max=0.0.obs;
  var value=0.0.obs;
//premission method
  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }
  updatePosition(){
    audioplayer.durationStream.listen((d) {
      duration.value=d.toString().split(".")[0]; 
      max.value=d!.inSeconds.toDouble();
    });
    audioplayer.durationStream.listen((p) {
      position.value=p.toString().split(".")[0];
      position.value=p!.inSeconds.toDouble() as String;
     });

  }
  changeDurationToSeconds(seconds){
    var duration=Duration(seconds:seconds);
    audioplayer.seek(duration);
  }
  //playing song method
  playSong(String? uri, index){
    playIndex.value=index;
    audioplayer.setAudioSource(
      AudioSource.uri(Uri.parse(uri!))
    );
    audioplayer.play();
    isPlaying(true);
    updatePosition();
  }

  void checkPermission() async {
    var perm = await Permission.storage.request();

    if (perm.isGranted) {
      // Permission granted
    } else if (perm.isDenied) {
      // Permission denied
    } else if (perm.isPermanentlyDenied) {
      // Permission permanently denied
    } else {
      // Permission request returned unknown status, ha ndle accordingly
    }
  }
}
