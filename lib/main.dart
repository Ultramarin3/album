import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageDetails {
  final File imagePath;
  final int width;
  final int height;
  ImageDetails({
    required this.imagePath,
    required this.width,
    required this.height,
  });
}

List<ImageDetails> _images = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

enum ImageSourceType { gallery, camera }

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)))
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ALbum 571"),
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                imagepath: _images[index].imagePath,
                                width: _images[index].width,
                                height: _images[index].height,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                //image: AssetImage(_images[index].imagePath),
                                image: FileImage(_images[index].imagePath),
                                fit: BoxFit.cover,
                              )),
                        ),
                      );
                    },
                    itemCount: _images.length,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      child: const Text(
                        "Add from Gallery",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _handleURLButtonPress(context, ImageSourceType.gallery);
                      },
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      child: const Text(
                        "Use Camera",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _handleURLButtonPress(context, ImageSourceType.camera);
                      },
                    ),
                  ],
                ),
              ],
            )));
  }
}

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                var pickedImage = await imagePicker.pickImage(
                    source: source,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.rear);
                if (pickedImage != null) {
                  XFile image = pickedImage;
                  setState(() {
                    _image = File(image.path);
                  });
                  var decodedImage =
                      await decodeImageFromList(_image.readAsBytesSync());
                  _images.add(ImageDetails(
                      imagePath: _image,
                      width: decodedImage.width,
                      height: decodedImage.height));
                }
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                        _image,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.red[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final File imagepath;
  final int width;
  final int height;
  final int index;
  DetailPage({
    required this.imagepath,
    required this.width,
    required this.height,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Full Screen Image"),
        ),
        body: SafeArea(
            bottom: false,
            //minimum: const EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.file(
                        imagepath,
                        alignment: Alignment.center,
                      ),
                      Text("image width: $width"),
                      Text("image height: $height"),
                    ],
                  ),
                ),
              )
            ])));
  }
}
