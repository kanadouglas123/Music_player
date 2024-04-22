import 'package:beats/controllers/player_controller.dart';
import 'package:beats/views/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 4.0,
        shadowColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _ShowSeachBox(context);
            },
            icon: const Icon(Icons.search, color: Colors.white, size: 35),
          )
        ],
        leading: IconButton(
          onPressed: () {
            _Menu();
            
          },
          icon: const Icon(
            Icons.sort_rounded,
            color: Colors.black,
            size: 35,
          ),
        ),
        title: const Text(
          "beats",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No songs found"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(parent: ScrollPhysics()  
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  SongModel song = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 2.4,
                        color: Colors.blueGrey,
                        shadowColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: Obx(() => 
                           ListTile(
                            title: Text(
                              song.title,
                              style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              song.artist ?? "Unknown Artist",
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:Colors.blueGrey,
                              radius: 25,
                              child: QueryArtworkWidget(id: snapshot.data![index].id, type: ArtworkType.AUDIO,
                              nullArtworkWidget: Image.asset("assets/music.png"),
                              
                              ),
                            ),
                            trailing: controller.playIndex.value==index && controller.isPlaying.value
                            ?IconButton(
                              onPressed: () {
                              },icon: const Icon(Icons.play_arrow, color: Colors.orange, size: 30))

                              :null,
                              onTap: () {
                              Get.to(()=>Player(data: snapshot.data!));
                               controller.playSong(snapshot.data![index].uri!,index);
                            },
                            ),

                            
                          ),
                        ),
                      ),
                    );
                  
                },
              ),
            );
          }
        },
      ),
    );
  }
  
  void _ShowSeachBox(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return  AlertDialog(
        title:  const Text("Search music"),
        content: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white
          ),
          child: const Padding(
            padding:  EdgeInsets.only(left: 10,right: 5,bottom: 5),
            child: TextField(
              decoration: InputDecoration(hintText: "enter your music", border: InputBorder.none),
            ),
          )),
        actions: [
          SingleChildScrollView(
            child: Row(
              children: [
                TextButton(onPressed: () {}, child: const Text("search")),
                const SizedBox(width: 80,),
                 TextButton(onPressed: () {
                  Navigator.pop(context);
                 }, child: const Text("cancel"))
              ],
            ),
          )
        ],
      );
      
    });
  }
  
  void _Menu() {
    return ; 
  }
  
}
