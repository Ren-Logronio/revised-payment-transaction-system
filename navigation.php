
<link rel="stylesheet" type="text/css" href="src/style/navigation.css" >

<?php

require('includes/session.php');

/*
CODE FOR TESTING : DISREGARD
session_start();
$state = $_SESSION['LOGGED'];
echo "<script>alert('session is $state');</script>";
*/
?>

<?php 

if(isset($_SESSION['LOGGED']) && $_SESSION['LOGGED'] == true) : ?>

<nav class="navigation header">
    <ul>
        <li>MSU Payment System</li>
        <li>MSU Gensan Website</li>
        <li>Organization</li>
        <li class="right">Account Dropdown</li>
    </ul>
</nav>

<?php else : ?>

<nav class="navigation header">
    <ul>
        <li>MSU Payment System</li>
        <li>MSU Gensan Website</li>
        <li>//check if logged in</li>
        <li class="right">(<a href="login.php">Log in</a>)</li>
        <li class="right">Register</li>
    </ul>
</nav>

<?php endif; ?>