<?php

include 'db_connect.php';

// Check if the request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    // Check if all required fields are set
    if (isset($_POST["username"]) && isset($_POST["email"]) && isset($_POST["password"])) {
        
        // Sanitize input data
        $username = $_POST["username"];
        $email = $_POST["email"];
        $password = $_POST["password"];
        
        // Hash the password for security
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
        
        // Prepare SQL statement to insert user data into the database
        $sql = "INSERT INTO admins (username, email, password) VALUES ('$username', '$email', '$hashed_password')";
        
        if ($conn->query($sql) === TRUE) {
            // Registration successful
            echo "Registration successful";
        } else {
            // Registration failed
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
        
    } else {
        // Required fields are missing
        echo "All fields are required";
    }
} else {
    // Invalid request method
    echo "Invalid request method";
}

?>