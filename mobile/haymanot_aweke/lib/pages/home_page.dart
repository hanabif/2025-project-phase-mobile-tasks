import 'package:flutter/material.dart';
import 'package:haymanot_aweke/models/product.dart';
import 'package:haymanot_aweke/widgets/product_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Product> products = [
    Product(
      name: "Christian Louboutin",
      category: "Women's high heels",
      price: 1000,
      imageUrl: "assets/images/Louboutin.jpg",
      description:
          "Christian Louboutin heels are handcrafted in Italy using premium Nappa leather, patent calfskin, or suede. Each pair is meticulously constructed for comfort and style, with leather linings and padded insoles. Their signature glossy red lacquered soles are more than a brand mark — they’re a symbol of confidence and sensuality. From stiletto pumps to ankle boots, Louboutin shoes blend Parisian elegance with Italian craftsmanship.",
    ),
    Product(
      name: "Mach & Mach",
      category: "Women's high heels",
      price: 950,
      imageUrl: "assets/images/Mach & Mach.jpg",
      description:
          "Mach & Mach shoes are known for their signature double-bow crystal embellishments. Made from lustrous satin, Italian leather soles, and hand-applied rhinestones, these heels are designed to dazzle. The pointed-toe silhouette with ankle straps ensures a secure fit, while the soft leather lining provides all-night comfort. Each piece is a blend of Caucasus heritage and futuristic femininity, making them perfect for modern luxury seekers.",
    ),
    Product(
      name: "Yves Saint Laurent",
      category: "Women's high heels",
      price: 980,
      imageUrl: "assets/images/Ysl heels.jpg",
      description:
          "Saint Laurent shoes reflect bold minimalism and rock-chic glamour. Crafted from Italian calf leather, patent leather, or exotic skins like python or croc-embossed materials, they are sculptural yet sleek. Many heels feature metal YSL monograms, angular shapes, and lacquered finishes. Inside, smooth leather lining and insoles ensure a luxe feel, while leather outsoles offer durability. A staple in edgy, upscale wardrobes.",
    ),
    Product(
      name: "Miu Miu",
      category: "Women's high heels",
      price: 980,
      imageUrl: "assets/images/Miu Miu.jpg",
      description:
          "A playful sub-brand of Prada, Miu Miu designs footwear that blends soft lambskin leather, velvet, or satin uppers with youthful, rebellious energy. Their shoes often feature chunky soles, glitter finishes, or oversized embellishments like crystals or bows. Designed and made in Italy, Miu Miu heels and loafers use rubber or leather soles and cushioned insoles for comfort. Ideal for those who want fashion-forward luxury with a twist.",
    ),
    Product(
      name: "Christian Dior",
      category: "Women's high heels",
      price: 990,
      imageUrl: "asstes/images/Dior shoes.jpg",
      description:
          "Dior shoes combine Haute Couture heritage with innovation. Made from calfskin, mesh, embroidered canvas, or technical fabric, Dior footwear is often decorated with embroidered logos, bows, or straps reading J’adior. Dior artisans assemble each piece with hand-stitched details and top-grade leather soles. Whether it’s the Dior-ID sneakers or slingback heels, the focus is always on femininity, craftsmanship, and Parisian prestige.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Color(0xFF3F51F3),
        child: Icon(Icons.add, size: 36, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              SizedBox(height: 38),
              Title(),
              SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/details",
                          arguments: products[index],
                        );
                      },
                      child: ProductCard(product: products[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//header widget
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Color(0xFFCCCCCC),
          ),
        ),
        SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "July 14,2023",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFAAAAAA),
                fontWeight: FontWeight.w500,
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Hello, ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: 'Yohannes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: 130),
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFDDDDDD), width: 1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.notifications_active_outlined),
            ),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF3F51F3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//title
class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Available Products",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E3E3E),
          ),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          height: 40,
          width: 40,
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
            icon: Icon(Icons.search_outlined, size: 24,),
          ),
        ),
      ],
    );
  }
}
