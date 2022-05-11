import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:req_fun/req_fun.dart';

class AppProfileImage extends StatefulWidget {
   String title;
   String? imageTag;
   double width;
   double height;
   double radius;
   double iconHeight;
   double iconWidth;
   double progressSize;
   File? imageFile;
   String? defaultImageAssets;
   String? imageAssets;
   String? imageUrl;
   bool imagePicker;
   bool miniFab;

   bool addDocument;

   Function(File, String)? onImageSelected;
   Function(String)? onNetworkImageClick;

   AppProfileImage({
    Key? key,
    required this.title,
    this.imageTag,
    this.width = 165.0,
    this.height = 165.0,
    this.radius = 165.0,
    this.progressSize = 65.0,
    this.imageFile,
    this.defaultImageAssets,
    this.imageAssets,
    this.imageUrl,
    this.imagePicker = false,
    this.miniFab = false,
    this.onImageSelected,
    this.onNetworkImageClick,
    this.iconHeight = 35.0,
    this.iconWidth = 35.0,
    this.addDocument = true,
    required int counter,
  }) : super(key: key);

  @override
  _AppProfileImageState createState() => _AppProfileImageState();
}

class _AppProfileImageState extends State<AppProfileImage> {
  File? _selectedImage;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedImage = widget.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width + 25,
      height: widget.height + 25,
      child: Stack(
        children: [
          if (widget.addDocument) ...[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 9.9,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.fill,
                          width: widget.width,
                          height: widget.height,
                        )
                      : widget.imageUrl != null &&
                              (widget.imageUrl ?? "").isNotEmpty
                          ? Hero(
                              tag: widget.imageTag ?? widget.title,
                              transitionOnUserGestures: true,
                              child: Image.network(
                                  "http://dubai.applypressure.co.uk/profile_pics/${widget.imageUrl}")
                              /*CachedNetworkImage(
                                fit: BoxFit.fill,
                                key: UniqueKey(),
                                imageUrl:
                                    'http://dubai.applypressure.co.uk/profile_pics/${widget.imageUrl!}',
                                imageBuilder: (ctx, imageProvider) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.onNetworkImageClick != null) {
                                        widget.onNetworkImageClick!(
                                            widget.imageUrl!);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: widget.progressSize,
                                    height: widget.progressSize,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  widget.imageAssets ?? AppImages.userIcon,
                                  fit: BoxFit.cover,
                                ),
                              ),*/
                            )
                          : Image.asset(widget.imageAssets ??
                              widget.defaultImageAssets ??
                              AppImages.userIcon),
                ),
              ),
            ),
          ],
          if (widget.imagePicker)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: widget.iconHeight,
                  width: widget.iconWidth,
                  // padding: const EdgeInsets.only(left: 22.0),
                  child: FloatingActionButton(
                    mini: widget.miniFab,
                    heroTag: _heroTag(),
                    onPressed: () {
                      _selectImageFrom();
                    },
                    child: Icon(Icons.camera_enhance),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _heroTag() {
    var fabTag = widget.miniFab ? "MiniFab - " : "Fab - ";
    if (widget.imageTag != null) {
      return fabTag + widget.imageTag!;
    } else
      return fabTag + widget.title;
  }

  _selectImageFrom() {
    var selectImageOption = CupertinoActionSheet(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 20.0),
      ),
      message: Text("Select image from"),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Gallery"),
          isDefaultAction: true,
          onPressed: () {
            pop();
            _getImage(ImageSource.gallery);
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Camera"),
          onPressed: () {
            pop();
            _getImage(ImageSource.camera);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        isDestructiveAction: true,
        onPressed: () {
          pop();
        },
      ),
    );

    showCupertinoModalPopup(
        context: context, builder: (_) => selectImageOption);
  }

  _getImage([source = ImageSource.gallery]) async {
    try {
      final ImagePicker picker = ImagePicker();
      var image = await picker.getImage(
        source: source,
      );

      if (image != null) {
        _cropImage(File(image.path));
      } else {
        errorDialog(
            context, "Failed", "Unable to get the image, Please try again...");
      }
    } on PlatformException catch (e, s) {
      errorDialog(context, "Failed", "${e.message}");
    } on Exception catch (e, s) {
      errorDialog(context, "Failed", "${e.toString()}");
    } on Error catch (e, s) {
      errorDialog(context, "Failed", "${e.toString()}");
    } catch (e, s) {
      errorDialog(context, "Failed", "${e.toString()}");
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      maxWidth: 512,
      maxHeight: 512,
      cropStyle: (widget.addDocument == false)
          ? CropStyle.rectangle
          : CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = croppedFile;
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(
            croppedFile, base64Encode(croppedFile.readAsBytesSync()));
      }
    }
  }
}
