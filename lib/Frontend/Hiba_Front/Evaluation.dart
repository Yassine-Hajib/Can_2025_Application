import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  // ---------------- STATE ----------------
  int _note = 0;
  bool isLoading = false;
  List<dynamic> myTrips = []; 
  String? selectedTripId;     

  final TextEditingController _commentaireController = TextEditingController();
  final TextEditingController _idReservationController = TextEditingController();
  final TextEditingController _idChauffeurController = TextEditingController();

  // ---------------- API URLs ----------------
  // USE 10.0.2.2 for Emulator, or your IP for Real Device
  final String submitUrl = "http://10.0.2.2:8888/Backend/api/evaluation.php";
  final String historyUrl = "http://10.0.2.2:8888/Backend/api/get_client_history.php";

  // ---------------- COLORS ----------------
  static const Color moroccoRed = Color(0xFFC1272D);
  static const Color moroccoGreen = Color(0xFF006233);
  static const Color darkRed = Color(0xFF8A1C21);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color starColor = Color(0xFFFFC107);

  @override
  void initState() {
    super.initState();
    _fetchMyTrips();
  }

  // 1. FETCH TRIPS
  Future<void> _fetchMyTrips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      try {
        final response = await http.get(Uri.parse("$historyUrl?email=$email"));
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          if (json['success'] == true) {
            setState(() {
              myTrips = json['data'];
            });
          }
        }
      } catch (e) {
        print("Erreur fetch history: $e");
      }
    }
  }

  // 2. AUTO-FILL LOGIC (Fixed for NULL drivers)
  void _onTripSelected(String? reservationId) {
    if (reservationId == null) return;
    
    var trip = myTrips.firstWhere((t) => t['id_reservation'].toString() == reservationId);

    setState(() {
      selectedTripId = reservationId;
      _idReservationController.text = trip['id_reservation'].toString();
      
      // Safety Check: If driver is NULL, put "En attente" or "0"
      if (trip['id_chauffeur'] != null) {
        _idChauffeurController.text = trip['id_chauffeur'].toString();
      } else {
        _idChauffeurController.text = ""; // Empty implies no driver yet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Attention: Aucun chauffeur n'a encore accepté cette course."), backgroundColor: Colors.orange)
        );
      }
    });
  }

  // 3. SUBMIT LOGIC
  Future<void> submitEvaluation() async {
    if (_note == 0 || _commentaireController.text.isEmpty || _idChauffeurController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir une course AVEC un chauffeur."), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_reservation": _idReservationController.text,
          "id_chauffeur": _idChauffeurController.text,
          "note": _note,
          "commentaire": _commentaireController.text,
        }),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Avis envoyé avec succès !"), backgroundColor: moroccoGreen),
          );
        }
        
        _commentaireController.clear();
        _idReservationController.clear();
        _idChauffeurController.clear();
        setState(() {
          _note = 0;
          selectedTripId = null;
        });
      } else {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: ${jsonResponse['message']}"), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de connexion"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if(mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
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
                                child: const Icon(Icons.star_rate_rounded, size: 35, color: moroccoGreen),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Évaluation", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: moroccoGreen, borderRadius: BorderRadius.circular(4)),
                                  child: const Text("VOTRE AVIS COMPTE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
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

            // FORM CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // DROPDOWN
                  _sectionTitle("Sélectionnez une course"),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Choisir un trajet..."),
                        value: selectedTripId,
                        items: myTrips.map((trip) {
                          // Show status in dropdown for clarity
                          String status = trip['id_chauffeur'] == null ? "(En attente)" : "(Terminée)";
                          return DropdownMenuItem<String>(
                            value: trip['id_reservation'].toString(),
                            child: Text(
                              "${trip['trajet']} $status",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13, 
                                fontWeight: FontWeight.bold,
                                color: trip['id_chauffeur'] == null ? Colors.red : Colors.black
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: _onTripSelected,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // STARS
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () => setState(() => _note = index + 1),
                          icon: Icon(
                            index < _note ? Icons.star_rounded : Icons.star_border_rounded,
                            color: index < _note ? starColor : Colors.grey.shade300,
                            size: 45,
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // COMMENT
                  _sectionTitle("Votre Commentaire"),
                  _buildModernInput(
                    controller: _commentaireController,
                    hint: "Le chauffeur était...",
                    icon: Icons.comment,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 25),

                  // TECHNICAL IDs
                  _sectionTitle("Détails Techniques"),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernInput(
                          controller: _idReservationController,
                          hint: "ID Réserv.",
                          icon: Icons.confirmation_number,
                          isReadOnly: true, 
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildModernInput(
                          controller: _idChauffeurController,
                          hint: "ID Chauffeur",
                          icon: Icons.person_pin,
                          isReadOnly: true, 
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moroccoGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ENVOYER MON AVIS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildModernInput({required TextEditingController controller, required String hint, required IconData icon, int maxLines = 1, bool isReadOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isReadOnly ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: isReadOnly ? Colors.grey : moroccoRed.withOpacity(0.8), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

class StadiumWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2.25, size.height - 40);
    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 90, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}