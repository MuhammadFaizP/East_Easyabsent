import 'dart:io';
import 'package:absensi_flutter/page/absen/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../user_page.dart';

class AbsenPage extends StatefulWidget {
  final XFile? image;

  const AbsenPage({super.key, this.image});

  @override
  State<AbsenPage> createState() => _AbsenPageState(this.image);
}

class _AbsenPageState extends State<AbsenPage> {
  _AbsenPageState(this.image);

  XFile? image;
  String strAlamat = "", strDate = "", strTime = "", strDateTime = "", strStatus = "Absen Masuk";
  bool isLoading = false;
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;
  final controllerName = TextEditingController();
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('absensi');

  @override
  void initState() {
    handleLocationPermission();
    setDateTime();
    setStatusAbsen();

    if (image != null) {
      isLoading = true;
      getGeoLocationPosition();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 84, 152),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Menu Absensi",
          style: TextStyle(fontFamily: 'Mont', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Color.fromARGB(255, 0, 84, 152),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      Icon(Icons.face_retouching_natural_outlined, color: Colors.white),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Absen Foto Selfie ya!",
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                  child: Text(
                    "Ambil Foto",
                    style: TextStyle(
                      fontFamily: 'Mont',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 140, 140, 140)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CameraAbsenPage()));
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    width: size.width,
                    height: 150,
                    child: DottedBorder(
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        color: Color.fromARGB(255, 0, 84, 152),
                        strokeWidth: 1,
                        dashPattern: const [5, 5],
                        child: SizedBox.expand(
                          child: FittedBox(
                            child: image != null
                                ? Image.file(File(image!.path), fit: BoxFit.cover)
                                : const Icon(
                                    Icons.camera_enhance_outlined,
                                    color: Color.fromARGB(255, 0, 84, 152),
                            ),
                          ),
                        ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: controllerName,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        labelText: "Masukan Nama Anda",
                        hintText: "Nama Anda",
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey),
                        labelStyle: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 140, 140, 140)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 84, 152)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 84, 152)),
                        ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    "Lokasi Anda",
                    style: TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 140, 140, 140)),
                  ),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 84, 152),))
                    : Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 5 * 24,
                        child: TextField(
                          enabled: false,
                          maxLines: 5,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 84, 152)),
                            ),
                            hintText: strAlamat ?? (strAlamat = 'Lokasi Kamu'),
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(30),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 0, 84, 152),
                          child: InkWell(
                            splashColor: Color.fromARGB(255, 0, 84, 152),
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (image == null || controllerName.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text("Maaf, foto dan inputan tidak boleh kosong!",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              } else {
                                submitAbsen(strAlamat, controllerName.text.toString(), strStatus);
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Absen Sekarang",
                                style: TextStyle(fontFamily: 'Mont', color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  //get realtime location
  Future<void> getGeoLocationPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      isLoading = false;
      getAddressFromLongLat(position);
    });
  }

  //get address by lat long
  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      dLat = double.parse('${position.latitude}');
      dLat = double.parse('${position.longitude}');
      strAlamat =
      "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    });
  }

  //permission location
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Location services are disabled. Please enable the services.",
                style: TextStyle(color: Colors.white))
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text("Location permissions are denied",
                  style: TextStyle(color: Colors.white))
            ],
          ),
          backgroundColor: Colors.redAccent,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Location permissions are permanently denied, we cannot request permissions.",
                style: TextStyle(color: Colors.white))
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }

  //get date and time
  void setDateTime() {
    var date = DateTime.now();
    var newDate = DateFormat('dd-MM-yyyy').format(date);
    var newTime = DateFormat('HH:mm:ss').format(date);
    var newDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
    dateHours = int.parse(DateFormat('HH').format(date));
    dateMinutes = int.parse(DateFormat('mm').format(date));

    setState(() {
      strDate = newDate;
      strTime = newTime;
      strDateTime = newDateTime;
    });
  }

  //set status
  void setStatusAbsen() {
    if (dateHours <= 8) {
      setState(() {
        strStatus = "Absen Masuk";
      });
    } else if (dateHours <= 10) {
      setState(() {
        strStatus = "Absen Telat!!";
      });
    } else {
      setState(() {
        strStatus = "Absen Pulang";
      });
    }
  }

  //show loader
  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(color: Colors.pinkAccent),
          Container(margin: const EdgeInsets.only(left: 7), child: const Text("Mohon Tunggu...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //fungsi upload gambar ke Firebase Storage
  Future<String?> uploadImage(XFile? image) async {
    if (image == null) return null;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('absen_images').child(fileName);

    firebase_storage.UploadTask uploadTask = storageRef.putFile(File(image.path));
    await uploadTask.whenComplete(() => null);

    String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }

  //fungsi submit absen dengan menyimpan URL gambar
  Future<void> submitAbsen(String alamat, String nama, String status) async {
    showLoaderDialog(context);

    String? imageURL = await uploadImage(image);

    if (imageURL != null) {
      dataCollection.add({
        'alamat': alamat,
        'nama': nama,
        'keterangan': status,
        'datetime': strDateTime,
        'image_url': imageURL, // Menyimpan URL gambar di Firestore
      }).then((result) {
        setState(() {
          Navigator.of(context).pop();
          try {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text("Yeay! Absen berhasil!", style: TextStyle(color: Colors.white))
                ],
              ),
              backgroundColor: Colors.green,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserPage()));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("Ups, $e", style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              backgroundColor: Colors.redAccent,
              shape: const StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ));
          }
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text("Ups, $error", style: const TextStyle(color: Colors.white))
              )
            ],
          ),
          backgroundColor: Colors.redAccent,
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.of(context).pop();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
                child: Text("Ups, gagal mengunggah gambar", style: TextStyle(color: Colors.white))
            )
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.of(context).pop();
    }
  }
}
