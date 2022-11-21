import 'package:flutter/material.dart';

class Gigs {
  Gigs(
      {this.recipeName = '',
      this.recipeImage = '',
      this.recipeMaker = '',
      this.startColor,
      this.endColor});

  String recipeName;
  String recipeImage;
  String recipeMaker;
  Color? startColor;
  Color? endColor;
}

var gigs = [
  Gigs(
    recipeName: 'Big ban low angle, Great Bell of the Great Clock',
    recipeImage: 'pexels6.jpeg',
    recipeMaker: 'Foodie Yuki',
    startColor: const Color(0xFF424242),
    endColor: const Color(0xFF616161),
  ),
  Gigs(
    recipeName: 'Logo & Brand Identity, Art & Illustration',
    recipeImage: 'img-easy-teriyaki.webp',
    recipeMaker: 'Marianne Turner',
    startColor: const Color(0xFF621e14),
    endColor: const Color(0xFFd13b10),
  ),
  Gigs(
    recipeName: 'Marketing Strategy, Social Media Marketing, Local SEO',
    recipeImage: 'img-easy-teriyaki.webp',
    recipeMaker: 'Jennifer Joyce',
    startColor: const Color(0xFFe18b41),
    endColor: const Color(0xFFc7c73d),
  ),
  Gigs(
    recipeName: 'Easy classic lasagne',
    recipeImage: 'img-thai-fried-prawn.webp',
    recipeMaker: 'Angela Boggiano',
    startColor: const Color(0xFFaf781d),
    endColor: const Color(0xFFd6a651),
  ),
  Gigs(
    recipeName: 'Easy teriyaki chicken',
    recipeImage: 'img-easy-teriyaki.webp',
    recipeMaker: 'Esther Clark',
    startColor: const Color(0xFF9a9d9a),
    endColor: const Color(0xFFb9b2b5),
  ),
  Gigs(
    recipeName: 'Easy chocolate fudge cake',
    recipeImage: 'img-chocolate-fudge-cake.webp',
    recipeMaker: 'Member recipe by misskay',
    startColor: const Color(0xFF2e0f07),
    endColor: const Color(0xFF653424),
  ),
  Gigs(
    recipeName: 'One-pan spaghetti with nduja, fennel & olives',
    recipeImage: 'img-one-pan-spaghetti.webp',
    recipeMaker: 'Cassie Best',
    startColor: const Color(0xFF8b1d07),
    endColor: const Color(0xFFee882d),
  ),
  Gigs(
    recipeName: 'Easy pancakes',
    recipeImage: 'img-easy-pancake.webp',
    recipeMaker: 'Cassie Best',
    startColor: const Color(0xFFa1783c),
    endColor: const Color(0xFFf3dc37),
  ),
  Gigs(
    recipeName: 'Easy chicken fajitas',
    recipeImage: 'img-chicken-fajitas.webp',
    recipeMaker: 'Steven Morris',
    startColor: const Color(0xFF3e4824),
    endColor: const Color(0xFF5da6a6),
  ),
  Gigs(
    recipeName: 'Easy vegetable lasagne',
    recipeImage: 'img-easy-vegetable-lasagne.webp',
    recipeMaker: 'Emma Lewis',
    startColor: const Color(0xFF914322),
    endColor: const Color(0xFFbf802f),
  ),
  Gigs(
    recipeName: 'Thai fried prawn & pineapple rice',
    recipeImage: 'img-thai-fried-prawn.webp',
    recipeMaker: 'Good Food Team',
    startColor: const Color(0xFF5b8e38),
    endColor: const Color(0xFF94bf77),
  ),
];