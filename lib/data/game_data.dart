class GameData {
  static const List<String> countries = [
    'france', 'brazil', 'canada', 'japan', 'egypt', 'india', 'mexico', 'italy',
    'china', 'spain', 'russia', 'germany', 'australia', 'kenya', 'thailand',
    'peru', 'greece', 'turkey', 'sweden', 'vietnam', 'morocco', 'argentina',
    'nigeria', 'portugal', 'ireland', 'norway', 'poland', 'denmark', 'finland',
    'belgium'
  ];

  static const List<String> animals = [
    'tiger', 'panda', 'eagle', 'shark', 'zebra', 'giraffe', 'monkey', 'dolphin',
    'koala', 'penguin', 'elephant', 'kangaroo', 'leopard', 'gorilla', 'turtle',
    'rabbit', 'squirrel', 'raccoon', 'hedgehog', 'flamingo', 'octopus', 'cheetah',
    'jaguar', 'ostrich', 'peacock', 'walrus', 'buffalo', 'badger', 'hamster',
    'parrot'
  ];

  static const List<String> foods = [
    'pizza', 'burger', 'sushi', 'pasta', 'taco', 'curry', 'salad', 'steak',
    'pancake', 'waffle', 'donut', 'cookie', 'muffin', 'bread', 'cheese',
    'noodle', 'sandwich', 'burrito', 'lasagna', 'risotto', 'croissant', 'pretzel',
    'dumpling', 'kebab', 'falafel', 'hummus', 'paella', 'ramen', 'crepe',
    'brownie'
  ];

  static List<String> getWordsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'countries':
        return countries;
      case 'animals':
        return animals;
      case 'foods':
        return foods;
      default:
        return countries; // Default to countries
    }
  }
}
