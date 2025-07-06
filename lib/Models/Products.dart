class Product{
  final int iD;
  final String name;
  final String brand;
  final List<String> category;
  final List<String> size;
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
  final int selectedSize = 0;

  static Map<String, Map<String, List<String>>> categories = {};

  Product({
    required this.iD,
    required this.name,
    required this.brand,
    required this.category,
    required this.size,
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

  factory Product.fromJson(Map<String, dynamic> json, int id){
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
      iD: id,
      name: json['name'],
      brand: json['brand'],
      category: catList,
      size: List<String>.from(json['size']),
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