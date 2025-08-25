import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'StartupIdea.dart';
import 'StorageServices.dart';

class IdeaListenScreen extends StatefulWidget {
  @override
  _IdeaListenScreenState createState() => _IdeaListenScreenState();
}

class _IdeaListenScreenState extends State<IdeaListenScreen> {
  List<StartupIdea> _ideas = [];
  String _sortBy = 'rating'; // 'rating' or 'votes'

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    List<StartupIdea> ideas = await StorageServices.getIdeas();
    setState(() {
      _ideas = ideas;
      _sortIdeas();
    });
  }

  void _sortIdeas() {
    _ideas.sort((a, b) {
      if (_sortBy == 'rating') {
        return b.aiRating.compareTo(a.aiRating);
      } else {
        return b.votes.compareTo(a.votes);
      }
    });
  }

  Future<void> _voteIdea(StartupIdea idea) async {
    bool hasVoted = await StorageServices.hasVoted(idea.id);

    if (hasVoted) {
      idea.votes--;
      await StorageServices.updateIdea(idea);
      await StorageServices.unmarkVoted(idea.id); // you need this in StorageServices


    } else {
      idea.votes++;
      await StorageServices.updateIdea(idea);
      await StorageServices.markAsVoted(idea.id);


    }

    _loadIdeas(); // refresh list
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text('📋 Sort by: ', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _sortBy,
                onChanged: (String? newValue) {
                  setState(() {
                    _sortBy = newValue!;
                    _sortIdeas();
                  });
                },
                items: [
                  DropdownMenuItem(value: 'rating', child: Text('AI Rating')),
                  DropdownMenuItem(value: 'votes', child: Text('Votes')),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _ideas.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No ideas yet!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text('Submit your first startup idea', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
              : ListView.builder(
            itemCount: _ideas.length,
            itemBuilder: (context, index) {
              StartupIdea idea = _ideas[index];
              return Slidable(
                key: ValueKey(idea.id),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Share',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [

                    SlidableAction(
                      onPressed: (_) async {
                        await StorageServices.deleteIdea(idea.id);
                        _loadIdeas(); // refresh this screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Idea deleted'),shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),backgroundColor: Colors.grey,),
                        );
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: IdeaCard(
                  idea: idea,
                  onVote: () => _voteIdea(idea),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class IdeaCard extends StatefulWidget {
  final StartupIdea idea;
  final VoidCallback onVote;

  IdeaCard({required this.idea, required this.onVote});

  @override
  _IdeaCardState createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  bool _isExpanded = false;

  Color _getRatingColor(int rating) {
    if (rating >= 90) return Colors.green;
    if (rating >= 70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.idea.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRatingColor(widget.idea.aiRating),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '🤖 ${widget.idea.aiRating}/100',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 11,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              widget.idea.tagline,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[600]),
            ),
            SizedBox(height: 6),

            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              firstChild: Container(),
              secondChild: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(widget.idea.description),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onVote,
                  icon: Icon(Icons.thumb_up, size: 14),
                  label: Text('${widget.idea.votes}'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(_isExpanded ? 'Show less' : 'Read more'),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.blueAccent),
                  onPressed: () {
                    final text = "🚀 ${widget.idea.name} - ${widget.idea.tagline}\n"
                        "🤖 Rating: ${widget.idea.aiRating}/100\n\n"
                        "${widget.idea.description}\n\n"
                        "👍 Votes: ${widget.idea.votes}";
                    Share.share(text);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
