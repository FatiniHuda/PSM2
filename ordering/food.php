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
    // Check if the image data is not null before encoding
    if (!is_null($row['food_image'])) {
        $row['food_image'] = base64_encode($row['food_image']); // Convert image to base64
    } else {
        $row['food_image'] = null;
    }
    $foodItems[] = $row;
}

echo json_encode($foodItems);
?>
