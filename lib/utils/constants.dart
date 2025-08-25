class AppConstants {
  // App Information
  static const String appName = 'IdeaSpark';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String themeKey = 'isDarkMode';
  static const String ideasKey = 'startup_ideas';
  static const String votedPrefix = 'voted_';

  // Rating Constants
  static const int minAIRating = 60;
  static const int maxAIRating = 100;

  // UI Constants
  static const int leaderboardLimit = 5;
  static const int aiProcessingDelay = 2; // seconds

  // Messages
  static const String ideaSubmittedMessage = 'Idea submitted successfully!';
  static const String ideaDeletedMessage = 'Idea deleted successfully!';
  static const String votedMessage = 'Vote recorded!';
  static const String unvotedMessage = 'Vote removed!';
  static const String emptyIdeasMessage = 'No ideas submitted yet.\\nBe the first to share your innovative idea!';
  static const String emptyLeaderboardMessage = 'No ideas on the leaderboard yet.\\nSubmit and vote for ideas to see the top performers!';

  // Form Validation
  static const String nameRequiredMessage = 'Please enter idea name';
  static const String taglineRequiredMessage = 'Please enter tagline';
  static const String descriptionRequiredMessage = 'Please enter description';
  static const String nameMinLengthMessage = 'Idea name must be at least 3 characters';
  static const String taglineMinLengthMessage = 'Tagline must be at least 5 characters';
  static const String descriptionMinLengthMessage = 'Description must be at least 10 characters';

  static const int nameMinLength = 3;
  static const int taglineMinLength = 5;
  static const int descriptionMinLength = 10;
}
