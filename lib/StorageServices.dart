import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'StartupIdea.dart';

class StorageServices {
  static Future<List<StartupIdea>> getIdeas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ideasJson = prefs.getString('startup_ideas');
    if (ideasJson == null) return [];

    List<dynamic> ideaList = json.decode(ideasJson);
    return ideaList.map((idea) => StartupIdea.fromJson(idea)).toList();
  }

  static Future<void> saveIdea(StartupIdea idea) async {
    List<StartupIdea> ideas = await getIdeas();
    ideas.add(idea);
    await _saveIdeas(ideas);
  }

  static Future<void> updateIdea(StartupIdea updatedIdea) async {
    List<StartupIdea> ideas = await getIdeas();
    int index = ideas.indexWhere((idea) => idea.id == updatedIdea.id);
    if (index != -1) {
      ideas[index] = updatedIdea;
      await _saveIdeas(ideas);
    }
  }

  static Future<void> _saveIdeas(List<StartupIdea> ideas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ideasJson = json.encode(ideas.map((idea) => idea.toJson()).toList());
    await prefs.setString('startup_ideas', ideasJson);
  }

  static Future<bool> hasVoted(String ideaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('voted_$ideaId') ?? false;
  }

  static Future<void> markAsVoted(String ideaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voted_$ideaId', true);
  }

  static Future<void> deleteIdea(String ideaId) async {
    List<StartupIdea> ideas = await getIdeas();
    ideas.removeWhere((idea) => idea.id == ideaId);
    await _saveIdeas(ideas);

    // 🔄 Also remove vote marker (if any)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('voted_$ideaId');
  }

  // 🔄 New function to remove vote mark
  static Future<void> unmarkVoted(String ideaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('voted_$ideaId');
  }
}
