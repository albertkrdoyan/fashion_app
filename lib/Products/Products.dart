class Product{
  final String name;
  final List<String> category;
  final String extension;
  final int imgCount;
  final String location;
  final num price;
  final String currency;
  final List<String> outerShell;
  final List<String> lining;
  final String description;
  final String care;
  final List<String> info;
  final String origin;

  static Map<String, Map<String, List<String>>> categories = {};

  Product({
    required this.name,
    required this.category,
    required this.extension,
    required this.imgCount,
    required this.location,
    required this.price,
    required this.currency,
    required this.outerShell,
    required this.lining,
    required this.description,
    required this.care,
    required this.info,
    required this.origin});

  factory Product.fromJson(Map<String, dynamic> json){
    final catList = List<String>.from(json['category']);
    // if (!Categories[catList[0]]?[catList[1]]!.contains(catList[2]))

    if (!categories.containsKey(catList[0])){
      categories[catList[0]] = {};
    }
    if (!categories[catList[0]]!.containsKey(catList[1])){
      categories[catList[0]]?[catList[1]] = [];
    }
    if (!categories[catList[0]]![catList[1]]!.contains(catList[2])) {
      categories[catList[0]]![catList[1]]?.add(catList[2]);
    }

    return Product(
      name: json['name'],
      category: catList,
      extension: json['extension'][0],
      imgCount: json['extension'][1],
      location: json['location'],
      price: json['price'],
      currency: json['currency'],
      outerShell: List<String>.from(json['Composition']['OUTER SHELL']),
      lining: List<String>.from(json['Composition']['LINING']),
      description: json['Composition']['Description'],
      care: json['Care'],
      info: List<String>.from(json['info']),
      origin: json['Origin']
    );
  }
}