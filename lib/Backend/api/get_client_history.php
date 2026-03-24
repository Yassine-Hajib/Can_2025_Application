<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/db_connect.php';
    $db = new Connection("caf_db");
    $conn = $db->conn;

    if(isset($_GET['email'])) {
        $email = $_GET['email'];

        // MODIFIED QUERY: Removed "AND id_chauffeur IS NOT NULL"
        // Now it returns ALL reservations for this user.
        $sql = "SELECT * FROM reservations WHERE email_utilisateur = ? ORDER BY date_creation DESC";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        $trips = array();
        while($row = $result->fetch_assoc()) {
            $trips[] = $row;
        }

        echo json_encode(array("success" => true, "data" => $trips));
    } else {
        echo json_encode(array("success" => false, "message" => "Email manquant"));
    }
?>