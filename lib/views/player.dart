import 'package:beats/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller=Get.find<PlayerController>();
      return Scaffold(
      backgroundColor: Colors.blueGrey,
      body:  Obx(() => 
         SafeArea(
          child: Container(
              color: Colors.blueGrey,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_downward, size: 30),
                      ),
                      const SizedBox(width: 220),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.equalizer_sharp, size: 30),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.list_rounded, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CircleAvatar(
                    foregroundColor: Colors.black26,
                    backgroundColor: Colors.blueGrey,
                    radius: 120,
                    child: QueryArtworkWidget(
                      id: data[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: Image.asset("assets/music.png"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        width: 400,
                        child: SingleChildScrollView(
                          child: Obx(() => 
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data[controller.playIndex.value].title,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(color: Colors.black, fontSize: 17 ,),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  data[controller.playIndex.value].artist ?? "Unknown Artist",
                                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                const SizedBox(height: 29),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(() =>  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                       Text(
                                          "0:00"
                                          , style: const TextStyle(fontSize: 15)),
                                        Expanded(
                                          child: Slider(                                           
                                            thumbColor: Colors.amber,
                                            activeColor: Colors.white,
                                            value:controller.value.value,
                                            min:const Duration(seconds: 0).inSeconds.toDouble(),
                                             max: controller.max.value,
                                            onChanged: (newValue){
                                              controller.changeDurationToSeconds(newValue.toInt());
                                              newValue=newValue;
                                            },
                                          ),
                                        ),
                                        Text(controller.position.value, style: const TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(onPressed: () {}, icon: const Icon(Icons.repeat), iconSize: 36.0,),
                                    const SizedBox(width: 15,),
                                    IconButton(
                                      icon:  const Icon(Icons.skip_previous),
                                      iconSize: 36.0,
                                      onPressed: () {
                                        controller.playSong(data[controller.playIndex.value-1].uri,controller.playIndex.value-1);
                                      },
                                    ),
                                    const SizedBox(width: 15,),
                                    Obx(() => 
                                       CircleAvatar(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white24,
                                        radius: 32,
                                        child: IconButton(
                                          icon:controller.isPlaying.value?  Icon(Icons.pause):Icon(Icons.play_arrow),
                                          iconSize: 50.0,
                                          onPressed: () {
                                            if(controller.isPlaying.value){
                                              controller.audioplayer.pause();
                                              controller.isPlaying(false);
                                            }else{
                                      
                                              controller.audioplayer.play();
                                              controller.isPlaying(true);
                                      
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15,),
                                    IconButton(
                                      icon: const Icon(Icons.skip_next),
                                      iconSize: 36.0,
                                      onPressed: () {
                                        if(controller.position.value==controller.duration.value){
                                          controller.playIndex.value+1;
                                        }
                                        controller.playSong(data[controller.playIndex.value+1].uri, controller.playIndex.value+1);
                                      },
                                    ),
                                    const SizedBox(width: 15,),
                                    IconButton(onPressed: () {}, icon: const Icon(Icons.favorite), iconSize: 36.0,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
