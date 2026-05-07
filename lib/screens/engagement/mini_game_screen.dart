import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../theme/app_theme.dart';

enum MiniGameType { memory, puzzle, word, logic }

class MiniGameScreen extends StatefulWidget {
  const MiniGameScreen({super.key, required this.type});

  final MiniGameType type;

  @override
  State<MiniGameScreen> createState() => _MiniGameScreenState();
}

class _MiniGameScreenState extends State<MiniGameScreen> {
  final Random _random = Random();
  int _score = 0;
  String? _feedback;
  bool _feedbackIsSuccess = false;

  int _lastRoundIndex = -1;

  // Memory game state
  List<String> _memorySequence = const [];
  String _memoryTargetWord = '';
  List<String> _memoryOptions = const [];
  bool _memoryRevealed = false;
  Timer? _memoryHideTimer;

  // Puzzle (number) game state
  List<int> _puzzleNumbers = const [];
  List<int> _puzzleOptions = const [];
  int _puzzleAnswer = 0;

  // Word game state
  String _scrambledWord = '';
  String _wordAnswer = '';
  List<String> _wordOptions = const [];

  // Logic game state
  String _logicQuestion = '';
  List<String> _logicOptions = const [];
  String _logicAnswer = '';

  static const _memoryRounds = <List<String>>[
    ['Tea', 'Book', 'Rose', 'Lamp'],
    ['Mango', 'Clock', 'Chair', 'Moon'],
    ['River', 'Bread', 'Leaf', 'Bird'],
    ['Apple', 'Window', 'Pencil', 'Cloud'],
    ['Sugar', 'Glasses', 'Garden', 'Letter'],
    ['Music', 'Spoon', 'Mirror', 'Candle'],
    ['Sister', 'Temple', 'Pillow', 'Saree'],
    ['Coffee', 'Bench', 'Postman', 'Umbrella'],
    ['Cricket', 'Mango', 'Fan', 'Verandah'],
    ['Grandson', 'Sweets', 'Photo', 'Album'],
    ['Bicycle', 'Newspaper', 'Tea cup', 'Slippers'],
    ['Coconut', 'Banana', 'Rice', 'Curry'],
    ['Doctor', 'Hospital', 'Tablet', 'Glass of water'],
    ['Festival', 'Lamp', 'Flowers', 'Sweets'],
  ];

  static const _memoryDecoys = <String>[
    'Train', 'Cup', 'Photo', 'Bell', 'Map', 'Pillow',
    'Stamp', 'Cake', 'Shoe', 'Hat', 'Plant', 'Phone',
    'Wallet', 'Comb', 'Pen', 'Watch', 'Towel', 'Brush',
    'Slipper', 'Box', 'Pot', 'Gate', 'Tree', 'Soap',
  ];

  // Word entries chosen so the target unscrambles to one clear English word.
  // Decoys are non-anagram common words to avoid ambiguity.
  static const _wordRounds = <Map<String, Object>>[
    {'answer': 'GARDEN', 'decoys': ['MARKET', 'WINDOW']},
    {'answer': 'FAMILY', 'decoys': ['PEOPLE', 'FRIEND']},
    {'answer': 'WINDOW', 'decoys': ['DOCTOR', 'BUTTER']},
    {'answer': 'KITCHEN', 'decoys': ['MORNING', 'JOURNEY']},
    {'answer': 'FRIEND', 'decoys': ['HEALTH', 'MARKET']},
    {'answer': 'COFFEE', 'decoys': ['BUTTER', 'SUMMER']},
    {'answer': 'MORNING', 'decoys': ['EVENING', 'WEATHER']},
    {'answer': 'WEATHER', 'decoys': ['MOUNTAIN', 'JOURNEY']},
    {'answer': 'BUTTER', 'decoys': ['COFFEE', 'PEOPLE']},
    {'answer': 'HEALTH', 'decoys': ['FAMILY', 'MARKET']},
    {'answer': 'TEMPLE', 'decoys': ['SCHOOL', 'STREET']},
    {'answer': 'BICYCLE', 'decoys': ['WEATHER', 'JOURNEY']},
    {'answer': 'TEACHER', 'decoys': ['BROTHER', 'MORNING']},
    {'answer': 'FLOWER', 'decoys': ['GROUND', 'WINTER']},
    {'answer': 'GRANDSON', 'decoys': ['MOUNTAIN', 'EVENING']},
    {'answer': 'SUNSHINE', 'decoys': ['MOUNTAIN', 'GRANDSON']},
    {'answer': 'BIRTHDAY', 'decoys': ['HOSPITAL', 'JOURNEY']},
    {'answer': 'BREAKFAST', 'decoys': ['HOSPITAL', 'BIRTHDAY']},
    {'answer': 'GRANDMA', 'decoys': ['MARKET', 'FRIEND']},
    {'answer': 'CHAPATTI', 'decoys': ['MOUNTAIN', 'BIRTHDAY']},
  ];

  static const _logicRounds = <Map<String, Object>>[
    {
      'question': 'Which of these is used to tell time?',
      'answer': 'Clock',
      'options': ['Clock', 'Pillow', 'Plate'],
    },
    {
      'question': 'Which of these helps you see better in the dark?',
      'answer': 'Torch',
      'options': ['Torch', 'Spoon', 'Scarf'],
    },
    {
      'question': 'Which place is connected with a doctor and nurse?',
      'answer': 'Hospital',
      'options': ['Hospital', 'Mountain', 'Window'],
    },
    {
      'question': 'Which of these do you read?',
      'answer': 'Book',
      'options': ['Book', 'Cup', 'Lamp'],
    },
    {
      'question': 'Which of these grows on a plant?',
      'answer': 'Flower',
      'options': ['Flower', 'Stone', 'Bottle'],
    },
    {
      'question': 'Which of these gives us light during the day?',
      'answer': 'Sun',
      'options': ['Sun', 'Cloud', 'Star'],
    },
    {
      'question': 'Which of these is a fruit?',
      'answer': 'Mango',
      'options': ['Mango', 'Carrot', 'Bread'],
    },
    {
      'question': 'Which of these do you wear on your feet?',
      'answer': 'Shoes',
      'options': ['Shoes', 'Hat', 'Gloves'],
    },
    {
      'question': 'Which of these is something you drink?',
      'answer': 'Tea',
      'options': ['Tea', 'Pencil', 'Brick'],
    },
    {
      'question': 'Which of these is the youngest in a family?',
      'answer': 'Baby',
      'options': ['Baby', 'Grandfather', 'Father'],
    },
    {
      'question': 'Which of these is a vegetable?',
      'answer': 'Potato',
      'options': ['Potato', 'Pillow', 'Pen'],
    },
    {
      'question': 'Which of these comes after Tuesday?',
      'answer': 'Wednesday',
      'options': ['Wednesday', 'Sunday', 'Friday'],
    },
    {
      'question': 'Which of these belongs in the kitchen?',
      'answer': 'Spoon',
      'options': ['Spoon', 'Bicycle', 'Pillow'],
    },
    {
      'question': 'Which of these can fly?',
      'answer': 'Sparrow',
      'options': ['Sparrow', 'Cow', 'Fish'],
    },
    {
      'question': 'Which of these helps you remember a moment?',
      'answer': 'Photograph',
      'options': ['Photograph', 'Soap', 'Spoon'],
    },
    {
      'question': 'Which of these warms a cold morning?',
      'answer': 'Sweater',
      'options': ['Sweater', 'Umbrella', 'Hat'],
    },
    {
      'question': 'Which of these falls from the sky?',
      'answer': 'Rain',
      'options': ['Rain', 'Bricks', 'Spoons'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  void dispose() {
    _memoryHideTimer?.cancel();
    super.dispose();
  }

  int _pickRoundIndex(int length) {
    if (length <= 1) return 0;
    int index;
    do {
      index = _random.nextInt(length);
    } while (index == _lastRoundIndex);
    _lastRoundIndex = index;
    return index;
  }

  void _resetGame() {
    _memoryHideTimer?.cancel();
    switch (widget.type) {
      case MiniGameType.memory:
        final round = _memoryRounds[_pickRoundIndex(_memoryRounds.length)];
        _memorySequence = round;
        _memoryTargetWord = round[_random.nextInt(round.length)];
        final decoys = [..._memoryDecoys]..shuffle(_random);
        final options = <String>{_memoryTargetWord};
        for (final decoy in decoys) {
          if (options.length >= 4) break;
          if (!round.contains(decoy)) options.add(decoy);
        }
        _memoryOptions = options.toList()..shuffle(_random);
        _memoryRevealed = true;
        _memoryHideTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) setState(() => _memoryRevealed = false);
        });
        break;
      case MiniGameType.puzzle:
        final start = 2 + _random.nextInt(20);
        _puzzleNumbers = List<int>.generate(4, (i) => start + i);
        _puzzleAnswer = start + 4;
        final candidates = <int>{
          _puzzleAnswer,
          _puzzleAnswer + 2,
          _puzzleAnswer - 6,
          _puzzleAnswer + 5,
        }..removeWhere(_puzzleNumbers.contains);
        final list = candidates.toList()..shuffle(_random);
        final picks = <int>[_puzzleAnswer];
        for (final v in list) {
          if (picks.length >= 3) break;
          if (v != _puzzleAnswer) picks.add(v);
        }
        picks.shuffle(_random);
        _puzzleOptions = picks;
        break;
      case MiniGameType.word:
        final round = _wordRounds[_pickRoundIndex(_wordRounds.length)];
        _wordAnswer = round['answer']! as String;
        final decoys = List<String>.from(round['decoys']! as List);
        _scrambledWord = _scramble(_wordAnswer);
        final options = [_wordAnswer, ...decoys]..shuffle(_random);
        _wordOptions = options;
        break;
      case MiniGameType.logic:
        final round = _logicRounds[_pickRoundIndex(_logicRounds.length)];
        _logicQuestion = round['question']! as String;
        _logicAnswer = round['answer']! as String;
        _logicOptions = List<String>.from(round['options']! as List)
          ..shuffle(_random);
        break;
    }
    setState(() {
      _feedback = null;
      _feedbackIsSuccess = false;
    });
  }

  String _scramble(String word) {
    if (word.length <= 1) return word;
    final letters = word.split('');
    final original = letters.join();
    String shuffled = original;
    int safety = 0;
    while (shuffled == original && safety < 10) {
      letters.shuffle(_random);
      shuffled = letters.join();
      safety++;
    }
    return shuffled.split('').join(' ');
  }

  void _handleResult(bool correct, {String? success, String? error}) {
    setState(() {
      if (correct) _score += 1;
      _feedback = correct ? (success ?? 'Well done!') : (error ?? 'Not quite — try again.');
      _feedbackIsSuccess = correct;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final config = _configFor(widget.type);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(config.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: colors.background,
        toolbarHeight: 64,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: config.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(config.icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(config.title, style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(config.subtitle, style: TextStyle(color: colors.icon, fontSize: 19, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _ScoreCard(label: 'Score', value: '$_score', colors: colors),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: _resetGame,
                        icon: const Icon(Ionicons.refresh_outline, size: 22),
                        label: const Text('New Round', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGame(colors, config.color),
              if (_feedback != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: (_feedbackIsSuccess
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE57373))
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _feedbackIsSuccess
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE57373),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _feedbackIsSuccess
                            ? Ionicons.checkmark_circle
                            : Ionicons.alert_circle_outline,
                        color: _feedbackIsSuccess
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE57373),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _feedback!,
                          style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGame(AppThemeColors colors, Color accent) {
    switch (widget.type) {
      case MiniGameType.memory:
        return _GameCard(
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _memoryRevealed ? 'Remember these words:' : 'Which word did you see?',
                style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              if (_memoryRevealed) ...[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final item in _memorySequence)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Words will hide in a few seconds…',
                  style: TextStyle(color: colors.icon, fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ] else ...[
                Text(
                  'Tap the word that was on the previous screen.',
                  style: TextStyle(color: colors.icon, fontSize: 19, height: 1.4),
                ),
                const SizedBox(height: 14),
                for (final option in _memoryOptions) ...[
                  _ChoiceButton(
                    label: option,
                    onPressed: () => _handleResult(
                      option == _memoryTargetWord,
                      success: 'Correct! "$_memoryTargetWord" was in the list.',
                      error: 'Not this one. The answer was "$_memoryTargetWord".',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        );
      case MiniGameType.puzzle:
        return _GameCard(
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tap the next number in the pattern.',
                style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Text(
                '${_puzzleNumbers[0]},  ${_puzzleNumbers[1]},  ${_puzzleNumbers[2]},  ${_puzzleNumbers[3]},  ?',
                style: TextStyle(color: colors.text, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'The numbers go up by 1 each time.',
                style: TextStyle(color: colors.icon, fontSize: 18, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final option in _puzzleOptions)
                    SizedBox(
                      width: 96,
                      child: _ChoiceButton(
                        label: '$option',
                        onPressed: () => _handleResult(
                          option == _puzzleAnswer,
                          success: 'Correct! The next number is $_puzzleAnswer.',
                          error: 'Not quite. The next number is $_puzzleAnswer.',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      case MiniGameType.word:
        return _GameCard(
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unscramble these letters:',
                style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _scrambledWord,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accent,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              for (final option in _wordOptions) ...[
                _ChoiceButton(
                  label: option,
                  onPressed: () => _handleResult(
                    option == _wordAnswer,
                    success: 'Correct! The word is $_wordAnswer.',
                    error: 'Not this one. The answer was $_wordAnswer.',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      case MiniGameType.logic:
        return _GameCard(
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _logicQuestion,
                style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
              ),
              const SizedBox(height: 18),
              for (final option in _logicOptions) ...[
                _ChoiceButton(
                  label: option,
                  onPressed: () => _handleResult(
                    option == _logicAnswer,
                    success: 'Correct! $_logicAnswer is the right answer.',
                    error: 'Not quite. The right answer was $_logicAnswer.',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
    }
  }
}

class _GameConfig {
  const _GameConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

_GameConfig _configFor(MiniGameType type) {
  switch (type) {
    case MiniGameType.memory:
      return const _GameConfig(
        title: 'Memory Match',
        subtitle: 'Remember the words, then pick the right one.',
        icon: Ionicons.sparkles_outline,
        color: Color(0xFF4ECDC4),
      );
    case MiniGameType.puzzle:
      return const _GameConfig(
        title: 'Number Trail',
        subtitle: 'Find the next number in a simple pattern.',
        icon: Ionicons.grid_outline,
        color: Color(0xFF45B7D1),
      );
    case MiniGameType.word:
      return const _GameConfig(
        title: 'Word Builder',
        subtitle: 'Unscramble the letters to find the word.',
        icon: Ionicons.text_outline,
        color: Color(0xFF96CEB4),
      );
    case MiniGameType.logic:
      return const _GameConfig(
        title: 'Logic Pick',
        subtitle: 'Pick the answer that fits best.',
        icon: Ionicons.calculator_outline,
        color: Color(0xFFFFC857),
      );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.colors, required this.child});

  final AppThemeColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.icon.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final String value;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: colors.tint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: colors.icon, fontSize: 14)),
          Text(value, style: TextStyle(color: colors.text, fontSize: 26, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
