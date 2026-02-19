import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:go_router/go_router.dart';

import '../../models/challenge.dart';
import '../../models/user_progress.dart';
import '../../services/daily_challenge_storage.dart';
import '../../theme/app_theme.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  final _storage = DailyChallengeStorage();
  final _answerController = TextEditingController();
  final _random = Random();

  Challenge? _currentChallenge;
  UserProgress _userProgress = UserProgress.initial();
  bool _isLoading = true;

  bool _isPlaying = false;
  int _score = 0;
  int _attempts = 0;
  int _maxAttempts = 5;
  Map<String, dynamic> _gameData = {};
  bool _showHint = false;

  final List<Challenge> _challenges = [];

  @override
  void initState() {
    super.initState();
    _seedChallenges();
    _initialize();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _seedChallenges() {
    _challenges.addAll([
      Challenge(
        id: '1',
        title: 'Word Association',
        description: 'Find a word related to "Garden"',
        type: 'word',
        difficulty: 'easy',
        points: 10,
        completed: false,
        gameData: {
          'category': 'Garden',
          'correctAnswers': ['flower', 'plant', 'tree', 'grass', 'soil', 'water', 'sun', 'seed'],
          'hint': 'Think about things you find in a garden',
        },
      ),
      Challenge(
        id: '2',
        title: 'Number Pattern',
        description: 'Complete the sequence: 2, 4, 8, 16, ?',
        type: 'logic',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'sequence': [2, 4, 8, 16],
          'answer': 32,
          'pattern': 'multiply by 2',
          'hint': 'Each number is multiplied by 2 to get the next number',
        },
      ),
      Challenge(
        id: '3',
        title: 'Memory Sequence',
        description: 'Remember and repeat the pattern of colors',
        type: 'memory',
        difficulty: 'easy',
        points: 12,
        completed: false,
        gameData: {
          'colors': ['red', 'blue', 'green', 'yellow', 'purple'],
          'sequence': [0, 2, 1, 4, 3],
          'currentStep': 0,
          'showSequence': false,
        },
      ),
      Challenge(
        id: '4',
        title: 'Picture Puzzle',
        description: 'Arrange the pieces to complete the image',
        type: 'puzzle',
        difficulty: 'hard',
        points: 20,
        completed: false,
        gameData: {
          'pieces': [1, 2, 3, 4, 5, 6, 7, 8, 9],
          'correctOrder': [1, 2, 3, 4, 5, 6, 7, 8, 9],
          'currentOrder': [1, 2, 3, 4, 5, 6, 7, 8, 9],
          'hint': 'Arrange numbers in ascending order',
        },
      ),
      Challenge(
        id: '5',
        title: 'Logic Riddle',
        description: 'Solve the riddle: What has keys but no locks?',
        type: 'logic',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'riddle': 'What has keys but no locks?',
          'answer': 'piano',
          'alternatives': ['keyboard', 'computer', 'typewriter'],
          'hint': 'It makes music when you press the keys',
        },
      ),
      Challenge(
        id: '6',
        title: 'Memory Cards',
        description: 'Match pairs of cards in the shortest time',
        type: 'memory',
        difficulty: 'easy',
        points: 12,
        completed: false,
        gameData: {
          'cards': ['🍎', '🍎', '🍌', '🍌', '🍇', '🍇', '🍊', '🍊'],
        },
      ),
      Challenge(
        id: '7',
        title: 'Word Scramble',
        description: 'Unscramble the letters to form a word',
        type: 'word',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'scrambled': 'T A E C H R',
          'answer': 'teacher',
          'hint': 'Someone who helps you learn',
        },
      ),
      Challenge(
        id: '8',
        title: 'Riddle: Time Travel',
        description: 'What gets wetter and wetter the more it dries?',
        type: 'logic',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'riddle': 'What gets wetter and wetter the more it dries?',
          'answer': 'towel',
          'alternatives': ['sponge', 'cloth', 'rag'],
          'hint': 'You use it after taking a shower',
        },
      ),
      Challenge(
        id: '9',
        title: 'Riddle: The Silent Speaker',
        description: 'What speaks without a mouth and runs without legs?',
        type: 'logic',
        difficulty: 'hard',
        points: 20,
        completed: false,
        gameData: {
          'riddle': 'What speaks without a mouth and runs without legs?',
          'answer': 'echo',
          'alternatives': ['sound', 'voice', 'noise'],
          'hint': 'It repeats what you say',
        },
      ),
      Challenge(
        id: '10',
        title: 'Riddle: The Growing Room',
        description: 'The more you take, the more you leave behind. What am I?',
        type: 'logic',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'riddle': 'The more you take, the more you leave behind. What am I?',
          'answer': 'footsteps',
          'alternatives': ['footprints', 'tracks', 'path'],
          'hint': 'You make them when you walk',
        },
      ),
      Challenge(
        id: '11',
        title: 'Riddle: The Invisible Man',
        description: 'What has cities, but no houses; forests, but no trees; and rivers, but no water?',
        type: 'logic',
        difficulty: 'hard',
        points: 20,
        completed: false,
        gameData: {
          'riddle': 'What has cities, but no houses; forests, but no trees; and rivers, but no water?',
          'answer': 'map',
          'alternatives': ['globe', 'atlas', 'chart'],
          'hint': 'You use it to find your way',
        },
      ),
      Challenge(
        id: '12',
        title: 'Riddle: The Broken Clock',
        description: 'What is always in front of you but can\'t be seen?',
        type: 'logic',
        difficulty: 'easy',
        points: 10,
        completed: false,
        gameData: {
          'riddle': 'What is always in front of you but can\'t be seen?',
          'answer': 'future',
          'alternatives': ['tomorrow', 'time', 'destiny'],
          'hint': 'It hasn\'t happened yet',
        },
      ),
      Challenge(
        id: '13',
        title: 'Riddle: The Light Switch',
        description: 'What has keys, no locks; space, no room; and you can enter, but not go in?',
        type: 'logic',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'riddle': 'What has keys, no locks; space, no room; and you can enter, but not go in?',
          'answer': 'keyboard',
          'alternatives': ['computer', 'typewriter', 'piano'],
          'hint': 'You use it to type',
        },
      ),
      Challenge(
        id: '14',
        title: 'Riddle: The Colorful Box',
        description: 'What is black when you buy it, red when you use it, and gray when you throw it away?',
        type: 'logic',
        difficulty: 'medium',
        points: 15,
        completed: false,
        gameData: {
          'riddle': 'What is black when you buy it, red when you use it, and gray when you throw it away?',
          'answer': 'charcoal',
          'alternatives': ['coal', 'ash', 'wood'],
          'hint': 'You use it for cooking',
        },
      ),
      Challenge(
        id: '15',
        title: 'Riddle: The Silent Library',
        description: 'What has words, but never speaks?',
        type: 'logic',
        difficulty: 'easy',
        points: 10,
        completed: false,
        gameData: {
          'riddle': 'What has words, but never speaks?',
          'answer': 'book',
          'alternatives': ['newspaper', 'magazine', 'letter'],
          'hint': 'You read it',
        },
      ),
    ]);
  }

  Future<void> _initialize() async {
    _userProgress = await _storage.loadProgress();
    _currentChallenge = _getTodaysChallenge();
    setState(() => _isLoading = false);
  }

  Challenge _getTodaysChallenge() {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year, 1, 0)).inDays;
    final index = dayOfYear % _challenges.length;
    return _challenges[index];
  }

  bool _isChallengeCompletedToday() {
    final today = DateTime.now().toString().split(' ').first;
    return _userProgress.lastCompletedDate == today;
  }

  List<bool> _updateWeeklyProgress() {
    final dayOfWeek = DateTime.now().weekday % 7; // Sunday=0
    final updated = List<bool>.from(_userProgress.weeklyProgress);
    updated[dayOfWeek] = true;
    return updated;
  }

  int _updateStreak() {
    final today = DateTime.now();
    if (_userProgress.lastCompletedDate.isEmpty) return 1;
    final last = DateTime.tryParse(_userProgress.lastCompletedDate);
    if (last == null) return 1;
    final yesterday = today.subtract(const Duration(days: 1));
    if (_isSameDate(last, yesterday)) {
      return _userProgress.streak + 1;
    }
    if (_isSameDate(last, today)) {
      return _userProgress.streak;
    }
    return 1;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _initializeGame(Challenge challenge) {
    final gameData = Map<String, dynamic>.from(challenge.gameData);
    if (challenge.type == 'memory' && challenge.id == '3') {
      gameData['currentStep'] = 0;
      gameData['showSequence'] = false;
    }
    if (challenge.type == 'puzzle') {
      final correct = List<int>.from(gameData['correctOrder']);
      correct.shuffle(_random);
      gameData['currentOrder'] = correct;
    }
    _answerController.clear();
    setState(() {
      _isPlaying = true;
      _score = 0;
      _attempts = 0;
      _maxAttempts = 5;
      _gameData = gameData;
      _showHint = false;
    });
  }

  void _handleGameSubmit() {
    if (_currentChallenge == null) return;
    if (_currentChallenge!.type != 'puzzle' && _answerController.text.trim().isEmpty) return;

    final challenge = _currentChallenge!;
    final userAnswer = _answerController.text.trim().toLowerCase();
    bool isCorrect = false;

    switch (challenge.type) {
      case 'word':
        if (challenge.id == '1') {
          isCorrect = (challenge.gameData['correctAnswers'] as List).contains(userAnswer);
        } else if (challenge.id == '7') {
          isCorrect = userAnswer == challenge.gameData['answer'];
        }
        break;
      case 'logic':
        if (challenge.id == '2') {
          isCorrect = int.tryParse(userAnswer) == challenge.gameData['answer'];
        } else {
          isCorrect = userAnswer == challenge.gameData['answer'] ||
              (challenge.gameData['alternatives'] as List).contains(userAnswer);
        }
        break;
      case 'puzzle':
        final currentOrder = _gameData['currentOrder'] as List;
        final correctOrder = challenge.gameData['correctOrder'] as List;
        isCorrect = currentOrder.toString() == correctOrder.toString();
        break;
      default:
        break;
    }

    final newAttempts = _attempts + 1;
    final rawScore = isCorrect ? challenge.points - (newAttempts - 1) * 2 : 0;
    final newScore = max(rawScore, 1);

    if (isCorrect) {
      final newStreak = _updateStreak();
      final newWeekly = _updateWeeklyProgress();
      final today = DateTime.now().toString().split(' ').first;

      final updated = _userProgress.copyWith(
        streak: newStreak,
        totalPoints: _userProgress.totalPoints + newScore,
        lastCompletedDate: today,
        weeklyProgress: newWeekly,
        gamesPlayed: _userProgress.gamesPlayed + 1,
        bestScores: {
          ..._userProgress.bestScores,
          challenge.id: max(_userProgress.bestScores[challenge.id] ?? 0, newScore),
        },
      );

      _userProgress = updated;
      _storage.saveProgress(updated);

      setState(() {
        _score = newScore;
        _attempts = newAttempts;
        _isPlaying = false;
      });

      _showDialog(
        '🎉 Challenge Complete!',
        'Congratulations! You solved it in $newAttempts attempt(s)!\n\nScore: $newScore points\nNew streak: $newStreak days\nTotal points: ${updated.totalPoints}',
      );
    } else if (newAttempts >= _maxAttempts) {
      setState(() {
        _attempts = newAttempts;
        _isPlaying = false;
      });

      _showConfirmation(
        'Game Over',
        'You\'ve used all $_maxAttempts attempts. Would you like to try again?',
        onConfirm: () => _initializeGame(challenge),
      );
    } else {
      setState(() {
        _attempts = newAttempts;
        _answerController.clear();
      });

      _showDialog('Incorrect Answer', 'Try again! You have ${_maxAttempts - newAttempts} attempts left.');
    }
  }

  void _startMemorySequence() {
    if (_currentChallenge == null || _currentChallenge!.type != 'memory') return;
    if (_gameData['showSequence'] == true) return;

    setState(() => _gameData['showSequence'] = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _gameData['showSequence'] = false);
      }
    });
  }

  void _handleMemorySequenceTap(int index) {
    if (_currentChallenge == null || _currentChallenge!.type != 'memory') return;
    if (_gameData['showSequence'] == true) return;

    final sequence = _gameData['sequence'] as List;
    final currentStep = _gameData['currentStep'] as int;
    final expectedIndex = sequence[currentStep];

    if (expectedIndex == index) {
      final newStep = currentStep + 1;
      if (newStep >= sequence.length) {
        _handleGameSubmit();
      } else {
        setState(() => _gameData['currentStep'] = newStep);
      }
    } else {
      final newAttempts = _attempts + 1;
      if (newAttempts >= _maxAttempts) {
        setState(() {
          _attempts = newAttempts;
          _isPlaying = false;
        });
        _showConfirmation(
          'Game Over',
          'You clicked the wrong color! Would you like to try again?',
          onConfirm: () => _initializeGame(_currentChallenge!),
        );
      } else {
        setState(() {
          _attempts = newAttempts;
          _gameData['currentStep'] = 0;
        });
        _showDialog('Wrong Color!', 'Try again! You have ${_maxAttempts - newAttempts} attempts left.');
      }
    }
  }

  void _handlePuzzleMove(int fromIndex, int toIndex) {
    final currentOrder = List<int>.from(_gameData['currentOrder']);
    final temp = currentOrder[fromIndex];
    currentOrder[fromIndex] = currentOrder[toIndex];
    currentOrder[toIndex] = temp;
    setState(() => _gameData['currentOrder'] = currentOrder);
  }

  void _handleStartChallenge() {
    if (_currentChallenge == null) return;

    if (_isChallengeCompletedToday()) {
      _showDialog('Challenge Already Completed', 'You have already completed today\'s challenge! Come back tomorrow for a new one.');
      return;
    }

    _showConfirmation(
      'Start Challenge',
      'Ready to begin "${_currentChallenge!.title}"?\n\nDifficulty: ${_currentChallenge!.difficulty}\nPoints: ${_currentChallenge!.points}\nAttempts: $_maxAttempts',
      onConfirm: () => _initializeGame(_currentChallenge!),
    );
  }

  String _difficultyLabel(String difficulty) => difficulty.toUpperCase();

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'word':
        return Ionicons.text_outline;
      case 'logic':
        return Ionicons.calculator_outline;
      case 'memory':
        return Ionicons.fitness_outline;
      case 'puzzle':
        return Ionicons.grid_outline;
      default:
        return Ionicons.help_outline;
    }
  }

  String _dayName(int index) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[index];
  }

  bool _isToday(int index) {
    final today = DateTime.now().weekday % 7;
    return index == today;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    if (_isLoading || _currentChallenge == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Text('Loading challenge...', style: TextStyle(color: colors.text, fontSize: 16)),
        ),
      );
    }

    final isCompletedToday = _isChallengeCompletedToday();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Ionicons.arrow_back, color: colors.text),
                  ),
                  Text('Daily Challenge', style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(value: _userProgress.streak.toString(), label: 'Day Streak', colors: colors),
                          _StatItem(value: _userProgress.totalPoints.toString(), label: 'Total Points', colors: colors),
                          _StatItem(value: isCompletedToday ? '✓' : 'Today', label: 'Challenge', colors: colors),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isPlaying)
                      _buildGameCard(colors)
                    else
                      _buildChallengeCard(colors, isCompletedToday),
                    const SizedBox(height: 24),
                    Text('Quick Actions', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (!isCompletedToday && !_isPlaying)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _handleStartChallenge,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.tint,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Ionicons.play_circle_outline, color: Colors.white, size: 20),
                              label: const Text('Start Game', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        if (!isCompletedToday && !_isPlaying) const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/explore'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.tint,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Ionicons.trending_up_outline, color: Colors.white, size: 20),
                            label: const Text('View Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('This Week', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < _userProgress.weeklyProgress.length; i++)
                          Column(
                            children: [
                              Text(
                                _dayName(i),
                                style: TextStyle(
                                  color: _isToday(i) ? colors.tint : colors.icon,
                                  fontWeight: _isToday(i) ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _userProgress.weeklyProgress[i]
                                      ? colors.tint
                                      : Colors.black.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: _isToday(i)
                                      ? Border.all(color: colors.tint, width: 2)
                                      : null,
                                ),
                                child: _userProgress.weeklyProgress[i]
                                    ? const Icon(Ionicons.checkmark, size: 12, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(AppThemeColors colors, bool isCompletedToday) {
    final challenge = _currentChallenge!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompletedToday ? const Color(0xFF4CAF50) : colors.icon.withOpacity(0.4),
          width: isCompletedToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: colors.tint.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(_typeIcon(challenge.type), color: colors.tint),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(challenge.title, style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _difficultyColor(challenge.difficulty).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _difficultyLabel(challenge.difficulty),
                            style: TextStyle(
                              color: _difficultyColor(challenge.difficulty),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('${challenge.points} pts', style: TextStyle(color: colors.tint, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(challenge.description, style: TextStyle(color: colors.icon, fontSize: 16, height: 1.4)),
          const SizedBox(height: 20),
          if (isCompletedToday)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Ionicons.checkmark_circle, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Completed Today', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _initializeGame(challenge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.tint,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Ionicons.refresh, color: Colors.white, size: 20),
                    label: const Text('Play Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            )
          else
            ElevatedButton.icon(
              onPressed: _handleStartChallenge,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.tint,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Ionicons.play_outline, color: Colors.white, size: 20),
              label: const Text('Start Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildGameCard(AppThemeColors colors) {
    final challenge = _currentChallenge!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.tint, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Attempts: $_attempts/$_maxAttempts', style: TextStyle(color: colors.text, fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: () {
                  _showConfirmation(
                    'Quit Game',
                    'Are you sure you want to quit? Your progress will be lost.',
                    onConfirm: () => setState(() => _isPlaying = false),
                  );
                },
                icon: Icon(Ionicons.close, color: colors.text, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGameInterface(colors, challenge),
        ],
      ),
    );
  }

  Widget _buildGameInterface(AppThemeColors colors, Challenge challenge) {
    switch (challenge.type) {
      case 'word':
        return _buildWordGame(colors, challenge);
      case 'logic':
        return _buildLogicGame(colors, challenge);
      case 'memory':
        if (challenge.id == '3') {
          return _buildMemorySequenceGame(colors);
        }
        return const SizedBox.shrink();
      case 'puzzle':
        return _buildPuzzleGame(colors);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWordGame(AppThemeColors colors, Challenge challenge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(challenge.title, style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(challenge.description, style: TextStyle(color: colors.icon, fontSize: 14, height: 1.4)),
        const SizedBox(height: 12),
        if (challenge.id == '1')
          Text('Hint: ${challenge.gameData['hint']}', style: TextStyle(color: colors.tint, fontSize: 12)),
        const SizedBox(height: 12),
        _answerField(colors),
        const SizedBox(height: 12),
        _gameButtons(colors),
        if (_showHint)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(challenge.gameData['hint'], style: TextStyle(color: colors.tint)),
          ),
      ],
    );
  }

  Widget _buildLogicGame(AppThemeColors colors, Challenge challenge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(challenge.title, style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(challenge.description, style: TextStyle(color: colors.icon, fontSize: 14, height: 1.4)),
        const SizedBox(height: 12),
        if (challenge.id == '2')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${(challenge.gameData['sequence'] as List).join(', ')} → ?', style: TextStyle(color: colors.text, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Pattern: ${challenge.gameData['pattern']}', style: TextStyle(color: colors.tint, fontSize: 12)),
            ],
          ),
        if (challenge.id == '5')
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(challenge.gameData['riddle'], style: TextStyle(color: colors.text, fontWeight: FontWeight.w600)),
          ),
        _answerField(colors),
        const SizedBox(height: 12),
        _gameButtons(colors),
        if (_showHint)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(challenge.gameData['hint'], style: TextStyle(color: colors.tint)),
          ),
      ],
    );
  }

  Widget _buildMemorySequenceGame(AppThemeColors colors) {
    final sequence = _gameData['sequence'] as List;
    final colorsList = _gameData['colors'] as List;
    final currentStep = _gameData['currentStep'] as int;
    final showSequence = _gameData['showSequence'] as bool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Memory Sequence', style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Watch the sequence and repeat it!', style: TextStyle(color: colors.icon, fontSize: 14)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int index = 0; index < colorsList.length; index++)
              GestureDetector(
                onTap: showSequence ? null : () => _handleMemorySequenceTap(index),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _parseColor(colorsList[index]).withOpacity(
                      showSequence && sequence[currentStep] == index ? 1 : 0.3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _startMemorySequence,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.tint,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            showSequence ? 'Watching...' : 'Start Sequence',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildPuzzleGame(AppThemeColors colors) {
    final currentOrder = _gameData['currentOrder'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Number Puzzle', style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Arrange the numbers in ascending order', style: TextStyle(color: colors.icon, fontSize: 14)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int index = 0; index < currentOrder.length; index++)
              GestureDetector(
                onTap: () {
                  final nextIndex = (index + 1) % currentOrder.length;
                  _handlePuzzleMove(index, nextIndex);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.tint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentOrder[index].toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleGameSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.tint,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Check Solution', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _answerField(AppThemeColors colors) {
    return TextField(
      controller: _answerController,
      onSubmitted: (_) => _handleGameSubmit(),
      decoration: InputDecoration(
        hintText: 'Enter your answer...',
        hintStyle: TextStyle(color: colors.icon),
        filled: true,
        fillColor: colors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.icon),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      ),
      style: TextStyle(color: colors.text, fontSize: 16),
    );
  }

  Widget _gameButtons(AppThemeColors colors) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _handleGameSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.tint,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Submit Answer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _showHint = !_showHint),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.icon,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Show Hint', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String name) {
    switch (name) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  void _showConfirmation(String title, String message, {required VoidCallback onConfirm}) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label, required this.colors});

  final String value;
  final String label;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: colors.icon, fontSize: 12)),
      ],
    );
  }
}
