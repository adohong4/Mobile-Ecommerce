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
    description: "Chiếc Smart TV LG 55 inch 4K mang đến trải nghiệm giải trí sống động với màn hình độ phân giải siêu cao. Android TV tích hợp sẵn giúp bạn truy cập hàng ngàn ứng dụng và nội dung giải trí, bao gồm YouTube, Netflix, và nhiều hơn nữa. Thiết kế hiện đại, viền mỏng và chất lượng âm thanh sống động sẽ nâng tầm không gian sống của bạn.",
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
    description: "Vivobook 14 là chiếc laptop lý tưởng cho sinh viên và nhân viên văn phòng. Thiết kế thời trang, pin lâu, và hiệu năng ổn định đáp ứng mọi nhu cầu làm việc và giải trí. Bàn phím gõ êm và màn hình hiển thị sắc nét là những điểm cộng lớn của sản phẩm này.",
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
    description: "Surface Go là sự kết hợp tuyệt vời giữa hiệu năng và tính di động. Thiết kế tinh tế, nhẹ nhàng giúp bạn dễ dàng mang theo bên mình. Phù hợp cho cả học tập, công việc và giải trí nhẹ nhàng như xem phim, đọc sách.",
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
    description: "Samsung Galaxy S21 sở hữu camera đỉnh cao, khả năng quay video 8K và hiệu năng mượt mà nhờ chip mạnh mẽ. Thiết kế tinh tế cùng nhiều công nghệ tiên tiến như 5G, vân tay dưới màn hình, và màn hình 120Hz sẽ khiến bạn mê mẩn.",
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
    description: "Sony WH-1000XM4 là chiếc tai nghe chống ồn hàng đầu, mang đến trải nghiệm âm thanh đắm chìm. Công nghệ chống ồn chủ động giúp bạn tập trung tối đa. Thời lượng pin 30 giờ và thiết kế đeo thoải mái phù hợp cho cả ngày dài sử dụng.",
  ),
];
