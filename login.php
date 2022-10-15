
<?php
require('includes/session.php');
include('includes/login.php');

?>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>MSU Payment System: Login</title>
        <link rel="icon" type="image/png" href="scr/images/icon.png" />
        <link rel="stylesheet" type="text/css" href="src/style/main.css" />
        <link rel="stylesheet" type="text/css" href="src/style/login.css" />
    </head>
    <body>
        <?php include('navigation.php');?>

        <?php 
            if(isset($_SESSION['LOGINERROR'])) :
            $error = $_SESSION['LOGINERROR'];
        ?>
            <h5><?php echo("$error");?></h5>
        <?php 
            unset($_SESSION['LOGINERROR']);
            endif;
        ?>

        <?php /* test data
            $test = $_SESSION['username'] . ' ' . $_SESSION['password'] . ' ' . $_SESSION['passhash'];
            echo("<br><br>" . $test . "<br><br>");
            */
        ?>

        <form action="" method="post">
            <label>Username/Email: </label><input type="text" name="username"/><!--TODO: FIND AN ALTERNATIVE TO <br> MARKUP--><br><br>
            <label>Password: </label><input type="password" name="password"/>
            <input type="submit" value="Log in">
        </form>
    </body>
</html>