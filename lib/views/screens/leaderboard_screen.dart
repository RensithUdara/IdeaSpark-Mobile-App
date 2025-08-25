import 'package:flutter/material.dart';
import '../../models/startup_idea.dart';
import '../../controllers/idea_controller.dart';
import '../../utils/constants.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<StartupIdea> _topIdeas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopIdeas();
  }

  Future<void> _loadTopIdeas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<StartupIdea> ideas = await IdeaController.getTopIdeas(
        limit: AppConstants.leaderboardLimit,
      );
      setState(() {
        _topIdeas = ideas;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showToast('Error loading leaderboard. Please try again.');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadTopIdeas,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _topIdeas.isEmpty
              ? _buildEmptyState()
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Header
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 48,
                              color: Colors.amber,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Top Ideas Leaderboard',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ideas ranked by votes and AI ratings',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Leaderboard Items
                    ...List.generate(_topIdeas.length, (index) {
                      return _buildLeaderboardItem(_topIdeas[index], index);
                    }),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              AppConstants.emptyLeaderboardMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
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
        cardColor = isDark ? Colors.grey[600]! : Colors.grey[300]!;
        break;
      case 2:
        medal = '🥉';
        cardColor = isDark ? Colors.orange[700]! : Colors.orange[100]!;
        break;
      default:
        medal = '#${index + 1}';
        break;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Position/Medal
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: index < 3 ? Colors.transparent : Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  medal,
                  style: TextStyle(
                    fontSize: index < 3 ? 24 : 16,
                    fontWeight: FontWeight.bold,
                    color: index < 3 ? null : Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            
            // Idea Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    idea.tagline,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Stats
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(
                      '${idea.votes}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.smart_toy, size: 16, color: _getAIRatingColor(idea.aiRating)),
                    SizedBox(width: 4),
                    Text(
                      '${idea.aiRating}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getAIRatingColor(idea.aiRating),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAIRatingColor(int rating) {
    if (rating >= 90) return Colors.green;
    if (rating >= 80) return Colors.orange;
    if (rating >= 70) return Colors.blue;
    return Colors.grey;
  }
}
