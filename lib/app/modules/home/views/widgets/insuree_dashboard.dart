import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/root/views/widgets/carousel.dart';

class InsureeDashboardScreen extends StatelessWidget {
  final List<Map<String, String>> news = [
    {
      'title': 'Global Health Conference 2024',
      'subtitle': 'Learn about the latest advancements in health care.',
      'content': 'The Global Health Conference 2024 brings together experts from all over the world to discuss innovations and challenges in health care.',
      'imageUrl': 'https://openimis.org/sites/default/files/styles/news/public/2024-11/_u2k4288.jpg?itok=CdyxDe-x',
    },
    {
      'title': 'New Insurance Policy Launched',
      'subtitle': 'Affordable and comprehensive health insurance.',
      'content': 'A new insurance policy has been launched to provide affordable and comprehensive health care to citizens worldwide.',
      'imageUrl': 'https://openimis.org/sites/default/files/styles/news/public/2023-03/1200x627_1_-_kopie.jpg?itok=Xoux5jII',
    },
    {
      'title': 'Tech in Health: 2024 Trends',
      'subtitle': 'Discover how technology is reshaping health care.',
      'content': 'Health care technology is rapidly evolving, with AI and telemedicine playing a pivotal role in patient care.',
      'imageUrl': 'https://openimis.org/sites/default/files/styles/news/public/2022-09/Cameroon-Health%20Insurance.png?itok=w_enq7EH',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselExample(),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  height: MediaQuery.of(context).size.height / 2, // Half screen height
                  child: ListView.builder(
                    itemCount: news.length, // Number of items in news list
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              news[index]['imageUrl']!,
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(news[index]['title']!),
                          subtitle: Text(news[index]['subtitle']!),
                          onTap: () {
                            // Show news detail bottom sheet with half screen height
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true, // Allows custom height
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height / 2, // Half screen height
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news[index]['title']!,
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        news[index]['content']!,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the bottom sheet
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
