import 'package:flutter/material.dart';
import 'package:sabat_sfakys/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userProfile = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Méthode pour charger le profil de l'utilisateur
  void _loadUserProfile() async {
    try {
      var profile = await ApiService.getUserProfile(); // Ou TokenService.getUserProfile() si tu utilises TokenService
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur lors de la récupération du profil");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userProfile.isEmpty
              ? Center(child: Text('Aucun profil trouvé'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nom: ${userProfile['name'] ?? 'Non défini'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email: ${userProfile['email'] ?? 'Non défini'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date de naissance: ${userProfile['birthdate'] ?? 'Non défini'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
    );
  }
}
