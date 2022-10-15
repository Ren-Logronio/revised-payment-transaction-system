<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$adminname = 'testadmin';
$adminpassword = "pass123";

$databaseHost = 'localhost';
$databaseName = 'payment_system';
$databaseUsername = 'root';
$databasePassword = 'pass123';

$db = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);

if(mysqli_connect_errno())
{
    die("Connection was not established");
}


$admin = mysqli_real_escape_string($db, $adminname);
$adminpassword_hash = mysqli_real_escape_string($db,hash('sha256', $adminpassword));

$admin_query = "INSERT INTO user_account (username, authentication, user_password_hash, isStudent) VALUES ('$adminname', 'ADMIN', '$adminpassword_hash', false);";

$exists = mysqli_num_rows(mysqli_query($db,"SELECT * FROM user_account WHERE username = '$adminname';"));

if(isset($exists) && $exists == 1){
    // do nothing
} else {
    mysqli_query($db, $admin_query);
}

?>