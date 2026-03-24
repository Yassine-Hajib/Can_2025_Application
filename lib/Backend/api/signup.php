<?php
    // -------------------------------------------------------------------------
    // CORS HEADERS (MUST BE FIRST)
    // -------------------------------------------------------------------------
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    header("Access-Control-Allow-Methods: POST, OPTIONS");

    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    ini_set('display_errors', 0); // Hide HTML errors to prevent JSON parsing issues
    error_reporting(E_ALL);

    function sendResponse($success, $message) {
        echo json_encode(array("success" => $success, "message" => $message));
        exit();
    }

    // -------------------------------------------------------------------------
    // INCLUDES
    // -------------------------------------------------------------------------
    // Ensure these files exist in the parent folder
    $paths = ['../config/db_connect.php', '../Users.php', '../Chauffeur.php'];
    foreach ($paths as $path) {
        if (file_exists($path)) include_once $path;
    }

    if (!class_exists('Connection')) sendResponse(false, "Erreur: Fichier de connexion manquant.");
    
    $db = new Connection("caf_db");
    $odc = $db->conn; 

    // -------------------------------------------------------------------------
    // GET DATA
    // -------------------------------------------------------------------------
    $data = json_decode(file_get_contents("php://input"));

    // Check basic required fields
    if(!empty($data->nom) && !empty($data->email) && !empty($data->password)) {

        // FIX: Handle both 'telephone' (Flutter) and 'phone' (Postman/Test)
        $telephone = !empty($data->telephone) ? $data->telephone : (!empty($data->phone) ? $data->phone : "");

        // --- CHAUFFEUR SIGNUP ---
        if (isset($data->role) && $data->role == 'Chauffeur') {
            
            if (!class_exists('Chauffeur')) sendResponse(false, "Erreur Serveur: Classe Chauffeur manquante.");

            $permis = $data->numero_permis ?? "Non renseigné";
            $expiration = $data->date_expiration ?? "2030-01-01";

            // Instantiate Chauffeur (Make sure Chauffeur.php constructor matches this!)
            $chauffeur = new Chauffeur(
                $data->nom, 
                $data->prenom, 
                $data->email, 
                $data->password, 
                $telephone, // <--- USE THE FIXED VARIABLE
                $permis, 
                $expiration, 
                "disponible"
            );

            $res = $chauffeur->ajouter($odc);

            if($res === true) {
                http_response_code(201);
                sendResponse(true, "Compte Chauffeur créé avec succès.");
            } else {
                sendResponse(false, "Erreur SQL: " . $res);
            }

        } 
        // --- SUPPORTER SIGNUP ---
        else {
            if (!class_exists('utilisateur')) sendResponse(false, "Erreur Serveur: Classe utilisateur manquante.");

            $user = new utilisateur(
                $data->nom, 
                $data->prenom, 
                $data->email, 
                $data->password, 
                $telephone, // <--- USE THE FIXED VARIABLE
                $data->role ?? "Supporteur"
            );

            $res = $user->inscrire($odc);

            if($res === true) {
                http_response_code(201);
                sendResponse(true, "Compte créé avec succès.");
            } else {
                sendResponse(false, "Erreur SQL: " . $res);
            }
        }

    } else {
        sendResponse(false, "Données incomplètes (Nom, Email ou Password manquants).");
    }
?>