import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/pages/add_hike_page.dart';
import 'package:mhike/pages/home/hike_list_view.dart';
import 'package:mhike/services/auth/auth_service.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/hike.dart';
import 'package:mhike/services/crud/model/user.dart';
import 'package:mhike/utilities/utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MHikeService _mHikeService;
  String get email => AuthService.firebase().currentUser!.email;
  late Iterable<Hike> hikes;

  int allHikesCount = 3;
  int popularHikesCount = 3;

  final PageController pageController = PageController(viewportFraction: 0.86);
  int currentPage = 0;
  double height = 435.0;

  @override
  void initState() {
    _mHikeService = MHikeService();
    pageController.addListener(() {
      int position = pageController.page!.round();
      if (currentPage != position) {
        {
          setState(() {
            currentPage = position;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282b41),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 90,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: (() {
              Scaffold.of(context).openDrawer();
            }),
            icon: Image.asset(
              'assets/menu.png',
              color: Colors.white,
              width: 21,
            ),
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            // search icon
            child: IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed(
                  searchRoute,
                );
              }),
              icon: Image.asset(
                'assets/search.png',
                color: Colors.white,
                width: 21,
              ),
            ),
          ),
        ],
      ),
      // app drawer
      drawer: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(50)),
        child: Drawer(
          backgroundColor: const Color.fromARGB(255, 55, 59, 87),
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xff282b41),
                ),
                child: Center(
                  child: Text(
                    'mhike',
                    style: GoogleFonts.dancingScript(
                      fontSize: 82.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: FutureBuilder(
                      future: _mHikeService.getUser(null, email),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              final user = snapshot.data as User;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 28,
                                    backgroundImage:
                                        AssetImage('assets/images/pexels3.jpg'),
                                  ),
                                  const VerticalDivider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '@${user.username}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const Text('User Not Found');
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      }),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Image.asset(
                  'assets/images/add-item.png',
                  color: Colors.white,
                  height: 29,
                ),
                title: const Text(
                  'Add New Hike',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddHikePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/logout.png',
                  color: Colors.white,
                  height: 26,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final logout = await logOutDialog(context);
                  if (logout) {
                    await AuthService.firebase().logout();
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/reset.png',
                  color: Colors.white,
                  height: 26,
                ),
                title: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  // clear database
                  _mHikeService.deleteAllHikes();
                  _mHikeService.deleteAllComments();
                  _mHikeService.deleteAllPictures();
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/option.png',
                          color: Colors.white,
                          width: 24,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 26),
                          backgroundColor: Colors.red,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Hikes'),
                      ),
                      const VerticalDivider(
                        width: 10,
                      ),
                      Text(
                        '$popularHikesCount Hikes',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 400,
                child: StreamBuilder(
                  stream: _mHikeService.allHikes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:

                        // get popular hike
                        if (snapshot.hasData) {
                          final allHikes = snapshot.data as List<Hike>;
                          final popularHikes = allHikes
                              .where(
                                (hike) => hike.popularityIndex! < 10,
                              )
                              .toList();

                          return PageView.builder(
                            padEnds: false,
                            controller: pageController,
                            itemCount: allHikes.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              bool active = index == currentPage;
                              return HikesCard(
                                active: active,
                                index: index,
                                hike: popularHikes[index],
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 26,
                right: 26,
                top: 18,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Hikes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/option.png',
                          color: Colors.white,
                          width: 24,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 26),
                          backgroundColor: Colors.pink,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Least recent'),
                      ),
                      const VerticalDivider(
                        width: 10,
                      ),
                      Text(
                        '$allHikesCount+ Hikes',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: _mHikeService.allHikes,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allHikes = snapshot.data as List<Hike>;
                      return HikeListView(
                        hikes: allHikes,
                        onDeleteHike: (hike) async {
                          await _mHikeService.deleteHike(id: hike.id!);
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HikesCard extends StatelessWidget {
  const HikesCard({
    Key? key,
    required this.active,
    required this.index,
    required this.hike,
  }) : super(key: key);

  final bool active;
  final int index;
  final Hike hike;

  @override
  Widget build(BuildContext context) {
    final double blur = active ? 16 : 0;
    final double offset = active ? 4 : 0;
    final double top = active ? 0 : 34;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: top,
        bottom: 0,
        right: 15.5,
        left: active ? 24.0 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color(0xFF424242),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: blur,
            offset: Offset(0, offset),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(Utility.dataFromBase64String(hike.coverImage)),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF424242).withOpacity(0.8),
                  const Color(0xFF616161).withOpacity(0.2),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                tileMode: TileMode.clamp,
                stops: const [0.3, 0.6],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 16,
                top: 10,
              ),
              height: 87,
              decoration: const BoxDecoration(
                color: Color(0xFF424242),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Text(
                hike.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 84.75,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.5,
                    ),
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: hike.difficultyLevel,
                            style: const TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            children: const [
                              TextSpan(
                                text: ' • ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: '4.5 (12)'),
                            ],
                          ),
                        ),
                        const VerticalDivider(
                          width: 4,
                        ),
                        Image.asset(
                          'assets/star.png',
                          height: 14,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// logout dialog box
Future<bool> logOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xff282b41),
        title: const Text('Logout'),
        content: const Text('do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancle'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
