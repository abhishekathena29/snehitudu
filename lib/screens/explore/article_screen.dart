import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../theme/app_theme.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final article = _articles[articleId] ?? _articles['1']!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Ionicons.arrow_back, color: colors.text),
                  ),
                  Text('Article', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => _showShareDialog(context),
                    icon: Icon(Ionicons.share_social_outline, color: colors.text),
                  ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.tint.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(article.category, style: TextStyle(color: colors.tint, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${article.author} • ${article.publishDate} • ${article.readTime}',
                      style: TextStyle(color: colors.icon, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      article.content,
                      style: TextStyle(color: colors.text, fontSize: 14, height: 1.6),
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

  void _showShareDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share'),
        content: const Text('Sharing feature coming soon!'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }
}

class _ArticleData {
  const _ArticleData({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.content,
    required this.author,
    required this.publishDate,
  });

  final String id;
  final String title;
  final String category;
  final String readTime;
  final String content;
  final String author;
  final String publishDate;
}

const Map<String, _ArticleData> _articles = {
  '1': _ArticleData(
    id: '1',
    title: 'New Study Shows Benefits of Daily Walking for Seniors',
    category: 'Health',
    readTime: '3 min read',
    author: 'Dr. Sarah Johnson',
    publishDate: 'March 15, 2024',
    content: '''A groundbreaking study published in the Journal of Geriatric Medicine has revealed that seniors who engage in daily walking routines experience significant improvements in both physical and cognitive health.

The research, conducted over a two-year period with 500 participants aged 65 and older, found that walking just 30 minutes per day can lead to:

• 25% improvement in cardiovascular health
• 20% enhancement in memory and cognitive function
• 30% reduction in fall risk
• 15% improvement in mood and overall well-being

Dr. Sarah Johnson, lead researcher at the University of Health Sciences, explains: "Walking is one of the most accessible forms of exercise for seniors. It requires no special equipment, can be done anywhere, and provides tremendous health benefits."

The study participants were divided into two groups: one that walked 30 minutes daily and a control group that maintained their usual activity levels. After six months, the walking group showed measurable improvements in blood pressure, cholesterol levels, and cognitive test scores.

"Even participants who had never exercised regularly before saw benefits within the first few weeks," says Dr. Johnson. "The key is consistency - making walking a daily habit."

The research also highlighted the social benefits of walking, as many participants chose to walk with friends or join walking groups. This social aspect contributed to improved mental health and reduced feelings of isolation.

For seniors looking to start a walking routine, experts recommend:

1. Start with 10-15 minutes and gradually increase
2. Choose safe, well-lit paths
3. Walk with a friend or family member when possible
4. Wear comfortable, supportive shoes
5. Stay hydrated and listen to your body

The study's findings support the World Health Organization's recommendation that adults aged 65 and older should engage in at least 150 minutes of moderate-intensity physical activity per week.

"This research provides strong evidence that simple, daily walking can significantly improve the quality of life for seniors," concludes Dr. Johnson. "It's never too late to start, and the benefits are immediate and long-lasting."''',
  ),
  '2': _ArticleData(
    id: '2',
    title: 'Spring Gardening Tips for Beginners',
    category: 'Gardening',
    readTime: '5 min read',
    author: 'Master Gardener Maria Rodriguez',
    publishDate: 'March 12, 2024',
    content: '''Spring is the perfect time to start your gardening journey! Whether you have a large backyard or just a small balcony, these beginner-friendly tips will help you create a thriving garden.

Getting Started: Planning Your Garden

Before you start digging, take some time to plan your garden space. Consider these factors:

• Sunlight: Most vegetables need 6-8 hours of direct sunlight
• Soil quality: Test your soil or use raised beds with quality potting mix
• Water access: Ensure you can easily water your plants
• Space: Start small - you can always expand later

Essential Tools for Beginners

You don't need expensive equipment to start gardening. Here are the basics:

• Hand trowel for digging small holes
• Garden gloves to protect your hands
• Watering can or hose
• Pruning shears for trimming
• Garden fork for turning soil

Best Plants for Beginners

Some plants are more forgiving for new gardeners:

Vegetables:
• Tomatoes - Plant in full sun, water regularly
• Lettuce - Grows quickly, perfect for containers
• Radishes - Ready to harvest in just 3-4 weeks
• Green beans - Easy to grow and very productive

Herbs:
• Basil - Great for cooking, grows well in pots
• Mint - Hardy and spreads easily
• Rosemary - Drought-tolerant once established
• Parsley - Biennial, will last two years

Flowers:
• Marigolds - Repel pests, easy to grow
• Zinnias - Attract butterflies, long blooming season
• Sunflowers - Fast-growing and impressive
• Pansies - Cool-weather flowers, great for spring

Spring Planting Schedule

Early Spring (March-April):
• Peas, spinach, lettuce, radishes
• Cool-weather flowers like pansies

Mid-Spring (April-May):
• Tomatoes, peppers, beans
• Annual flowers like marigolds

Late Spring (May-June):
• Warm-weather crops like cucumbers, squash
• Heat-loving flowers

Watering Tips

• Water in the morning to reduce evaporation
• Water at the base of plants, not the leaves
• Check soil moisture with your finger
• Most plants need 1-2 inches of water per week

Common Beginner Mistakes to Avoid

1. Overwatering - Let soil dry slightly between waterings
2. Planting too close together - Follow spacing guidelines
3. Ignoring pests - Check plants regularly for problems
4. Not using mulch - Helps retain moisture and prevent weeds
5. Giving up too soon - Gardening is a learning process

The Joy of Gardening

Beyond the practical benefits of growing your own food, gardening offers numerous health benefits:

• Physical exercise through digging, planting, and weeding
• Stress relief and mental well-being
• Connection with nature
• Sense of accomplishment
• Fresh air and vitamin D from sunlight

Remember, every gardener was once a beginner. Don't be afraid to make mistakes - they're part of the learning process. Start small, be patient, and enjoy watching your garden grow!''',
  ),
  '3': _ArticleData(
    id: '3',
    title: 'Easy Mediterranean Recipes for Heart Health',
    category: 'Cooking',
    readTime: '4 min read',
    author: 'Chef Antonio Martinez',
    publishDate: 'March 10, 2024',
    content: '''The Mediterranean diet has long been celebrated for its heart-healthy benefits. Rich in olive oil, fresh vegetables, whole grains, and lean proteins, this eating pattern can help reduce the risk of heart disease and promote overall wellness.

Why Mediterranean Cuisine is Good for Your Heart

The Mediterranean diet emphasizes:

• Healthy fats from olive oil and nuts
• Abundant fruits and vegetables
• Whole grains instead of refined carbohydrates
• Lean proteins like fish and legumes
• Moderate consumption of dairy and wine
• Limited red meat and processed foods

These components work together to support cardiovascular health by reducing inflammation, improving cholesterol levels, and maintaining healthy blood pressure.

Simple Mediterranean Recipes to Try

1. Greek Salad with Homemade Dressing

Ingredients:
• 2 cups mixed greens
• 1 cucumber, sliced
• 1 cup cherry tomatoes, halved
• 1/2 red onion, thinly sliced
• 1/2 cup feta cheese, crumbled
• 1/4 cup kalamata olives
• 2 tbsp extra virgin olive oil
• 1 tbsp red wine vinegar
• 1 tsp dried oregano
• Salt and pepper to taste

Instructions:
Toss greens, cucumber, tomatoes, onion, feta, and olives in a bowl. Whisk olive oil, vinegar, oregano, salt, and pepper. Drizzle over salad and serve.

2. Baked Salmon with Herbs

Ingredients:
• 4 salmon fillets
• 2 tbsp olive oil
• 2 cloves garlic, minced
• 1 lemon, sliced
• 1 tbsp fresh dill, chopped
• Salt and pepper

Instructions:
Preheat oven to 375°F (190°C). Place salmon on a baking sheet, drizzle with olive oil, garlic, salt, and pepper. Top with lemon slices and dill. Bake for 15-18 minutes.

Remember to enjoy meals with friends and family, stay active, and make hydration part of your daily routine. Mediterranean living is as much about lifestyle as it is about food.''',
  ),
};
