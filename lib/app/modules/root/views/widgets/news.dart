import 'package:flutter/material.dart';
import 'news_detail_popup.dart';

class NewsList extends StatelessWidget {
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

   NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: news.length,
      itemBuilder: (BuildContext context, int index) {
        final newsItem = news[index];
        return NewsCard(newsItem: newsItem);
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, String> newsItem;

  const NewsCard({Key? key, required this.newsItem}) : super(key: key);

  void _showNewsDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewsDetailPopup(newsItem: newsItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            newsItem['imageUrl']!,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          ),
        ),
        title: Text(
          newsItem['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(newsItem['subtitle']!),
        onTap: () => _showNewsDetail(context),
      ),
    );
  }
}
