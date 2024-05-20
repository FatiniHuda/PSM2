<?php
include 'db_connect.php'; // Include the database connection setup

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the posted data
$postData = file_get_contents('php://input');
$request = json_decode($postData, true);

// Validate input
if (!isset($request['name']) || !isset($request['tableNumber'])) {
    http_response_code(400); // Bad Request
    echo json_encode(array("message" => "Invalid input."));
    exit;
}

$name = $request['name'];
$tableNumber = $request['tableNumber'];

if (empty($name) || empty($tableNumber)) {
    http_response_code(400); // Bad Request
    echo json_encode(array("message" => "Name and table number are required."));
    exit;
}

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO customer (name, table_number) VALUES (?, ?)");
if ($stmt === false) {
    http_response_code(500); // Internal Server Error
    echo json_encode(array("message" => "Failed to prepare the SQL statement."));
    exit;
}

$stmt->bind_param("ss", $name, $tableNumber);

// Execute the statement
if ($stmt->execute()) {
    http_response_code(200); // OK
    echo json_encode(array("message" => "Customer data inserted successfully."));
} else {
    http_response_code(500); // Internal Server Error
    echo json_encode(array("message" => "Failed to insert customer data."));
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
