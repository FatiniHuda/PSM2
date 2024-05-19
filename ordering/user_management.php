<?php
// Database connection parameters
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

// Handle POST request for user registration
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $username = $_POST["username"];
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Prepare SQL statement to insert data into registered_users table
    $stmt = $conn->prepare("INSERT INTO registered_users (username, email, password) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $email, $password);

    // Execute the SQL statement
    if ($stmt->execute()) {
        // Registration successful
        echo "Registration successful!";
    } else {
        // Registration failed
        echo "Error: " . $conn->error;
    }

    // Close statement
    $stmt->close();
}

// Handle POST request for user verification
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $username = $_POST["username"];

    // Check if the user exists in registered_users table
    $result = $conn->query("SELECT * FROM registered_users WHERE username='$username'");
    if ($result->num_rows > 0) {
        // User found, move to verified_users table
        $row = $result->fetch_assoc();
        $email = $row["email"];
        $password = $row["password"];

        // Prepare SQL statement to insert data into verified_users table
        $stmt = $conn->prepare("INSERT INTO verified_users (username, email, password) VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $username, $email, $password);

        // Execute the SQL statement
        if ($stmt->execute()) {
            // Verification successful
            echo "User verified and moved to verified_users table!";
        } else {
            // Verification failed
            echo "Error: " . $conn->error;
        }

        // Close statement
        $stmt->close();
    } else {
        // User not found in registered_users table
        echo "User not found!";
    }
}

// Close connection
$conn->close();
?>
