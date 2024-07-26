import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('absensi');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1B216B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: dataCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return data.isNotEmpty 
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var docData = data[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          AlertDialog dialogHapus = AlertDialog(
                            title: const Text("Hapus Data", style: TextStyle(fontSize: 18, color: Colors.black)),
                            content: const SizedBox(
                              height: 20,
                              child: Column(
                                children: [
                                  Text("Yakin ingin menghapus data ini?", style: TextStyle(fontSize: 14, color: Colors.black)),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    dataCollection.doc(data[index].id).delete();
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("Ya", style: TextStyle(fontSize: 14, color: Color(0xFF1B216B))),
                              ),
                              TextButton(
                                child: const Text("Tidak", style: TextStyle(fontSize: 14, color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (context) => dialogHapus,
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      docData['nama'][0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (docData.containsKey('image_url') && docData['image_url'] != null)
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(docData['image_url']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 4,
                                            child: Text("Nama", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text(" : ", style: TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Text(docData['nama'], style: const TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 4,
                                            child: Text("Alamat", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text(" : ", style: TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Text(docData['alamat'], style: const TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 4,
                                            child: Text("Keterangan", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text(" : ", style: TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Text(docData['keterangan'], style: const TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 4,
                                            child: Text("Waktu Absen", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text(" : ", style: TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Text(docData['datetime'], style: const TextStyle(color: Colors.black, fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "Ups, tidak ada data!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B216B)),
              ),
            );
          }
        },
      ),
    );
  }
}
