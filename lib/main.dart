import 'package:flutter/material.dart';
import 'journal_page.dart';
import 'ananlysis_page.dart';
import 'history_page.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      home: const MyHomePage(
        title: 'EMOSTAR: An Insightful Journalling App',
      ),

      routes: {

        // Journal page.
        '/journal': (context) => const JournalPage(),

        // DO NOT create AnalysisPage here.
        //
        // AnalysisPage needs actual analysis data,
        // which is provided after the journal is analyzed.
        //
        // '/analysis': ...

        // History page.
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,

        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),

        actions: const [
          Icon(Icons.headphones),
          Icon(Icons.monitor_heart),
        ],
      ),


      drawer: Drawer(

        child: Column(
          children: [

            const DrawerHeader(
              child: Icon(
                Icons.favorite,
                size: 30,
              ),
            ),


            // Home
            ListTile(
              leading: const Icon(Icons.home),

              title: const Text('Home Page'),

              onTap: () {
                Navigator.pop(context);
              },
            ),


            // Today's journal
            ListTile(
              leading: const Icon(
                Icons.menu_book_outlined,
              ),

              title: const Text("Today's entry"),

              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  '/journal',
                );
              },
            ),


            // Historical data
            ListTile(
              leading: const Icon(
                Icons.trending_up,
              ),

              title: const Text('Historical data'),

              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  '/history',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}