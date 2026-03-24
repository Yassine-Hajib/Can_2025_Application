<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/db_connect.php';
    $db = new Connection("caf_db");
    $conn = $db->conn;

    // Récupère uniquement les réservations "En attente"
    $sql = "SELECT * FROM reservations WHERE statut = 'En attente' ORDER BY date_creation DESC";
    $result = $conn->query($sql);

    $reservations = array();

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $reservations[] = $row;
        }
        echo json_encode(array("success" => true, "data" => $reservations));
    } else {
        echo json_encode(array("success" => false, "data" => []));
    }
?>