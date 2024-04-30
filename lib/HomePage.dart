import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_book/DetailPage.dart';
import 'package:medical_book/LoginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: Column(
            children: [
              Align(alignment: Alignment.topRight, child: InkWell(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},child: Text('Log Out', style: TextStyle(color: Colors.white),))),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('books').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  var books = snapshot.data?.docs;
                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: books?.length ?? 0,
                      itemBuilder: (context, index) {
                        DocumentSnapshot book = books?[index] as DocumentSnapshot;
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailPage(book)));
                          },
                          child: SizedBox(
                            // height: 200,
                            child: Row(
                              children: [
                                // Icon(Icons.book, color: Colors.white,),
                                SizedBox(
                                  height: 150,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(book?["imageUrl"]),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                book?["title"] ?? 'N/A',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            _buildIconText(Icons.star, Colors.orange[300]!,
                                                '${book?["avgRatings"]}'),
                                          ],
                                        ),
                                        Text(
                                          book?["author"] ?? 'N/A',
                                          style: TextStyle(color: Colors.grey),
                                          maxLines: 2,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          book?["description"] ?? 'N/A',
                                          // overflow: TextOverflow,
                                          style: const TextStyle(color: Colors.grey),
                                          maxLines: 3,
                                        ),
                                        // const SizedBox(
                                        //   height: 15,
                                        // ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index){
                        return SizedBox(height: 15,);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 14,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }
}
