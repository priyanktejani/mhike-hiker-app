import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mhike/constants/routes.dart';
import 'package:mhike/enums/menu_actions.dart';
import 'package:mhike/pages/hike_detail/tabs/comment_tab.dart';
import 'package:mhike/pages/hike_detail/tabs/picture_tab.dart';
import 'package:mhike/pages/hike_detail/tabs/observation_tab.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/hike.dart';
import 'package:mhike/services/crud/model/observation.dart';
import 'package:mhike/utilities/generics/get_arguments.dart';
import 'package:mhike/utilities/utility.dart';

class HikeDetailPage extends StatefulWidget {
  const HikeDetailPage({super.key});

  @override
  State<HikeDetailPage> createState() => _HikeDetailPageState();
}

class _HikeDetailPageState extends State<HikeDetailPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  late final MHikeService _mHikeService;
  late Hike _hike;

  late Iterable<Observation> observations;
  bool isLoding = false;

  @override
  void initState() {
    super.initState();
    _mHikeService = MHikeService();
    tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<Hike?> getHikeDetail(BuildContext context) async {
    final widgetHike = context.getArgument<Hike>();

    if (widgetHike != null) {
      _hike = widgetHike;
      return widgetHike;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282b41),
      body: FutureBuilder(
          future: getHikeDetail(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: const Color(0xff282b41),
                        expandedHeight: 392,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: PopupMenuButton(
                              // Callback for selected popup menu item.
                              onSelected: (HikeMenu item) {
                                // update hike
                                if (item == HikeMenu.update) {
                                  Navigator.of(context).pushNamed(
                                    addHikeRoute,
                                    arguments: _hike,
                                  );
                                } else {
                                  // delete hike
                                  _mHikeService.deleteHike(id: _hike.id!);
                                  Navigator.pop(context);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<HikeMenu>>[
                                const PopupMenuItem<HikeMenu>(
                                  value: HikeMenu.update,
                                  child: Text('Update'),
                                ),
                                const PopupMenuItem<HikeMenu>(
                                  value: HikeMenu.delete,
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                            child: Image.memory(
                              Utility.dataFromBase64String(_hike.coverImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 22, right: 20, bottom: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.5,
                                      vertical: 3,
                                    ),
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      _hike.difficultyLevel,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 6,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 18,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color(0xFFF4C465),
                                    ),
                                    onRatingUpdate: (rating) {
                                    },
                                  ),
                                  const VerticalDivider(
                                    width: 4,
                                  ),
                                  const Text(
                                    '(5)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Text(
                                _hike.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 9),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 55, 59, 87),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  _hike.description != null
                                      ? _hike.description!
                                      : 'Description not provided',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Length',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          _hike.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Estimated time',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          _hike.estimatedTime,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Parking availability',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          _hike.parkingAvailability == true? 'Yes' : 'No',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 2nd section for map
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              'https://i0.wp.com/www.cssscript.com/wp-content/uploads/2018/03/Simple-Location-Picker.png?fit=561%2C421&ssl=1',
                              height: 290,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.grey.shade600,
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 55, 59, 87),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TabBar(
                                  controller: tabController,
                                  indicatorColor: Colors.transparent,
                                  padding: const EdgeInsets.only(top: 14),
                                  tabs: [
                                    Tab(
                                      icon: tabController.index == 0
                                          ? Image.asset(
                                              'assets/images/list-2.png',
                                              color: Colors.white,
                                              height: 23,
                                            )
                                          : Image.asset(
                                              'assets/images/list.png',
                                              color: Colors.white,
                                              height: 23,
                                            ),
                                    ),
                                    Tab(
                                      icon: tabController.index == 1
                                          ? Image.asset(
                                              'assets/images/message-3.png',
                                              color: Colors.white,
                                              height: 24,
                                            )
                                          : Image.asset(
                                              'assets/images/message-2.png',
                                              color: Colors.white,
                                              height: 24,
                                            ),
                                    ),
                                    Tab(
                                      icon: tabController.index == 2
                                          ? Image.asset(
                                              'assets/images/image.png',
                                              color: Colors.white,
                                              height: 23,
                                            )
                                          : Image.asset(
                                              'assets/images/image-2.png',
                                              color: Colors.white,
                                              height: 23,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      SliverFillRemaining(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              ObservationTab(hike: _hike),
                              CommentTab(hike: _hike),
                              PictureTab(hike: _hike),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(child: Text('No Data'));
                }
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
