import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhike/gigs.dart';
import 'package:mhike/pages/add_hike_page.dart';
import 'package:mhike/pages/trail_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController(viewportFraction: 0.86);
  int currentPage = 0;
  double height = 435.0;

  @override
  void initState() {
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
            child: IconButton(
              onPressed: (() {}),
              icon: Image.asset(
                'assets/search.png',
                color: Colors.white,
                width: 21,
              ),
            ),
          ),
        ],
      ),
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
                    'MHike',
                    style: GoogleFonts.dancingScript(
                      fontSize: 70.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white12,
                    ),
                  ),
                ),
              ),
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
                        builder: (context) => const AddHikePage()),
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
                onTap: () {
                  Navigator.pop(context);
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
                        child: const Text('Animated'),
                      ),
                      const VerticalDivider(
                        width: 10,
                      ),
                      const Text(
                        '12+ Trails',
                        style: TextStyle(
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
                child: PageView.builder(
                  padEnds: false,
                  controller: pageController,
                  itemCount: gigs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    bool active = index == currentPage;
                    return GigsCard(
                      active: active,
                      index: index,
                      gigs: gigs[index],
                    );
                  },
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   child: AnimatedBuilder(
            //     animation: _animationController,
            //     builder: (context, child) {
            //       final selectionValue = _animationController.value;
            //       return GestureDetector(
            //         onTap: () {
            //           if (!_selectMode) {
            //             _animationController.forward().whenComplete(() {
            //               setState(() {
            //                 height = 700;
            //                 _selectMode = true;
            //               });
            //             });
            //           } else {
            //             _animationController.reverse().whenComplete(() {
            //               setState(() {
            //                 height = 435;
            //                 _selectMode = false;
            //               });
            //             });
            //           }
            //         },
            //         child: Transform(
            //           alignment: Alignment.center,
            //           transform: Matrix4.identity()
            //             ..setEntry(3, 2, 0.001)
            //             ..rotateX(0.15),
            //           child: AbsorbPointer(
            //             absorbing: !_selectMode,
            //             child: Container(
            //               height: height,
            //               width: 400,
            //               // color: Colors.red,
            //               child: Stack(
            //                 children: List.generate(
            //                   4,
            //                   (index) => Card3dItem(
            //                     height: 500 / 2,
            //                     card: cardList[index],
            //                     percent: selectionValue,
            //                     depth: index,
            //                   ),
            //                 ).reversed.toList(),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Trails',
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
                        child: const Text('Animated'),
                      ),
                      const VerticalDivider(
                        width: 10,
                      ),
                      const Text(
                        '50+ Trails',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section 2

            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Stack(
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ServiceDetailPage()),
                      );
                    }),
                    child: PhysicalModel(
                      color: Colors.white,
                      elevation: 10,
                      borderRadius: BorderRadius.circular(15.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          'https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_1280.jpg',
                          height: 290,
                          width: 290,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kilburn to Brent Reservoir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Length: 3.5km • Est. 47m',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: 'Moderate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' • ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: '4.0 (5)'),
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
                        const Divider(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(110, 26),
                            backgroundColor: Colors.indigo.shade800,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Read more'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GigsCard extends StatelessWidget {
  const GigsCard({Key? key, this.active, this.index, this.gigs})
      : super(key: key);

  final bool? active;
  final int? index;
  final Gigs? gigs;

  @override
  Widget build(BuildContext context) {
    final double blur = active! ? 16 : 0;
    final double offset = active! ? 4 : 0;
    final double top = active! ? 0 : 34;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: top,
        bottom: 0,
        right: 15.5,
        left: active! ? 24.0 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: gigs!.startColor!,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: blur,
            offset: Offset(0, offset),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/${gigs!.recipeImage}'),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  gigs!.startColor!.withOpacity(0.8),
                  gigs!.endColor!.withOpacity(0.2),
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
              decoration: BoxDecoration(
                color: gigs!.startColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Text(
                gigs!.recipeName,
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
                      vertical: 5,
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
                            text: 'Moderate',
                            style: TextStyle(
                              color: gigs!.startColor,
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
                              TextSpan(text: '4.0 (5)'),
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
                  Row(
                    children: const [
                      // Image.asset('assets/icons/messenger.png'),
                      SizedBox(
                        width: 8.65,
                      ),
                      // Image.asset('assets/icons/messenger.png'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
