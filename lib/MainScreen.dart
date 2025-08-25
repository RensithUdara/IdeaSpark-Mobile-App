import 'package:flutter/material.dart';
import 'main.dart';
import 'IdeaListenScreen.dart';
import 'IdeaSubmissionScreen.dart';
import 'LeadBoardScreen.dart';

class MainScreen extends StatefulWidget{
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  MainScreen({required this.toggleTheme, required this.isDarkMode});
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
    int currentIndex = 0;
    @override
    Widget build(BuildContext context){
      List<Widget> screens=[IdeaSubmissionScreen(), IdeaListenScreen(), LeaderboardScreen()];

      return Scaffold(
        appBar: AppBar(
          title:Text('Nous'),
          actions: [
            IconButton(
              icon : Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.toggleTheme,
            ),
          ],
          elevation: 0,
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index){
            setState((){
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Submit Idea'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Listen Ideas'),
            BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
          ],
        ),
      );

    }
}