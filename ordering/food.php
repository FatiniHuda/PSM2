<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "ordering";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO food (food_name, food_price, food_image) VALUES (?, ?, ?)");
$stmt->bind_param("ssdi", $food_name, $food_price, $food_image);

// Set parameters and execute
$food_name= "Nasi Lemak Ayam";
$food_price = 5.50;
$food_image = "assets/nasi_lemak_ayam.jpg";
$stmt->execute();

echo "New records created successfully";

$stmt->close();
$conn->close();
?>