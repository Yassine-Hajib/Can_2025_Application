<?php
class Evaluation
{
    private $note;
    private $commentaire;
    private $id_reservation;
    private $id_chauffeur;

    public function __construct($note, $commentaire, $id_reservation, $id_chauffeur)
    {
        $this->note = $note;
        $this->commentaire = $commentaire;
        $this->id_reservation = $id_reservation;
        $this->id_chauffeur = $id_chauffeur;
    }

    // Ajouter une évaluation
    public function add_evaluation($conn)
    {
        $sql = "INSERT INTO avis (note, commentaire, id_reservation, id_chauffeur)
                VALUES (?, ?, ?, ?)";
        
        $stmt = $conn->prepare($sql);
        
        if(!$stmt) {
            return false;
        }

        $stmt->bind_param(
            "isii", // i=integer, s=string
            $this->note,
            $this->commentaire,
            $this->id_reservation,
            $this->id_chauffeur
        );

        return $stmt->execute(); 
    }

    // Supprimer une évaluation
    public static function delete_evaluation($conn, $id_avis)
    {
        $sql = "DELETE FROM avis WHERE id_avis = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id_avis);

        return $stmt->execute(); 
    }
}
?>