import 'package:pet_social_flutter/models/post.dart';

import 'explore_recipe.dart';
import 'models.dart';

class ExploreData {
  final List<ExploreRecipe> todayRecipes;
  final List<Post> friendPosts;

  ExploreData(
      this.todayRecipes,
      this.friendPosts,
      );
}