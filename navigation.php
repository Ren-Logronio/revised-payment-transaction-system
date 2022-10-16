
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
<header>
    <nav class="navigation header">
        <ul>
            <img/>
            <li>MSU Payment System</li>
            <li><a>MSU Gensan Website</a></li>
            <li><a>Organization</a></li>
            <li class="right"><a>Account Dropdown</a></li>
        </ul>
        <a class="btn" href="logout.php">Log out</a>
    </nav>
</header>

<?php else : ?>

<div class="header">
    <nav class="navigation">
        <ul class="left">
            <img class="logo" src="#"/>
            <li>MSU Payment System</li>
            <li><a href="#">MSU Gensan Website</a></li>
        </ul>
        <a>You are not logged in</a>
        <a class="btn" href="login.php">Log in</a>
        <a class="btn" href="register.php">Register</a>
    </nav>
</div>

<?php endif; ?>