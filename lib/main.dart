import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            _articles.removeAt(0);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("REFRESHED")));
          });
        },
        child: ListView(
          children: _articles.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(article.text!, style: const TextStyle(fontSize: 24.0)),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${article.commentsCount} comments"),
              IconButton(
                icon: const Icon(Icons.launch),
                color: Colors.green,
                onPressed: () async {
                  final fakeUri = Uri.parse("https://${article.domain}"); // somehting
                  if (await canLaunchUrl(fakeUri)) {
                    launchUrl(fakeUri);
                  }
                },
              ),
            ],
          ),
        ],
        //subtitle: Text( "${article.commentsCount} comments"),
        //onTap: () async {
        //  final fakeUri = Uri.parse("https://${article.domain}"); // somehting
        //  if (await canLaunchUrl(fakeUri)) {
        //    launchUrl(fakeUri);
        //  }
        //},
      ),
    );
  }
}
