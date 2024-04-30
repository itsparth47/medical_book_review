import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_book/Constants.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot book;
  const DetailPage(this.book, {Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  late TextEditingController _feedbackController;
  late TextEditingController _rating;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
    _rating = TextEditingController();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _rating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              children: [
                SizedBox(
                  height: 550,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(30)),
                        child: Image.network(
                          widget.book?["imageUrl"],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                          top: 56,
                          left: 20,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        widget.book?["title"] ?? 'N/A',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24, height: 1.2, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.book?["author"] ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildIconText(Icons.star, Colors.orange[300]!,
                    //         '${book.score}(${book.review}k)'),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     _buildIconText(
                    //         Icons.visibility, Colors.white, '${book.view}M Read'),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Chip(
        
                            color: MaterialStateProperty.all<Color>(Colors.green),
                            label: Text(widget.book["category"].toString().toUpperCase()),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis
                            ),
        
                          ),
                        ),
                        SizedBox(width: 10,),
                        _buildIconText(Icons.star, Colors.orange[300]!,
                            '${widget.book?["avgRatings"]}'),
                        SizedBox(width: 10,),
                        Text(widget.book["totalRatings"].toString() + ' Ratings', style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)
                      ],
                    ),
        
                    const SizedBox(
                      height: 22,
                    ),
                    Text(                    widget.book?["description"] ?? 'N/A', style: TextStyle(color: Colors.white),
                    ),
                    // Padding(padding: EdgeInsets.symmetric(vertical: 20),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildButton(Icons.add, Colors.grey[800]!, 'Add To Library'),
                    //     const SizedBox(width: 15,),
                    //     _buildButton(Icons.menu_book, const Color(0xFF6741FF), 'Read Now')
                    //   ],
                    // ),)
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),
                    Align(alignment: Alignment.topLeft,child: Text('Feedbacks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),)),
                    SizedBox(height: 20),
                    // Display feedbacks here (you can replace this with your actual feedback UI)
                    // Example: ListView.builder to display each feedback
                    StreamBuilder<QuerySnapshot>(
                      stream: widget.book.reference.collection('feedback').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
        
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
        
                        if (!snapshot.hasData) {
                          return Text('No feedback available');
                        }
        
                        // Display feedbacks
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!.docs.map((feedbackDoc) {
                            var feedbackData = feedbackDoc.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        feedbackData["name"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      _buildIconText(Icons.star, Colors.orange[300]!,
                                          '${feedbackData["rating"]}'),
                                    ],
                                  ),
                                  Text(
                                    feedbackData["comment"],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
        
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFeedbackDialog(context);
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black,),
      ),
    );
  }

  Widget _buildButton(IconData icon, Color color, String text){
    return SizedBox(
      height: 40,
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: color,shape: RoundedRectangleBorder(
          borderRadius: BorderRadius
              .circular(10),
        ),
        ),onPressed: (){},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,size: 20,),
            const SizedBox(width: 5,),
            Text(text, style: const TextStyle(
              color: Colors.white,
              fontSize: 12,


            ),)
          ],
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

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: Text('Add Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rating'),
              TextField(
                controller: _rating,
                maxLength: 3,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,1}\.?\d{0,1}$')),
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double rating = double.parse(value);
                    if (rating < 0.0 || rating > 5.0) {
                      // Clear the text field if the input is out of range
                      _rating.clear();
                    }
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter Rating (0.0 - 5.0)...',
                ),
              ),
              SizedBox(height: 22,),
              Text('Feedback'),
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _rating.text.isNotEmpty && _feedbackController.text.isNotEmpty ?
                // Save feedback to Firestore
                {_saveFeedback(), Navigator.of(context).pop()} : null;

              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveFeedback() {
    String feedback = _feedbackController.text;
    // Save the feedback and rating to Firestore
    // Example: You can use widget.bookDocument.reference to access the document reference
    // and add a new feedback subcollection document.
    // You can use _rating and feedback variables to save data to Firestore.
    // Replace the code below with your Firestore implementation.

    widget.book.reference.collection('feedback').add({
      'rating': _rating.text,
      'name': name,
      'comment': feedback,
      'timestamp': DateTime.now(),
    }).then((value) {
      print('heh');
      // Feedback saved successfully
      // You can show a message or perform any other action if needed.
    }).catchError((error) {
      print(error);
      // Error saving feedback
      // Handle error appropriately
    });
  }
}

