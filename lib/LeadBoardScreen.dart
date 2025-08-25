import 'package:flutter/material.dart';

import 'StartupIdea.dart';
import 'StorageServices.dart';
class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<StartupIdea> _topIdeas = [];

  @override
  void initState() {
    super.initState();
    _loadTopIdeas();
  }


  Future<void> _loadTopIdeas() async {
    List<StartupIdea> ideas = await StorageServices.getIdeas();

    // Sort by votes first, then aiRating
    ideas.sort((a, b) {
      int voteCompare = b.votes.compareTo(a.votes);
      if (voteCompare != 0) {
        return voteCompare;
      }
      // Tie-breaker -> aiRating
      return b.aiRating.compareTo(a.aiRating);
    });

    setState(() {
      _topIdeas = ideas.take(5).toList();
    });
  }


  Widget _buildLeaderboardItem(StartupIdea idea, int index) {
    String medal = '';
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Default card color depends on theme
    Color cardColor = isDark ? Colors.grey[850]! : Colors.grey[100]!;

    switch (index) {
      case 0:
        medal = '🥇';
        cardColor = isDark ? Colors.amber[700]! : Colors.amber[100]!;
        break;
      case 1:
        medal = '🥈';
        cardColor = isDark ? Colors.grey[700]! : Colors.grey[200]!;
        break;
      case 2:
        medal = '🥉';
        cardColor = isDark ? Colors.deepOrange[700]! : Colors.orange[100]!;
        break;
      default:
        medal = '${index + 1}';
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: index < 3 ? 8 : 4,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.black54 : Colors.white,
              ),
              child: Center(
                child: Text(
                  medal,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    idea.tagline,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '👍 ${idea.votes}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '🤖 ${idea.aiRating}/100',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[300] : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '🏆 Top Startup Ideas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _topIdeas.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No ideas to rank yet!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text('Submit and vote for ideas to see the leaderboard', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _topIdeas.length,
              itemBuilder: (context, index) {
                return _buildLeaderboardItem(_topIdeas[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}