<?php
include 'db_connect.php'; // Assuming you have a file for database connection

$customer_id = $_POST['customer_id'];
$food_id = $_POST['food_id'];

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "DELETE FROM cart WHERE customer_id = $customer_id AND food_id = $food_id";

if ($conn->query($sql) === TRUE) {
    echo "Record deleted successfully";
} else {
    echo "Error deleting record: " . $conn->error;
}

$conn->close();
?>
