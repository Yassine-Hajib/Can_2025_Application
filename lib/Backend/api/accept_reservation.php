<?php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Allow-Headers: Content-Type");

    include_once '../config/db_connect.php';
    $db = new Connection("caf_db");
    $conn = $db->conn;

    $data = json_decode(file_get_contents("php://input"));

    if(!empty($data->id_reservation) && !empty($data->id_chauffeur)) {
        
        // Update status to 'Validée' and assign the chauffeur
        $sql = "UPDATE reservations SET statut = 'Validée', id_chauffeur = ? WHERE id_reservation = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ii", $data->id_chauffeur, $data->id_reservation);

        if($stmt->execute()) {
            echo json_encode(array("success" => true, "message" => "Course acceptée !"));
        } else {
            echo json_encode(array("success" => false, "message" => "Erreur SQL"));
        }
    } else {
        echo json_encode(array("success" => false, "message" => "Données manquantes"));
    }
?>