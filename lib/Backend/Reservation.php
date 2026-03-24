<?php 
class Reservation
{
    private $email_user;
    private $trajet;
    private $type_reservation;
    private $type_vehicule;

    // Constructor
    public function __construct($email_user, $trajet, $type_reservation, $type_vehicule)
    {
        $this->email_user = $email_user;
        $this->trajet = $trajet;
        $this->type_reservation = $type_reservation;
        $this->type_vehicule = $type_vehicule;
    }

    // Ajouter une réservation
    public function add_reservation($conn)
    {
        // SQL Query matching your 'reservations' table
        $sql = "INSERT INTO reservations 
                (email_utilisateur, trajet, type_reservation, type_vehicule, statut) 
                VALUES (?, ?, ?, ?, 'En attente')";

        $stmt = $conn->prepare($sql);
        
        if(!$stmt) {
            return false;
        }

        $stmt->bind_param(
            "ssss",
            $this->email_user,
            $this->trajet,
            $this->type_reservation,
            $this->type_vehicule
        );

        return $stmt->execute();
    }

    // Annuler une réservation
    public static function cancel_reservation($conn, $id_reservation)
    {
        $sql = "UPDATE reservations SET statut = 'Annulée' WHERE id_reservation = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id_reservation);

        return $stmt->execute(); 
    }

    // Modifier une réservation
    public static function edit_reservation($conn, $id_reservation, $nouveau_trajet, $nouveau_type)
    {
        $sql = "UPDATE reservations SET trajet = ?, type_reservation = ? WHERE id_reservation = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssi", $nouveau_trajet, $nouveau_type, $id_reservation);

        return $stmt->execute(); 
    }
}
?>