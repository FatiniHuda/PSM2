<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);

include 'db_connect.php'; // Make sure this file sets the variables $servername, $username, $password, $dbname


// Get data from POST request
$name = isset($_POST['name']) ? $_POST['name'] : '';
$tableNumber = isset($_POST['table_number']) ? $_POST['table_number'] : '';

if (empty($name) || empty($tableNumber)) {
    echo json_encode(array("status" => "error", "message" => "Name and Table Number are required."));
    exit();
}

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO customer (name, table_number) VALUES (?, ?)");
if (!$stmt) {
    echo json_encode(array("status" => "error", "message" => "Prepare statement failed: " . $conn->error));
    exit();
}
$stmt->bind_param("ss", $name, $tableNumber);

if ($stmt->execute()) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "error", "message" => $stmt->error));
}

$stmt->close();
$conn->close();
?>
