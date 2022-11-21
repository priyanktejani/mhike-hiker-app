import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mhike/pages/tabs/comment_tab.dart';
import 'package:mhike/pages/tabs/image_tab.dart';
import 'package:mhike/pages/tabs/observation_tab.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({super.key});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282b41),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xff282b41),
            expandedHeight: 392,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Image.asset(
                  'assets/images/pexels6.jpeg',
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
                          vertical: 5,
                        ),
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Moderate',
                          style: TextStyle(
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
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 18,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Color(0xFFF4C465),
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
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
                  const Text(
                    'Big ban low angle, Great bell of the Great Clock',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
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
                    const Text(
                      'The Palace of Westminster was destroyed by fire in 1834. In 1844, it was decided the new buildings for the Houses of Parliament should include a tower and a clock. A massive bell was required and the first attempt (made by John Warner & Sons at Stockton-on-Tees) cracked irreparably. The metal was melted down and the bell recast in Whitechapel in 1858. Big Ben first rang across Westminster on 31 May 1859. A short time later, in September 1859, Big Ben cracked. A lighter hammer was fitted and the bell rotated to present an undamaged section to the hammer. This is the bell as we hear it today.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Length',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '10.9 km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Estimated time',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '1h 7m',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Popularity count',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '50+',
                              style: TextStyle(
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                children: const [
                  ObservationTab(),
                  CommentTab(),
                  ImageTab(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
