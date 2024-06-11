<?php
include 'db_connect.php'; // Assuming you have a file for database connection


$customer_id = $_GET['customer_id'];

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT c.food_id, f.food_name, f.food_price, f.food_image, f.food_category, c.quantity 
        FROM cart c 
        JOIN food f ON c.food_id = f.food_id 
        WHERE c.customer_id = $customer_id";
$result = $conn->query($sql);

$cartItems = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $row['food_image'] = base64_encode($row['food_image']);
        $cartItems[] = $row;
    }
} else {
    echo "0 results";
}
$conn->close();

echo json_encode($cartItems);
?>
