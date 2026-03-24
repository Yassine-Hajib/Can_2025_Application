<?php
class Chauffeur {
    private $nom;
    private $prenom;
    private $email;
    private $password; 
    private $telephone;
    private $numero_permis;
    private $date_expiration;
    private $statut;

    
    public function __construct($nom, $prenom, $email, $password, $telephone, $numero_permis, $date_expiration, $statut = "disponible") {
        $this->nom = $nom;
        $this->prenom = $prenom;
        $this->email = $email;
        $this->password = password_hash($password, PASSWORD_DEFAULT); 
        $this->telephone = $telephone;
        $this->numero_permis = $numero_permis;
        $this->date_expiration = $date_expiration;
        $this->statut = $statut;
    }

    public function ajouter($odc) {
        
        $check = "SELECT * FROM chauffeurs WHERE email_chauffeur = ?";
        $stmtCheck = $odc->prepare($check);
        $stmtCheck->bind_param("s", $this->email);
        $stmtCheck->execute();
        if($stmtCheck->get_result()->num_rows > 0) return "Cet email est déjà utilisé.";

        
        $sql = "INSERT INTO chauffeurs 
                (nom_chauffeur, prenom_chauffeur, email_chauffeur, mot_de_passe_chauffeur, telephone_chauffeur, numero_permis, date_expiration_permis, statut_chauffeur)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        $stmt = $odc->prepare($sql);
        if (!$stmt) return "Erreur SQL Prepare: " . $odc->error;

        $stmt->bind_param("ssssssss",
            $this->nom,
            $this->prenom,
            $this->email,
            $this->password,
            $this->telephone,
            $this->numero_permis,
            $this->date_expiration,
            $this->statut
        );

        if ($stmt->execute()) return true;
        return "Erreur Insert: " . $stmt->error;
    }

    
    public function verification($odc, $email, $password) {
        $query = "SELECT * FROM chauffeurs WHERE email_chauffeur = ?";
        $stmt = $odc->prepare($query);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $chauffeur = $result->fetch_assoc();
            if (password_verify($password, $chauffeur['mot_de_passe_chauffeur'])) {
                return $chauffeur;
            }
        }
        return false;
    }
}
?>