import 'package:bng_optica_beta/screens/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/stores_service.dart';
import '../../widgets/drawer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StoreService _storeService = StoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.sort,
            size: 30,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: FutureBuilder(
        future: _storeService.fetchAllStores(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Loading ', style: TextStyle(fontFamily: 'Abel')),
                  GFLoader(type: GFLoaderType.circle),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 0.0,
                ),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Hero(
                          tag: snapshot.data[index].name,
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  StoreDetailScreen(storeId: snapshot.data[index].id),
                                );
                              },
                              child: SizedBox(
                                height: 300, // Adjust the height as needed for aspect ratio
                                width: 350,
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image(
                                        image: snapshot.data[index].imagepath != null
                                            ? NetworkImage(snapshot.data[index].imagepath)
                                            : const NetworkImage('url'),
                                        fit: BoxFit.fill, // Adjust the BoxFit
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                      ),
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: GoogleFonts.abel(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),



                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(60.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/empty.png",
                      ),
                      const Text("There is no elements", style: TextStyle(fontFamily: 'Abel')),
                      const Text("You can add by tapping the '+' sign", style: TextStyle(fontFamily: 'Abel')),
                    ],
                  ),
                ),
              );
            }
          } else {
            return const Text('NO DATA');
          }
        },
      ),
    );
  }
}
