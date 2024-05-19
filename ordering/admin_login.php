<?php

include 'db_connect.php'; // Assuming you have a file for database connection

// Get user credentials from the Flutter app
$username = $_POST['username'];
$password = $_POST['password'];

// Validate and sanitize input to prevent SQL injection (you should use prepared statements)
$username = mysqli_real_escape_string($conn, $username);

// Query the database to retrieve the hashed password for the given username
$query = "SELECT password FROM admins WHERE username='$username'";
$result = mysqli_query($conn, $query);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        // Fetch the hashed password from the result set
        $row = mysqli_fetch_assoc($result);
        $hashedPassword = $row['password'];

        // Verify the provided password against the hashed password
        if (password_verify($password, $hashedPassword)) {
            // User authenticated successfully
            echo "success";
        } else {
            // Authentication failed
            echo "failure";
        }
    } else {
        // Authentication failed (username not found)
        echo "failure";
    }
} else {
    // Query execution failed
    echo "error";
}

mysqli_close($conn);

?>
