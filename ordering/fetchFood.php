<?php

include 'db_connect.php'; // Assuming you have a file for database connection

$result = mysqli_query($conn, "SELECT * FROM food");

$medicines = array();

while ($row = mysqli_fetch_assoc($result)) {
    $row['image'] = base64_encode($row['image']); // Convert image to base64
    $medicines[] = $row;
}

echo json_encode($medicines);
?>
