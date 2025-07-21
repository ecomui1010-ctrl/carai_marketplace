import 'dart:math';

class CarDataService {
  static final CarDataService _instance = CarDataService._internal();
  factory CarDataService() => _instance;
  CarDataService._internal();

  final Random _random = Random();

  // Comprehensive car database
  static const Map<String, Map<String, dynamic>> _carDatabase = {
    'Toyota': {
      'models': [
        'Camry',
        'Corolla',
        'RAV4',
        'Highlander',
        'Prius',
        'Sienna',
        'Tacoma',
        'Tundra',
        'Avalon',
        'Venza'
      ],
      'segments': ['Sedan', 'SUV', 'Hybrid', 'Minivan', 'Truck'],
      'reliability': 9.2,
      'avgPrice': 32000,
    },
    'Honda': {
      'models': [
        'Accord',
        'Civic',
        'CR-V',
        'Pilot',
        'Odyssey',
        'Ridgeline',
        'Passport',
        'HR-V',
        'Insight',
        'Fit'
      ],
      'segments': ['Sedan', 'SUV', 'Minivan', 'Truck'],
      'reliability': 9.0,
      'avgPrice': 30000,
    },
    'BMW': {
      'models': [
        '3 Series',
        '5 Series',
        'X3',
        'X5',
        'X1',
        'X7',
        'M3',
        'M5',
        'i4',
        'iX'
      ],
      'segments': ['Sedan', 'SUV', 'Electric', 'Luxury'],
      'reliability': 7.8,
      'avgPrice': 55000,
    },
    'Mercedes-Benz': {
      'models': [
        'C-Class',
        'E-Class',
        'S-Class',
        'GLC',
        'GLE',
        'GLS',
        'A-Class',
        'CLA',
        'EQC',
        'EQS'
      ],
      'segments': ['Sedan', 'SUV', 'Electric', 'Luxury'],
      'reliability': 7.5,
      'avgPrice': 58000,
    },
    'Audi': {
      'models': [
        'A3',
        'A4',
        'A6',
        'Q3',
        'Q5',
        'Q7',
        'Q8',
        'RS3',
        'RS4',
        'e-tron'
      ],
      'segments': ['Sedan', 'SUV', 'Electric', 'Luxury'],
      'reliability': 7.7,
      'avgPrice': 52000,
    },
    'Tesla': {
      'models': ['Model 3', 'Model Y', 'Model S', 'Model X', 'Cybertruck'],
      'segments': ['Electric', 'SUV', 'Truck'],
      'reliability': 8.1,
      'avgPrice': 65000,
    },
    'Ford': {
      'models': [
        'F-150',
        'Mustang',
        'Explorer',
        'Escape',
        'Edge',
        'Expedition',
        'Ranger',
        'Bronco',
        'Mach-E',
        'Transit'
      ],
      'segments': ['Truck', 'SUV', 'Electric', 'Van'],
      'reliability': 8.2,
      'avgPrice': 38000,
    },
    'Chevrolet': {
      'models': [
        'Silverado',
        'Equinox',
        'Malibu',
        'Tahoe',
        'Suburban',
        'Corvette',
        'Camaro',
        'Bolt',
        'Traverse',
        'Colorado'
      ],
      'segments': ['Truck', 'SUV', 'Sedan', 'Electric', 'Sports'],
      'reliability': 8.0,
      'avgPrice': 36000,
    },
    'Nissan': {
      'models': [
        'Altima',
        'Sentra',
        'Rogue',
        'Murano',
        'Pathfinder',
        'Frontier',
        'Titan',
        'Leaf',
        'Ariya',
        '370Z'
      ],
      'segments': ['Sedan', 'SUV', 'Truck', 'Electric', 'Sports'],
      'reliability': 8.3,
      'avgPrice': 33000,
    },
    'Hyundai': {
      'models': [
        'Elantra',
        'Sonata',
        'Tucson',
        'Santa Fe',
        'Palisade',
        'Kona',
        'Ioniq 5',
        'Genesis G90',
        'Veloster',
        'Accent'
      ],
      'segments': ['Sedan', 'SUV', 'Electric', 'Luxury'],
      'reliability': 8.4,
      'avgPrice': 31000,
    },
    'Kia': {
      'models': [
        'Forte',
        'Optima',
        'Sportage',
        'Sorento',
        'Telluride',
        'Soul',
        'EV6',
        'Stinger',
        'Rio',
        'Carnival'
      ],
      'segments': ['Sedan', 'SUV', 'Electric', 'Minivan'],
      'reliability': 8.3,
      'avgPrice': 29000,
    },
    'Subaru': {
      'models': [
        'Outback',
        'Forester',
        'Ascent',
        'Legacy',
        'Impreza',
        'Crosstrek',
        'WRX',
        'BRZ',
        'Solterra',
        'Wilderness'
      ],
      'segments': ['SUV', 'Sedan', 'Sports', 'Electric'],
      'reliability': 8.6,
      'avgPrice': 35000,
    },
    'Mazda': {
      'models': [
        'Mazda3',
        'Mazda6',
        'CX-5',
        'CX-9',
        'CX-30',
        'CX-90',
        'MX-5 Miata',
        'CX-50',
        'Mazda2',
        'MX-30'
      ],
      'segments': ['Sedan', 'SUV', 'Sports', 'Electric'],
      'reliability': 8.5,
      'avgPrice': 32000,
    },
    'Volkswagen': {
      'models': [
        'Jetta',
        'Passat',
        'Tiguan',
        'Atlas',
        'Golf',
        'Arteon',
        'ID.4',
        'Taos',
        'Beetle',
        'CC'
      ],
      'segments': ['Sedan', 'SUV', 'Electric', 'Hatchback'],
      'reliability': 7.9,
      'avgPrice': 34000,
    },
    'Lexus': {
      'models': ['ES', 'IS', 'LS', 'RX', 'GX', 'LX', 'NX', 'UX', 'LC', 'RC'],
      'segments': ['Sedan', 'SUV', 'Luxury', 'Sports'],
      'reliability': 9.1,
      'avgPrice': 48000,
    },
    'Acura': {
      'models': [
        'ILX',
        'TLX',
        'RLX',
        'RDX',
        'MDX',
        'NSX',
        'Integra',
        'ZDX',
        'TSX',
        'RSX'
      ],
      'segments': ['Sedan', 'SUV', 'Sports', 'Luxury'],
      'reliability': 8.7,
      'avgPrice': 42000,
    },
    'Infiniti': {
      'models': [
        'Q50',
        'Q60',
        'QX50',
        'QX60',
        'QX80',
        'Q70',
        'QX30',
        'G35',
        'FX35',
        'M35'
      ],
      'segments': ['Sedan', 'SUV', 'Sports', 'Luxury'],
      'reliability': 8.1,
      'avgPrice': 45000,
    },
    'Cadillac': {
      'models': [
        'ATS',
        'CTS',
        'XTS',
        'XT4',
        'XT5',
        'XT6',
        'Escalade',
        'CT4',
        'CT5',
        'Lyriq'
      ],
      'segments': ['Sedan', 'SUV', 'Luxury', 'Electric'],
      'reliability': 7.6,
      'avgPrice': 55000,
    },
    'Lincoln': {
      'models': [
        'MKZ',
        'Continental',
        'Corsair',
        'Nautilus',
        'Aviator',
        'Navigator',
        'MKC',
        'MKX',
        'MKT',
        'Star'
      ],
      'segments': ['Sedan', 'SUV', 'Luxury'],
      'reliability': 7.8,
      'avgPrice': 50000,
    },
    'Porsche': {
      'models': [
        '911',
        'Cayenne',
        'Macan',
        'Panamera',
        'Taycan',
        'Boxster',
        'Cayman',
        '718',
        'Carrera',
        'Turbo'
      ],
      'segments': ['Sports', 'SUV', 'Electric', 'Luxury'],
      'reliability': 8.0,
      'avgPrice': 85000,
    },
  };

  static const List<String> _fuelTypes = [
    'Gasoline',
    'Hybrid',
    'Electric',
    'Diesel',
    'Plug-in Hybrid'
  ];

  static const List<String> _transmissions = [
    'Automatic',
    'Manual',
    'CVT',
    '8-Speed Automatic',
    '10-Speed Automatic',
    'Dual-Clutch',
  ];

  static const List<String> _colors = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Green',
    'Brown',
    'Gold',
    'Orange',
    'Purple',
    'Yellow'
  ];

  static const List<String> _conditions = [
    'Excellent',
    'Very Good',
    'Good',
    'Fair',
    'Poor'
  ];

  static const List<String> _features = [
    'Leather Seats',
    'Sunroof',
    'Navigation System',
    'Backup Camera',
    'Bluetooth',
    'Heated Seats',
    'All-Wheel Drive',
    'Apple CarPlay',
    'Android Auto',
    'Keyless Entry',
    'Premium Sound System',
    'Wireless Charging',
    'Lane Departure Warning',
    'Collision Detection',
    'Adaptive Cruise Control',
    'Parking Sensors',
    'Third Row Seating',
    'Towing Package',
    'Sport Package',
    'Premium Package'
  ];

  // Get all available makes
  List<String> getAllMakes() {
    return _carDatabase.keys.toList()..sort();
  }

  // Get models for a specific make
  List<String> getModelsForMake(String make) {
    if (!_carDatabase.containsKey(make)) return [];
    return List<String>.from(_carDatabase[make]!['models']);
  }

  // Get years range
  List<int> getAvailableYears() {
    final currentYear = DateTime.now().year;
    return List.generate(25, (index) => currentYear - index);
  }

  // Get fuel types
  List<String> getFuelTypes() {
    return List<String>.from(_fuelTypes);
  }

  // Get transmissions
  List<String> getTransmissions() {
    return List<String>.from(_transmissions);
  }

  // Get colors
  List<String> getColors() {
    return List<String>.from(_colors);
  }

  // Get conditions
  List<String> getConditions() {
    return List<String>.from(_conditions);
  }

  // Get random features
  List<String> getRandomFeatures({int count = 5}) {
    final shuffled = List<String>.from(_features)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  // Generate comprehensive car listing
  Map<String, dynamic> generateCarListing({
    String? make,
    String? model,
    int? year,
  }) {
    final selectedMake = make ?? _getRandomMake();
    final selectedModel = model ?? _getRandomModel(selectedMake);
    final selectedYear = year ?? _getRandomYear();

    final basePrice =
        _calculateBasePrice(selectedMake, selectedModel, selectedYear);
    final mileage = _getRandomMileage(selectedYear);
    final condition = _getRandomCondition();

    return {
      'id': _generateId(),
      'make': selectedMake,
      'model': selectedModel,
      'year': selectedYear,
      'price': _adjustPriceForCondition(basePrice, condition, mileage),
      'mileage': mileage,
      'condition': condition,
      'fuelType': _getRandomFuelType(),
      'transmission': _getRandomTransmission(),
      'color': _getRandomColor(),
      'features': getRandomFeatures(),
      'location': _getRandomLocation(),
      'images': _generateImageUrls(selectedMake, selectedModel),
      'description':
          _generateDescription(selectedMake, selectedModel, selectedYear),
      'seller': _generateSellerInfo(),
      'specs': _generateSpecs(selectedMake, selectedModel),
      'history': _generateHistory(),
      'financing': _generateFinancingOptions(basePrice),
      'reliability': _carDatabase[selectedMake]?['reliability'] ?? 8.0,
      'listedDate':
          DateTime.now().subtract(Duration(days: _random.nextInt(30))),
      'views': _random.nextInt(500) + 50,
      'saves': _random.nextInt(100) + 10,
    };
  }

  // Generate multiple car listings
  List<Map<String, dynamic>> generateMultipleListings(int count) {
    return List.generate(count, (index) => generateCarListing());
  }

  // Search functionality
  List<Map<String, dynamic>> searchCars({
    String? make,
    String? model,
    int? minYear,
    int? maxYear,
    int? minPrice,
    int? maxPrice,
    String? fuelType,
    String? transmission,
    String? location,
    int count = 20,
  }) {
    final cars = generateMultipleListings(count * 2);

    return cars
        .where((car) {
          if (make != null && car['make'] != make) return false;
          if (model != null && car['model'] != model) return false;
          if (minYear != null && car['year'] < minYear) return false;
          if (maxYear != null && car['year'] > maxYear) return false;
          if (minPrice != null && car['price'] < minPrice) return false;
          if (maxPrice != null && car['price'] > maxPrice) return false;
          if (fuelType != null && car['fuelType'] != fuelType) return false;
          if (transmission != null && car['transmission'] != transmission)
            return false;
          if (location != null &&
              !car['location'].toString().contains(location)) return false;
          return true;
        })
        .take(count)
        .toList();
  }

  // Private helper methods
  String _getRandomMake() {
    final makes = _carDatabase.keys.toList();
    return makes[_random.nextInt(makes.length)];
  }

  String _getRandomModel(String make) {
    final models = _carDatabase[make]?['models'] ?? [];
    if (models.isEmpty) return 'Unknown';
    return models[_random.nextInt(models.length)];
  }

  int _getRandomYear() {
    final currentYear = DateTime.now().year;
    return currentYear - _random.nextInt(15); // Cars from last 15 years
  }

  int _getRandomMileage(int year) {
    final age = DateTime.now().year - year;
    final avgMilesPerYear = 12000 + _random.nextInt(6000); // 12k-18k per year
    return (age * avgMilesPerYear + _random.nextInt(20000)).clamp(0, 300000);
  }

  String _getRandomCondition() {
    return _conditions[_random.nextInt(_conditions.length)];
  }

  String _getRandomFuelType() {
    return _fuelTypes[_random.nextInt(_fuelTypes.length)];
  }

  String _getRandomTransmission() {
    return _transmissions[_random.nextInt(_transmissions.length)];
  }

  String _getRandomColor() {
    return _colors[_random.nextInt(_colors.length)];
  }

  String _getRandomLocation() {
    final cities = [
      'San Francisco, CA',
      'Los Angeles, CA',
      'New York, NY',
      'Chicago, IL',
      'Houston, TX',
      'Phoenix, AZ',
      'Philadelphia, PA',
      'San Antonio, TX',
      'San Diego, CA',
      'Dallas, TX',
      'Austin, TX',
      'Jacksonville, FL',
      'Fort Worth, TX',
      'Columbus, OH',
      'Charlotte, NC',
      'Seattle, WA'
    ];
    return cities[_random.nextInt(cities.length)];
  }

  int _calculateBasePrice(String make, String model, int year) {
    final makeData = _carDatabase[make];
    final basePrice = makeData?['avgPrice'] ?? 30000;
    final age = DateTime.now().year - year;

    // Depreciation calculation
    final depreciationRate = 0.15; // 15% per year average
    final depreciation = basePrice * depreciationRate * age;

    return (basePrice - depreciation + _random.nextInt(10000) - 5000)
        .clamp(5000, 200000);
  }

  int _adjustPriceForCondition(int basePrice, String condition, int mileage) {
    double multiplier = 1.0;

    switch (condition) {
      case 'Excellent':
        multiplier = 1.1;
        break;
      case 'Very Good':
        multiplier = 1.05;
        break;
      case 'Good':
        multiplier = 1.0;
        break;
      case 'Fair':
        multiplier = 0.85;
        break;
      case 'Poor':
        multiplier = 0.65;
        break;
    }

    // Adjust for mileage
    if (mileage > 100000) multiplier -= 0.1;
    if (mileage > 150000) multiplier -= 0.1;

    return (basePrice * multiplier).round();
  }

  String _generateId() {
    return 'car_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }

  List<String> _generateImageUrls(String make, String model) {
    final baseUrl = 'https://images.unsplash.com/';
    final queries = [
      '$make+$model+car',
      '$make+$model+interior',
      '$make+$model+exterior',
      'car+dashboard',
      'car+engine'
    ];

    return queries
        .map((query) =>
            '${baseUrl}photo-${1500000000000 + _random.nextInt(100000000)}?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop&q=${query.replaceAll(' ', '+')}')
        .toList();
  }

  String _generateDescription(String make, String model, int year) {
    final descriptions = [
      'Beautiful $year $make $model in excellent condition. Well-maintained with complete service history.',
      'Stunning $year $make $model with low mileage. Perfect for daily commuting or weekend adventures.',
      'Reliable $year $make $model with all maintenance up to date. Clean title, no accidents.',
      'Immaculate $year $make $model with premium features. Garage-kept and meticulously cared for.',
      'Outstanding $year $make $model ready for its next owner. Excellent performance and comfort.'
    ];

    return descriptions[_random.nextInt(descriptions.length)];
  }

  Map<String, dynamic> _generateSellerInfo() {
    final names = [
      'John Smith',
      'Sarah Johnson',
      'Michael Davis',
      'Emily Brown',
      'David Wilson'
    ];
    final types = [
      'Individual',
      'Dealer',
      'Dealer',
      'Individual',
      'Certified Dealer'
    ];

    return {
      'name': names[_random.nextInt(names.length)],
      'type': types[_random.nextInt(types.length)],
      'rating': 4.0 + _random.nextDouble(),
      'reviewCount': _random.nextInt(200) + 10,
      'phone':
          '(${_random.nextInt(800) + 200}) ${_random.nextInt(800) + 200}-${_random.nextInt(9000) + 1000}',
      'responseTime': '${_random.nextInt(24) + 1} hours',
    };
  }

  Map<String, dynamic> _generateSpecs(String make, String model) {
    return {
      'engine':
          '${_random.nextInt(4) + 1}.${_random.nextInt(9)}L ${_random.nextBool() ? 'V6' : 'I4'}',
      'horsepower': '${_random.nextInt(200) + 150} HP',
      'mpgCity': _random.nextInt(15) + 20,
      'mpgHighway': _random.nextInt(15) + 25,
      'drivetrain': _random.nextBool() ? 'AWD' : 'FWD',
      'seatingCapacity': _random.nextInt(3) + 5,
      'cargoSpace': '${_random.nextInt(30) + 15} cubic feet',
      'safetyRating': '${_random.nextInt(2) + 4} stars',
    };
  }

  Map<String, dynamic> _generateHistory() {
    return {
      'accidents': _random.nextBool() ? 0 : _random.nextInt(2) + 1,
      'previousOwners': _random.nextInt(3) + 1,
      'serviceRecords': _random.nextInt(20) + 5,
      'lastServiceDate':
          DateTime.now().subtract(Duration(days: _random.nextInt(90))),
      'warrantyRemaining': _random.nextBool(),
      'recalls': _random.nextBool() ? 0 : 1,
    };
  }

  Map<String, dynamic> _generateFinancingOptions(int price) {
    return {
      'availableFinancing': true,
      'downPayment': (price * 0.1).round(),
      'monthlyPayment': (price / 60).round(), // 60 months
      'interestRate': 3.5 + _random.nextDouble() * 4, // 3.5-7.5%
      'loanTerms': [36, 48, 60, 72],
      'leaseAvailable': _random.nextBool(),
    };
  }
}
