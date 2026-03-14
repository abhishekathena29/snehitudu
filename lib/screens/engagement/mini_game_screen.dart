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
  int? _memoryAnswer;
  List<String> _memorySequence = const [];
  int _sequenceNext = 0;
  List<int> _puzzleNumbers = const [];
  List<int> _puzzleOptions = const [];
  int _wordAnswerIndex = 0;
  String _scrambledWord = '';
  List<String> _wordOptions = const [];
  int _logicAnswerIndex = 0;
  String _logicQuestion = '';
  List<String> _logicOptions = const [];

  static const _memoryBank = [
    ['Tea', 'Book', 'Rose', 'Lamp'],
    ['Mango', 'Clock', 'Chair', 'Moon'],
    ['River', 'Bread', 'Leaf', 'Bird'],
  ];

  static const _wordBank = [
    {'answer': 'SMILE', 'options': ['SMILE', 'MILES', 'SLIME']},
    {'answer': 'BRAIN', 'options': ['BRAIN', 'BINARY', 'BROOM']},
    {'answer': 'GARDEN', 'options': ['GARDEN', 'DANGER', 'RANGED']},
  ];

  static const _logicBank = [
    {
      'question': 'Which one is used to tell time?',
      'options': ['Clock', 'Pillow', 'Plate'],
      'answerIndex': 0,
    },
    {
      'question': 'Which item helps you see better in the dark?',
      'options': ['Torch', 'Spoon', 'Scarf'],
      'answerIndex': 0,
    },
    {
      'question': 'Which word belongs with doctor and nurse?',
      'options': ['Hospital', 'Mountain', 'Window'],
      'answerIndex': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    switch (widget.type) {
      case MiniGameType.memory:
        final round = _memoryBank[_random.nextInt(_memoryBank.length)];
        _memorySequence = round;
        _memoryAnswer = _random.nextInt(round.length);
        break;
      case MiniGameType.puzzle:
        _sequenceNext = 7 + _random.nextInt(8);
        _puzzleNumbers = List<int>.generate(4, (index) => _sequenceNext - 4 + index);
        _puzzleOptions = [_sequenceNext, _sequenceNext + 2, _sequenceNext - 1]..shuffle(_random);
        break;
      case MiniGameType.word:
        final round = _wordBank[_random.nextInt(_wordBank.length)];
        final answer = round['answer']! as String;
        _scrambledWord = (answer.split('')..shuffle(_random)).join(' ');
        _wordOptions = List<String>.from(round['options']! as List<dynamic>);
        _wordAnswerIndex = _wordOptions.indexOf(answer);
        break;
      case MiniGameType.logic:
        final round = _logicBank[_random.nextInt(_logicBank.length)];
        _logicQuestion = round['question']! as String;
        _logicOptions = List<String>.from(round['options']! as List<dynamic>);
        _logicAnswerIndex = round['answerIndex']! as int;
        break;
    }
    setState(() => _feedback = null);
  }

  void _handleResult(bool correct, {String? success, String? error}) {
    setState(() {
      if (correct) {
        _score += 1;
      }
      _feedback = correct ? (success ?? 'Correct') : (error ?? 'Try again');
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final config = _configFor(widget.type);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(config.title),
        backgroundColor: colors.background,
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
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: config.color,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(config.icon, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(config.title, style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(config.subtitle, style: TextStyle(color: colors.icon, fontSize: 14, height: 1.4)),
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
                    child: OutlinedButton.icon(
                      onPressed: _resetGame,
                      icon: const Icon(Ionicons.refresh_outline),
                      label: const Text('New Round'),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.tint.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _feedback!,
                    style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w600),
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
        final hiddenIndex = _memoryAnswer ?? 0;
        return _GameCard(
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Remember these items:', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final item in _memorySequence)
                    Chip(
                      label: Text(item),
                      backgroundColor: accent.withOpacity(0.14),
                      labelStyle: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Which word did you just see?', style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (int index = 0; index < _memorySequence.length; index++)
                    _ChoiceButton(
                      label: _memorySequence[index],
                      onPressed: () => _handleResult(
                        index == hiddenIndex,
                        success: 'Well done. ${_memorySequence[hiddenIndex]} was one of the memory words.',
                        error: 'Not quite. Try a new round and take a bit more time.',
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      case MiniGameType.puzzle:
        return _GameCard(
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tap the missing number in the pattern.', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                '${_puzzleNumbers[0]}, ${_puzzleNumbers[1]}, ${_puzzleNumbers[2]}, ${_puzzleNumbers[3]}, ?',
                style: TextStyle(color: colors.text, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final option in _puzzleOptions)
                    _ChoiceButton(
                      label: '$option',
                      onPressed: () => _handleResult(
                        option == _sequenceNext,
                        success: 'Correct. The next number is $_sequenceNext.',
                        error: 'That breaks the pattern. The numbers go up by 1.',
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
              Text('Unscramble this word:', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(_scrambledWord, style: TextStyle(color: accent, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 16),
              for (int index = 0; index < _wordOptions.length; index++) ...[
                _ChoiceButton(
                  label: _wordOptions[index],
                  onPressed: () => _handleResult(
                    index == _wordAnswerIndex,
                    success: 'Correct. ${_wordOptions[index]} is the right word.',
                    error: 'Not this one. Look for the most natural word.',
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
              Text('Choose the best answer:', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(_logicQuestion, style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.w600, height: 1.4)),
              const SizedBox(height: 16),
              for (int index = 0; index < _logicOptions.length; index++) ...[
                _ChoiceButton(
                  label: _logicOptions[index],
                  onPressed: () => _handleResult(
                    index == _logicAnswerIndex,
                    success: 'Correct. ${_logicOptions[index]} fits best.',
                    error: 'That does not match the clue. Try another option.',
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
        subtitle: 'Short rounds with familiar words and gentle pacing.',
        icon: Ionicons.sparkles_outline,
        color: Color(0xFF4ECDC4),
      );
    case MiniGameType.puzzle:
      return const _GameConfig(
        title: 'Number Trail',
        subtitle: 'Spot the next number in a simple sequence.',
        icon: Ionicons.grid_outline,
        color: Color(0xFF45B7D1),
      );
    case MiniGameType.word:
      return const _GameConfig(
        title: 'Word Builder',
        subtitle: 'Unscramble a common word with clear choices.',
        icon: Ionicons.text_outline,
        color: Color(0xFF96CEB4),
      );
    case MiniGameType.logic:
      return const _GameConfig(
        title: 'Logic Pick',
        subtitle: 'One clear question. One best answer.',
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
        border: Border.all(color: colors.icon.withOpacity(0.28)),
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.tint.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: colors.icon, fontSize: 12)),
          Text(value, style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
