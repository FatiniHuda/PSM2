<?php
include 'db_connect.php'; // Assuming you have a file for database connection

$customer_id = $_POST['customer_id'];
$food_id = $_POST['food_id'];
$quantity = $_POST['quantity'];

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "UPDATE cart SET quantity = $quantity WHERE customer_id = $customer_id AND food_id = $food_id";

if ($conn->query($sql) === TRUE) {
    echo "Record updated successfully";
} else {
    echo "Error updating record: " . $conn->error;
}

$conn->close();
?>
