class WelcomeModel {
  String image;
  String imageDark;
  String title;
  String subtitle;

  WelcomeModel({
    required this.image,
    required this.imageDark,
    required this.title,
    required this.subtitle,
  });
}

List<WelcomeModel> welcomeItems = [
  WelcomeModel(
    image: "assets/images/welcome1.png",
    imageDark: "assets/images/welcome1_dark.png",
    title: "كل الأسواق في مكان واحد",
    subtitle: "اكتشف مجموعة واسعة من الأقسام بتجربة تصفح سريعة تتيح لك الوصول لما تحتاجه فورًا.",
  ),
  WelcomeModel(
    image: "assets/images/welcome2.png",
    imageDark: "assets/images/welcome2_dark.png",
    title: "الإعلان صار أسهل من أي وقت",
    subtitle: "اعرض منتجاتك وخدماتك مجانًا، وخلّ الناس توصل لك مباشرة في أقصر وقت ممكن.",
  ),
  WelcomeModel(
    image: "assets/images/welcome3.png",
    imageDark: "assets/images/welcome3_dark.png",
    title: "تواصل مباشر وآمن مع البائعين",
    subtitle: "تحدث مع المعلنين بسهولة، استفسر، اسأل، واتفق بدون تعقيد – احفظ وقتك وسهّل تجربتك.",
  ),
];
