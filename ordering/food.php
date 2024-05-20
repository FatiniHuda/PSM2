<?php
include 'db_connect.php'; // Assuming you have a file for database connection

header('Content-Type: application/json');

$query = "SELECT * FROM food";
$result = mysqli_query($conn, $query);

if (!$result) {
    echo json_encode(["error" => "Failed to fetch data"]);
    exit();
}

$foodItems = array();

while ($row = mysqli_fetch_assoc($result)) {
    $row['image'] = base64_encode($row['image']); // Convert image to base64
    $foodItems[] = $row;
}

echo json_encode($foodItems);
?>
