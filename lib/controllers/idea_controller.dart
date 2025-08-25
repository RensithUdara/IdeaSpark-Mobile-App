import 'dart:math';
import '../models/startup_idea.dart';
import '../services/storage_service.dart';

class IdeaController {
  // Generate AI rating for idea
  static int generateAIRating() {
    Random random = Random();
    return 60 + random.nextInt(40); // Rating between 60-100
  }

  // Submit a new idea
  static Future<void> submitIdea({
    required String name,
    required String tagline,
    required String description,
  }) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    StartupIdea newIdea = StartupIdea(
      id: id,
      name: name,
      tagline: tagline,
      description: description,
      aiRating: generateAIRating(),
      votes: 0,
      createdAt: DateTime.now(),
    );

    await StorageService.saveIdea(newIdea);
  }

  // Get all ideas
  static Future<List<StartupIdea>> getAllIdeas() async {
    return await StorageService.getIdeas();
  }

  // Get sorted ideas
  static Future<List<StartupIdea>> getSortedIdeas(String sortBy) async {
    List<StartupIdea> ideas = await StorageService.getIdeas();
    
    ideas.sort((a, b) {
      if (sortBy == 'rating') {
        return b.aiRating.compareTo(a.aiRating);
      } else {
        return b.votes.compareTo(a.votes);
      }
    });
    
    return ideas;
  }

  // Vote for an idea
  static Future<void> voteIdea(StartupIdea idea) async {
    bool hasVoted = await StorageService.hasVoted(idea.id);

    if (hasVoted) {
      idea.votes--;
      await StorageService.updateIdea(idea);
      await StorageService.unmarkVoted(idea.id);
    } else {
      idea.votes++;
      await StorageService.updateIdea(idea);
      await StorageService.markAsVoted(idea.id);
    }
  }

  // Delete an idea
  static Future<void> deleteIdea(String ideaId) async {
    await StorageService.deleteIdea(ideaId);
  }

  // Get top ideas for leaderboard
  static Future<List<StartupIdea>> getTopIdeas({int limit = 5}) async {
    List<StartupIdea> ideas = await StorageService.getIdeas();

    // Sort by votes first, then aiRating
    ideas.sort((a, b) {
      int voteCompare = b.votes.compareTo(a.votes);
      if (voteCompare != 0) {
        return voteCompare;
      }
      // Tie-breaker -> aiRating
      return b.aiRating.compareTo(a.aiRating);
    });

    return ideas.take(limit).toList();
  }

  // Check if user has voted for an idea
  static Future<bool> hasUserVoted(String ideaId) async {
    return await StorageService.hasVoted(ideaId);
  }
}
