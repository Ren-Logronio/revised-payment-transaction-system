<?php

require('includes/config.php');
require('includes/session.php');

$_SESSION['LOGGED'] = false;

if(isset($_SESSION['LOGGED']) && $_SESSION['LOGGED'] == true){
    header('Location: home.php');
    exit();
} else {
    session_unset();
}


?>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>MSU Payment System: Welcome</title>
        <link rel="icon" type="image/png" href="scr/images/icon.png" />
        <link rel="stylesheet" type="text/css" href="src/style/main.css" />
    </head>
    <body>
        <?php include('navigation.php');?>

        <!--
        <nav class="navigation header">
            <ul>
                <li>MSU Payment System</li>
                <li>MSU Gensan Website</li>
                <li>//check if logged in</li>
                <li>(Log in)</li>
                <li>Register</li>
            </ul>
        </nav>
-->
        Welcome to MSU Payment System
        Login to access 
    </body>
</html>