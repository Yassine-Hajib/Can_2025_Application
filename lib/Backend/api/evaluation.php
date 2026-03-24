<?php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    ini_set('display_errors', 0);
    error_reporting(E_ALL);

    include_once '../config/db_connect.php';
    include_once '../Evaluation.php';

    $db = new Connection("caf_db");
    $conn = $db->conn;

    $data = json_decode(file_get_contents("php://input"));

    if(!empty($data->id_reservation) && !empty($data->id_chauffeur) && !empty($data->note) && !empty($data->commentaire)) {
        
        $avis = new Evaluation(
            $data->note,
            $data->commentaire,
            $data->id_reservation,
            $data->id_chauffeur
        );

        if($avis->add_evaluation($conn)) {
            echo json_encode(array("success" => true, "message" => "Évaluation envoyée avec succès !"));
        } else {
            echo json_encode(array("success" => false, "message" => "Erreur lors de l'enregistrement."));
        }

    } else {
        echo json_encode(array("success" => false, "message" => "Données incomplètes."));
    }
?>