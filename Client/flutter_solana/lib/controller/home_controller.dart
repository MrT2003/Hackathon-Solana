import 'package:get/get.dart';

class HomeController extends GetxController {
  final banners = <String>[
    'https://www.boost-ae.net/medias/25b31183-f532-42d8-aaa3-72ddeb085b1b.PNG',
    'https://cdn.prod.website-files.com/6345b143630a009103bb4bdd/648c86e9883c2e235ee6da8e_social%20share.png',
    'https://cdn.thegreatprojects.com/thegreatprojects/images/2/5/1/7/a/2517ae4045ecfaa46718cbebdd5b8803.png?operation=crop&height=650&gravity=center&width=1920&format=png',
  ].obs;
  final currentBanner = 0.obs;
  void changeBanner(int idx) => currentBanner.value = idx;

  final balance = 2000.obs;

  final products = <Map<String, String>>[
    {
      'imageUrl':
          'https://grontkontor.dk/wp-content/uploads/2024/10/Klimavenlig-termokop-i-genanvendt-staal-og-plast-groen.jpg',
      'name': 'Thermos cup',
      'description':
          'Keep your drinks at the perfect temperature with this sleek, insulated thermos cup. Designed in a modern matte green finish with a stainless steel rim, it features double-wall insulation to keep beverages hot or cold for hours. The secure lid prevents spills, while the attached strap offers convenient, on-the-go carrying. Ideal for coffee, tea, or any drink you love',
      'price': '45,000',
      'availability': '5',
      'category': 'Drink'
    },
    {
      'imageUrl':
          'https://product.hstatic.net/200000410665/product/giay-the-thao-nam-xb20649fk-2_a2f0e9136e6849da95f6c6476d9dbdec.jpg',
      'name': 'Sneaker',
      'description':
          'Step up your style with these chunky black-and-white sneakers designed for both comfort and impact. Featuring a bold layered sole, breathable mesh panels, and modern streetwear aesthetics, they are perfect for everyday wear or a statement outfit. Ideal for casual outings, walking, or pairing with your favorite denim.',
      'price': '50,000',
      'availability': '2',
      'category': 'Others'
    },
    {
      'imageUrl':
          'https://contents.mediadecathlon.com/p2506817/k6bb995e8d179b5827ab1f530b137c8ca/dry-men-s-running-breathable-t-shirt-blue-decathlon-8666011.jpg?f=1920x0&format=auto',
      'name': 'Shirt',
      'description':
          'Elevate your everyday wardrobe with this classic royal blue t-shirt. Crafted from soft, breathable fabric, it offers a comfortable fit perfect for workouts, casual wear, or layering. The clean crew neck design and short sleeves provide timeless style with a modern edge',
      'price': '55,000',
      'availability': '12',
      'category': 'Others'
    },
    {
      'imageUrl':
          'https://pos.nvncdn.com/b3bf61-16762/ps/20240426_RFsMaBLiu8.jpeg',
      'name': 'Pant',
      'description':
          'Step into comfort and effortless style with these relaxed-fit brown casual pants. Made from lightweight, breathable fabric, they offer all-day ease with a roomy silhouette and convenient front patch pockets. Perfect for laid-back weekends, travel, or everyday wear, they pair effortlessly with your favorite tee or shirt for a minimalist, modern look',
      'price': '55,000',
      'availability': '8',
      'category': 'Others'
    },

    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.IYTu9UV9Iz7f-LXGns1ebQHaFm?rs=1&pid=ImgDetMain',
      'name': 'Voucher Ăn uống',
      'description': 'Giảm giá 20% tại các nhà hàng đối tác trên toàn quốc.',
      'price': '100,000',
      'availability': '10',
      'category': 'Voucher'
    },
    {
      'imageUrl':
          'https://www.indongnam.com.vn/hm_content/uploads/mau/voucher/mau-voucher-spa-tham-my-lam-dep-42.jpg',
      'name': 'Voucher Spa & Làm đẹp',
      'description': 'Giảm giá 30% tại các spa và salon làm đẹp nổi tiếng.',
      'price': '150,000',
      'availability': '5',
      'category': 'Voucher'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.y6pljJK44J1mvloCy1rSMgHaGh?rs=1&pid=ImgDetMain',
      'name': 'Voucher Mua sắm',
      'description': 'Giảm giá 25% tại các trung tâm thương mại lớn.',
      'price': '200,000',
      'availability': '8',
      'category': 'Voucher'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.gjXfN4PV_V4MrDDh4DbPXQHaGT?w=580&h=494&rs=1&pid=ImgDetMain',
      'name': 'Voucher Du lịch',
      'description': 'Ưu đãi 40% cho các tour du lịch trong nước.',
      'price': '300,000',
      'availability': '6',
      'category': 'Voucher'
    },

    // Education
    {
      'imageUrl':
          'https://itexpert.vn/wp-content/uploads/2020/09/Python-Prrogramming.jpg',
      'name': 'Khóa học Lập trình Python',
      'description':
          'Khóa học trực tuyến dành cho người mới bắt đầu với Python.',
      'price': '500,000',
      'availability': '15',
      'category': 'Education'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.D2mUMwxznWv9uWQQkykRVgHaEK?rs=1&pid=ImgDetMain',
      'name': 'Khóa học Thiết kế Đồ họa',
      'description':
          'Học cách sử dụng Photoshop, Illustrator từ cơ bản đến nâng cao.',
      'price': '600,000',
      'availability': '10',
      'category': 'Education'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.Rpu6jRK0IvTOADVQZySzlgHaEK?rs=1&pid=ImgDetMain',
      'name': 'Khóa học Marketing Online',
      'description': 'Chiến lược và thực hành quảng cáo trên mạng xã hội.',
      'price': '450,000',
      'availability': '12',
      'category': 'Education'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.bZGvZBczEr5cOWYyxVEs-QHaE8?rs=1&pid=ImgDetMain',
      'name': 'Khóa học Tiếng Anh Giao tiếp',
      'description':
          'Nâng cao kỹ năng giao tiếp tiếng Anh với giáo viên bản ngữ.',
      'price': '550,000',
      'availability': '18',
      'category': 'Education'
    },

    // Drink
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.-6K75nSJgf7TFYs-GfOoewHaHa?rs=1&pid=ImgDetMain',
      'name': 'Bình nước giữ nhiệt',
      'description':
          'Giữ nhiệt lạnh và nóng lên đến 12 giờ, thiết kế hiện đại.',
      'price': '75,000',
      'availability': '20',
      'category': 'Drink'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.78EhjmKRNVX0N8vdY_f5JwHaHa?rs=1&pid=ImgDetMain',
      'name': 'Máy pha cà phê mini',
      'description': 'Dễ dàng pha chế cà phê tại nhà với hương vị tuyệt vời.',
      'price': '500,000',
      'availability': '7',
      'category': 'Drink'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP._vyZ3zLxZeuciKyaCpCIdAHaHa?rs=1&pid=ImgDetMain',
      'name': 'Bộ ly thủy tinh cao cấp',
      'description': 'Thiết kế tinh tế, thích hợp cho mọi loại đồ uống.',
      'price': '120,000',
      'availability': '10',
      'category': 'Drink'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.xET9ayNyiAxKL0SxZ-Dr4AHaHa?rs=1&pid=ImgDetMain',
      'name': 'Bình lắc thể thao',
      'description': 'Dành cho người tập gym, giúp trộn thức uống dễ dàng.',
      'price': '90,000',
      'availability': '15',
      'category': 'Drink'
    },

    // Others
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.xbbmAXMssAdf_9p-tvO9yQHaHa?rs=1&pid=ImgDetMain',
      'name': 'Túi du lịch',
      'description': 'Thiết kế rộng rãi, tiện lợi cho các chuyến đi xa.',
      'price': '350,000',
      'availability': '8',
      'category': 'Others'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.nkEH8x0ucmLs9URghdcIHwHaHa?w=580&h=580&rs=1&pid=ImgDetMain',
      'name': 'Kính râm chống UV',
      'description': 'Bảo vệ mắt khỏi tia UV, phong cách thời trang.',
      'price': '200,000',
      'availability': '12',
      'category': 'Others'
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.1zjMzWbZt5LceqNmsFZAfAHaHa?rs=1&pid=ImgDetMain',
      'name': 'Ba lô thể thao',
      'description':
          'Nhẹ và thoải mái, phù hợp cho vận động viên và người tập luyện.',
      'price': '450,000',
      'availability': '10',
      'category': 'Others'
    },
    {
      'imageUrl': 'https://cf.shopee.vn/file/fcb75f5e147ffb192917618c247318c7',
      'name': 'Đồng hồ thông minh',
      'description': 'Theo dõi sức khỏe và nhận thông báo thông minh.',
      'price': '1,200,000',
      'availability': '5',
      'category': 'Others'
    }
  ].obs;

  final categories = ['Voucher', 'Education', 'Drink', 'Others'].obs;
  final selectedCategory = RxString('Voucher');

  final searchQuery = ''.obs;
  void setSearchQuery(String q) => searchQuery.value = q;
}
