
import 'package:sabat_sfakys/models/Article.dart';

class PanierService {
  List<Article> panier = [];

  void ajouterAuPanier(Article article) {
    panier.add(article);
    print('Article ajouté au panier: ${article.name}');
  }

  List<Article> getPanier() {
    return panier;
  }
}
