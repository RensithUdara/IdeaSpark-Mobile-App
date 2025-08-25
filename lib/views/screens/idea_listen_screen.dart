import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/startup_idea.dart';
import '../../controllers/idea_controller.dart';
import '../../utils/constants.dart';

class IdeaListenScreen extends StatefulWidget {
  @override
  _IdeaListenScreenState createState() => _IdeaListenScreenState();
}

class _IdeaListenScreenState extends State<IdeaListenScreen> {
  List<StartupIdea> _ideas = [];
  String _sortBy = 'rating'; // 'rating' or 'votes'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<StartupIdea> ideas = await IdeaController.getSortedIdeas(_sortBy);
      setState(() {
        _ideas = ideas;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showToast('Error loading ideas. Please try again.');
    }
  }

  Future<void> _voteIdea(StartupIdea idea) async {
    try {
      await IdeaController.voteIdea(idea);
      bool hasVoted = await IdeaController.hasUserVoted(idea.id);
      
      _showToast(hasVoted ? AppConstants.votedMessage : AppConstants.unvotedMessage);
      _loadIdeas(); // Refresh the list
    } catch (error) {
      _showToast('Error voting. Please try again.');
    }
  }

  Future<void> _deleteIdea(String ideaId) async {
    try {
      await IdeaController.deleteIdea(ideaId);
      _showToast(AppConstants.ideaDeletedMessage);
      _loadIdeas(); // Refresh the list
    } catch (error) {
      _showToast('Error deleting idea. Please try again.');
    }
  }

  void _shareIdea(StartupIdea idea) {
    String shareText = '''
🚀 Check out this startup idea!

💡 ${idea.name}
🎯 ${idea.tagline}

${idea.description}

🤖 AI Rating: ${idea.aiRating}/100
👍 Votes: ${idea.votes}

Shared from ${AppConstants.appName}
    ''';

    Share.share(shareText, subject: 'Startup Idea: ${idea.name}');
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
    return Column(
      children: [
        // Sort Options
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Sort by: ',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Expanded(
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'rating',
                      label: Text('AI Rating'),
                      icon: Icon(Icons.smart_toy),
                    ),
                    ButtonSegment(
                      value: 'votes',
                      label: Text('Votes'),
                      icon: Icon(Icons.thumb_up),
                    ),
                  ],
                  selected: {_sortBy},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _sortBy = selection.first;
                    });
                    _loadIdeas();
                  },
                ),
              ),
            ],
          ),
        ),

        // Ideas List
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _ideas.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadIdeas,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _ideas.length,
                        itemBuilder: (context, index) {
                          return _buildIdeaCard(_ideas[index]);
                        },
                      ),
                    ),
        ),
      ],
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
              Icons.lightbulb_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              AppConstants.emptyIdeasMessage,
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

  Widget _buildIdeaCard(StartupIdea idea) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _shareIdea(idea),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
            SlidableAction(
              onPressed: (context) => _deleteIdea(idea.id),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and AI rating
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          idea.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          idea.tagline,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAIRatingColor(idea.aiRating),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.smart_toy, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          '${idea.aiRating}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              // Description
              Text(
                idea.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              
              // Footer with votes and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<bool>(
                    future: IdeaController.hasUserVoted(idea.id),
                    builder: (context, snapshot) {
                      bool hasVoted = snapshot.data ?? false;
                      return ElevatedButton.icon(
                        onPressed: () => _voteIdea(idea),
                        icon: Icon(
                          hasVoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 16,
                        ),
                        label: Text('${idea.votes}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasVoted 
                              ? Theme.of(context).primaryColor 
                              : null,
                          foregroundColor: hasVoted 
                              ? Colors.white 
                              : null,
                        ),
                      );
                    },
                  ),
                  Text(
                    _formatDate(idea.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
