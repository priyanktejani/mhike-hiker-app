import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/hike.dart';
import 'package:mhike/services/crud/model/picture.dart';
import 'package:mhike/utilities/utility.dart';

class PictureTab extends StatefulWidget {
  final Hike hike;
  const PictureTab({super.key, required this.hike});

  @override
  State<PictureTab> createState() => _PictureTabState();
}

class _PictureTabState extends State<PictureTab> {
  late final MHikeService _mHikeService;

  @override
  void initState() {
    _mHikeService = MHikeService();
    super.initState();
  }

  Future addNewPicture() async {
    
    final dateTime = DateTime.now();

    // pick image from gallery
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
      // convert image to string
      String hikePicture = Utility.base64String(await imgFile!.readAsBytes());

      // create a new object
      Picture newPicture = Picture(
        hikeId: widget.hike.id!,
        hikePicture: hikePicture,
        dateTime: dateTime,
      );

      // insert image
      _mHikeService.addPicture(
        hike: widget.hike,
        newPicture: newPicture,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder(
        stream: _mHikeService.allPictures,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allPictures = snapshot.data as List<Picture>;
                final hikePictures = allPictures
                    .where((pictures) => pictures.hikeId == widget.hike.id)
                    .toList();
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: hikePictures.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 55, 59, 87),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Image.asset(
                            'assets/icons/add-image.png',
                            color: Colors.white12,
                          ),
                        ),
                        onTap: () {
                          addNewPicture();
                        },
                      );
                    }
                    final picture = hikePictures[index - 1];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.memory(
                        Utility.dataFromBase64String(picture.hikePicture),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
