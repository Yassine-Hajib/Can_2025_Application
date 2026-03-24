import 'package:flutter/material.dart';

class AidePage extends StatefulWidget {
  const AidePage({super.key});

  @override
  State<AidePage> createState() => _AidePageState();
}

class _AidePageState extends State<AidePage> {
  // ---------------- COLORS ----------------
  static const Color moroccoRed = Color(0xFFC1272D);
  static const Color moroccoGreen = Color(0xFF006233);
  static const Color darkRed = Color(0xFF8A1C21);
  static const Color offWhite = Color(0xFFF8F9FA);

  // ---------------- EMERGENCY DATA ----------------
  final List<Map<String, dynamic>> emergencyNumbers = [
    {"title": "Police", "number": "19", "icon": Icons.local_police, "color": Colors.blue.shade800},
    {"title": "Gendarmerie", "number": "177", "icon": Icons.security, "color": Colors.grey.shade700},
    {"title": "Ambulance", "number": "15", "icon": Icons.medical_services, "color": moroccoRed},
    {"title": "Pompiers", "number": "150", "icon": Icons.fire_truck, "color": Colors.orange.shade800},
    {"title": "Aide Autoroute", "number": "5050", "icon": Icons.add_road, "color": Colors.blue},
    {"title": "Allo SAMU", "number": "141", "icon": Icons.health_and_safety, "color": Colors.teal},
    {"title": "Croissant Rouge", "number": "1414", "icon": Icons.volunteer_activism, "color": moroccoRed},
    {"title": "Anti-Corruption", "number": "0801004747", "icon": Icons.gavel, "color": Colors.purple},
    {"title": "Consommateurs", "number": "0801003637", "icon": Icons.shopping_bag, "color": Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------------------------------------
            // --- HEADER ---
            // ---------------------------------------------
            Stack(
              children: [
                ClipPath(
                  clipper: StadiumWaveClipper(),
                  child: Container(
                    height: 260,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [moroccoRed, darkRed],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -50, right: -50,
                  child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: moroccoGreen, width: 3),
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: moroccoGreen.withOpacity(0.1),
                                child: const Icon(Icons.support_agent_rounded, size: 35, color: moroccoGreen),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Urgences & Aide", 
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: moroccoGreen, borderRadius: BorderRadius.circular(4)),
                                  child: const Text(
                                    "AFCON 2025 MAROC", 
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ---------------------------------------------
            // --- CONTENT ---
            // ---------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // 1. EMERGENCY GRID (NEW)
                  _sectionTitle("Numéros d'Urgence (Maroc)"),
                  GridView.builder(
                    shrinkWrap: true, // Important inside SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 items per row
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: emergencyNumbers.length,
                    itemBuilder: (context, index) {
                      final item = emergencyNumbers[index];
                      return _buildEmergencyCard(item);
                    },
                  ),

                  const SizedBox(height: 30),

                  // 2. FAQ SECTION
                  _sectionTitle("Questions Fréquentes"),
                  _buildFaqItem("Comment réserver un trajet ?", "Allez dans la section 'Réservations', choisissez votre point de départ et d'arrivée, puis sélectionnez votre véhicule."),
                  _buildFaqItem("Puis-je annuler ma réservation ?", "Oui, vous pouvez annuler sans frais jusqu'à 2 heures avant l'heure prévue."),
                  _buildFaqItem("Objets perdus ?", "Contactez le support ci-dessous ou appelez directement le service client au +212 5 22 00 00 00."),

                  const SizedBox(height: 30),

                  // 3. CONTACT SECTION
                  _sectionTitle("Support App"),
                  _buildContactCard(Icons.email_outlined, "Email Support", "support@afcon2025.ma", Colors.blue),
                  const SizedBox(height: 15),
                  _buildContactCard(Icons.headset_mic_outlined, "Service Client", "+212 5 22 00 00 00", moroccoGreen),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'], color: item['color'], size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            item['number'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: item['color']),
          ),
          const SizedBox(height: 4),
          Text(
            item['title'],
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.help_outline, color: Color(0xFFC1272D)),
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                answer,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- CLIPPER -----------------
class StadiumWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}