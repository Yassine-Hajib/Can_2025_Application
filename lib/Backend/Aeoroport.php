<?php
class Aeoroport {

    private $Id_Aeoroport;
    private $Nom;
    private $Ville;

    //--------------------- Constructeur ---------------------
    public function __construct($nom, $ville) {
        $this->Nom = $nom;
        $this->Ville = $ville;
    }

    //--------------------- Getters ---------------------
    public function getId() { return $this->Id_Aeoroport; }
    public function getNom() { return $this->Nom; }
    public function getVille() { return $this->Ville; }

    //--------------------- Setters ---------------------
    public function setNom($nom) { $this->Nom = $nom; }
    public function setVille($ville) { $this->Ville = $ville; }

    //--------------------- CRUD ---------------------
    public function ajouter($odc) {
        $sql = "INSERT INTO aeroport (Nom, Ville) VALUES (?, ?)";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("ss", $this->Nom, $this->Ville);
        return $stmt->execute();
    }

    public static function afficher($odc, $id) {
        $sql = "SELECT * FROM aeroport WHERE Id_Aeoroport = ?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function modifier($odc, $id) {
        $sql = "UPDATE aeroport SET Nom=?, Ville=? WHERE Id_Aeoroport=?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("ssi", $this->Nom, $this->Ville, $id);
        return $stmt->execute();
    }

    public static function supprimer($odc, $id) {
        $sql = "DELETE FROM aeroport WHERE Id_Aeoroport = ?";
        $stmt = $odc->prepare($sql);
        $stmt->bind_param("i", $id);
        return $stmt->execute();
    }
}
?>