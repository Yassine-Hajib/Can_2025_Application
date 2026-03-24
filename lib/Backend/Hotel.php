<?php
class Hotel {

    private $Id_Hotel;
    private $Nom;
    private $Ville;
    private $Telephone;

    //--------------------- Constructeur ---------------------
    public function __construct($nom, $ville, $telephone) {
        $this->Nom = $nom;
        $this->Ville = $ville;
        $this->Telephone = $telephone;
    }

    //--------------------- Getters ---------------------
    public function getId() { return $this->Id_Hotel; }
    public function getNom() { return $this->Nom; }
    public function getVille() { return $this->Ville; }
    public function getTelephone() { return $this->Telephone; }

    //--------------------- Setters ---------------------
    public function setNom($nom) { $this->Nom = $nom; }
    public function setVille($ville) { $this->Ville = $ville; }
    public function setTelephone($tel) { $this->Telephone = $tel; }

    //--------------------- CRUD ---------------------
    public function ajouter($odc) {
        $sql = "INSERT INTO hotel (Nom, Ville, Telephone) VALUES (?, ?, ?)";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("sss", $this->Nom, $this->Ville, $this->Telephone);
        return $stmt->execute();
    }

    public static function afficher($odc, $id) {
        $sql = "SELECT * FROM hotel WHERE Id_Hotel = ?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function modifier($odc, $id) {
        $sql = "UPDATE hotel SET Nom=?, Ville=?, Telephone=? WHERE Id_Hotel=?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("sssi", $this->Nom, $this->Ville, $this->Telephone, $id);
        return $stmt->execute();
    }

    public static function supprimer($odc, $id) {
        $sql = "DELETE FROM hotel WHERE Id_Hotel = ?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("i", $id);
        return $stmt->execute();
    }
}
?>