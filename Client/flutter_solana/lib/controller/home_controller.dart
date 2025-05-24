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
      'availability': '5'
    },
    {
      'imageUrl':
          'https://product.hstatic.net/200000410665/product/giay-the-thao-nam-xb20649fk-2_a2f0e9136e6849da95f6c6476d9dbdec.jpg',
      'name': 'Sneaker',
      'description':
          'Step up your style with these chunky black-and-white sneakers designed for both comfort and impact. Featuring a bold layered sole, breathable mesh panels, and modern streetwear aesthetics, they are perfect for everyday wear or a statement outfit. Ideal for casual outings, walking, or pairing with your favorite denim.',
      'price': '50,000',
      'availability': '2'
    },
    {
      'imageUrl':
          'https://contents.mediadecathlon.com/p2506817/k6bb995e8d179b5827ab1f530b137c8ca/dry-men-s-running-breathable-t-shirt-blue-decathlon-8666011.jpg?f=1920x0&format=auto',
      'name': 'Shirt',
      'description':
          'Elevate your everyday wardrobe with this classic royal blue t-shirt. Crafted from soft, breathable fabric, it offers a comfortable fit perfect for workouts, casual wear, or layering. The clean crew neck design and short sleeves provide timeless style with a modern edge',
      'price': '55,000',
      'availability': '12'
    },
    {
      'imageUrl':
          'https://pos.nvncdn.com/b3bf61-16762/ps/20240426_RFsMaBLiu8.jpeg',
      'name': 'Pant',
      'description':
          'Step into comfort and effortless style with these relaxed-fit brown casual pants. Made from lightweight, breathable fabric, they offer all-day ease with a roomy silhouette and convenient front patch pockets. Perfect for laid-back weekends, travel, or everyday wear, they pair effortlessly with your favorite tee or shirt for a minimalist, modern look',
      'price': '55,000',
      'availability': '8'
    },
  ].obs;

  final searchQuery = ''.obs;
  void setSearchQuery(String q) => searchQuery.value = q;
}
