import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/services.dart';

class MediaBottomSheet extends StatefulWidget {
  const MediaBottomSheet({super.key, required this.onSelect});
  final Function(PlatformFile) onSelect;

  @override
  State<MediaBottomSheet> createState() => _MediaBottomSheetState();
}

class _MediaBottomSheetState extends State<MediaBottomSheet> {
  List<AssetEntity> assets = [];

  Future<void> fetchMedia() async {
    final PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      print("Доступ до медіафайлів надано");
    } else if (status.isDenied) {
      print("Доступ до медіафайлів відхилено");
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image | RequestType.video,
    );

    List<AssetEntity> allAssets = [];

    for (var album in albums) {
      final List<AssetEntity> albumAssets = await album.getAssetListPaged(page: 0, size: 100);
      allAssets.addAll(albumAssets);
    }

    setState(() {
      assets = allAssets.toSet().toList();
    });
  }

  Future<PlatformFile> convertToPlatformFile(AssetEntity asset) async {
    final file = await asset.file; // Отримуємо фізичний файл
    return PlatformFile(
      path: file?.path ?? '', // Шлях до файлу
      name: asset.title!, // Назва файлу
      size: file?.lengthSync() ?? 0, // Розмір файлу
    );
  }



  @override
  void initState() {
    super.initState();
    fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 500,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                ),
                itemCount: assets.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      child: Container(
                        color: thirdColor.withOpacity(0.6),
                        child: Icon(Icons.camera, color: primaryColor, size: 40,),
                      ),
                    );
                  } else {
                    final asset = assets[index - 1];
                    return GestureDetector(
                      onTap: () async{
                        final platformFile = await convertToPlatformFile(asset);
                        widget.onSelect(platformFile);
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.blueAccent,
                        child: FutureBuilder<Uint8List?>(
                          future: asset.thumbnailData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Icon(Icons.image_not_supported, color: Colors.white);
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
