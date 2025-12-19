class Item {
  final String id;
  final String name;
  final ItemCategory category;
  final String additionalInfo;
  final String icon;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.additionalInfo,
    required this.icon,
  });

  factory Item.fromFirestore(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      name: data['name'] as String,
      category: (data['category'] ?? '') as ItemCategory,
      additionalInfo: (data['additionalInfo'] ?? '') as String,
      icon: (data['icon'] ?? '') as String,
    );
  }
}

enum ItemCategory {
  fruitVegetables,
  bakery,
  dairyEggs,
  meatSausage,
  beverages,
  staples,
  frozen,
  canned,
  snacksSweets,
  spicesIngredients,
  breakfastSpreads,
  readyMeals,
  householdCleaning,
  personalCare,
  drugstoreHealth,
  babyKids,
  petSupplies,
  officeSupplies,
  electronics,
  other,
}

const itemCategoryLabels = {
  ItemCategory.fruitVegetables: 'Obst & Gemüse',
  ItemCategory.bakery: 'Backwaren',
  ItemCategory.dairyEggs: 'Milchprodukte & Eier',
  ItemCategory.meatSausage: 'Fleisch & Wurst',
  ItemCategory.beverages: 'Getränke',
  ItemCategory.staples: 'Grundnahrungsmittel',
  ItemCategory.frozen: 'Tiefkühlprodukte',
  ItemCategory.canned: 'Konserven & Gläser',
  ItemCategory.snacksSweets: 'Snacks & Süßigkeiten',
  ItemCategory.spicesIngredients: 'Gewürze & Zutaten',
  ItemCategory.breakfastSpreads: 'Frühstück & Aufstriche',
  ItemCategory.readyMeals: 'Fertiggerichte',
  ItemCategory.householdCleaning: 'Haushalt & Reinigung',
  ItemCategory.personalCare: 'Körperpflege & Kosmetik',
  ItemCategory.drugstoreHealth: 'Drogerie & Gesundheit',
  ItemCategory.babyKids: 'Baby & Kinder',
  ItemCategory.petSupplies: 'Tierbedarf',
  ItemCategory.officeSupplies: 'Büro & Schreibwaren',
  ItemCategory.electronics: 'Elektro & Zubehör',
  ItemCategory.other: 'Sonstiges',
};
