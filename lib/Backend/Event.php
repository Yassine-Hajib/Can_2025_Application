<?php
class Evenement {

    private $Id_Evenement;
    private $Nom;
    private $Type;
    private $Date;
    private $Lieu;
    private $Heure_Debut;
    private $Heure_Fin;
    private $Description;

    //--------------------- Constructeur ---------------------
    public function __construct($nom, $type, $date, $lieu, $heureDebut, $heureFin, $description) {
        $this->Nom = $nom;
        $this->Type = $type;
        $this->Date = $date;
        $this->Lieu = $lieu;
        $this->Heure_Debut = $heureDebut;
        $this->Heure_Fin = $heureFin;
        $this->Description = $description;
    }

    //--------------------- Getters ---------------------
    public function getId() { return $this->Id_Evenement; }
    public function getNom() { return $this->Nom; }
    public function getType() { return $this->Type; }
    public function getDate() { return $this->Date; }
    public function getLieu() { return $this->Lieu; }
    public function getHeureDebut() { return $this->Heure_Debut; }
    public function getHeureFin() { return $this->Heure_Fin; }
    public function getDescription() { return $this->Description; }

    //--------------------- Setters ---------------------
    public function setNom($nom) { $this->Nom = $nom; }
    public function setType($type) { $this->Type = $type; }
    public function setDate($date) { $this->Date = $date; }
    public function setLieu($lieu) { $this->Lieu = $lieu; }
    public function setHeureDebut($h) { $this->Heure_Debut = $h; }
    public function setHeureFin($h) { $this->Heure_Fin = $h; }
    public function setDescription($desc) { $this->Description = $desc; }

    //--------------------- CRUD ---------------------
    public function ajouter($odc) {
        $sql = "INSERT INTO evenement (Nom, Type, Date, Lieu, Heure_Debut, Heure_Fin, Description)
                VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("sssssss", $this->Nom, $this->Type, $this->Date, 
                          $this->Lieu, $this->Heure_Debut, $this->Heure_Fin, $this->Description);
        return $stmt->execute();
    }

    public static function afficher($odc, $id) {
        $sql = "SELECT * FROM evenement WHERE Id_Evenement = ?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function modifier($odc, $id) {
        $sql = "UPDATE evenement SET Nom=?, Type=?, Date=?, Lieu=?, 
                Heure_Debut=?, Heure_Fin=?, Description=? WHERE Id_Evenement=?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("sssssssi", $this->Nom, $this->Type, $this->Date,
                          $this->Lieu, $this->Heure_Debut, $this->Heure_Fin,
                          $this->Description, $id);
        return $stmt->execute();
    }

    public static function supprimer($odc, $id) {
        $sql = "DELETE FROM evenement WHERE Id_Evenement = ?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("i", $id);
        return $stmt->execute();
    }
}
?>