<?php
include 'db_connect.php'; // Assuming you have a file for database connection

$customer_id = $_POST['customer_id'];
$food_id = $_POST['food_id'];
$quantity = $_POST['quantity'];
$price = $_POST['price'];

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM cart WHERE customer_id = $customer_id AND food_id = $food_id";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $sql = "UPDATE cart SET quantity = quantity + $quantity WHERE customer_id = $customer_id AND food_id = $food_id";
} else {
    $sql = "INSERT INTO cart (customer_id, food_id, quantity, price) VALUES ($customer_id, $food_id, $quantity, $price)";
}

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
