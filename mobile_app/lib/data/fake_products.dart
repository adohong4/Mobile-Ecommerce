import 'package:mobile_app/models/models_products.dart';

final List<ProductModel> fakeProducts = [
  ProductModel(
    name: "Smart TV LG 55 inch 4K",
    brand: "LG",
    price: 12500000,
    oldPrice: 14900000,
    discountPercent: 16,
    images: [
      'assets/product.png',
      'assets/asus.png',
      'assets/microsoft.png',
    ],
    specifications: {
      'Hệ điều hành': 'Android TV',
      'Ngôn ngữ': 'Tiếng Việt, Tiếng Anh, Tiếng Trung',
      'Độ phân giải': '3840x2160 (4K)',
      'Tốc độ làm mới': '60Hz',
    },
    description: "Một chiếc TV thông minh với đầy đủ tính năng giải trí.",
  ),

  ProductModel(
    name: "Laptop ASUS Vivobook 14",
    brand: "ASUS",
    price: 18500000,
    oldPrice: 21000000,
    discountPercent: 12,
    images: [
      'assets/asus.png',
      'assets/product.png',
      'assets/microsoft.png',
    ],
    specifications: {
      'CPU': 'Intel Core i5 1135G7',
      'RAM': '8GB DDR4',
      'Ổ cứng': '512GB SSD',
      'Màn hình': '14 inch Full HD',
    },
    description: "Laptop mỏng nhẹ, hiệu năng tốt cho học tập và làm việc.",
  ),

  ProductModel(
    name: "Máy tính bảng Microsoft Surface Go",
    brand: "Microsoft",
    price: 13000000,
    oldPrice: 15000000,
    discountPercent: 13,
    images: [
      'assets/microsoft.png',
      'assets/product.png',
      'assets/asus.png',
    ],
    specifications: {
      'CPU': 'Intel Pentium Gold',
      'RAM': '4GB',
      'Ổ cứng': '64GB eMMC',
      'Màn hình': '10 inch PixelSense',
    },
    description: "Máy tính bảng nhỏ gọn, dễ dàng di chuyển và làm việc mọi lúc mọi nơi.",
  ),

  ProductModel(
    name: "Điện thoại Samsung Galaxy S21",
    brand: "Samsung",
    price: 20000000,
    oldPrice: 23000000,
    discountPercent: 13,
    images: [
      'assets/product.png',
      'assets/asus.png',
      'assets/microsoft.png',
    ],
    specifications: {
      'Màn hình': '6.2 inch Dynamic AMOLED',
      'Camera': '64MP + 12MP + 12MP',
      'RAM': '8GB',
      'Pin': '4000mAh',
    },
    description: "Điện thoại cao cấp với camera chất lượng và hiệu năng mạnh mẽ.",
  ),

  ProductModel(
    name: "Tai nghe Bluetooth Sony WH-1000XM4",
    brand: "Sony",
    price: 7000000,
    oldPrice: 8500000,
    discountPercent: 18,
    images: [
      'assets/asus.png',
      'assets/microsoft.png',
      'assets/product.png',
    ],
    specifications: {
      'Loại': 'Over-ear',
      'Kết nối': 'Bluetooth 5.0',
      'Thời gian pin': '30 giờ',
      'Tính năng': 'Chống ồn chủ động',
    },
    description: "Tai nghe không dây với chất lượng âm thanh tuyệt hảo và chống ồn hiệu quả.",
  ),
];
