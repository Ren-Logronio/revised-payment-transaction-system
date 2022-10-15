<?php
require('config.php');
require('includes/session.php');

if(isset($_SESSION['LOGGED']) && $_SESSION['LOGGED'] == true){
    $error = "You have already logged in";
    $_SESSION['LOGINERROR'] = $error;
    header('Location: ../home.php');
    exit();
}

if($_SERVER["REQUEST_METHOD"] == "POST"){
    
    $username = $_POST['username'];
    $password = $_POST['password'];

    $sqlusername = mysqli_real_escape_string($db, $username);
    $sqlpassword = mysqli_real_escape_string($db, hash('sha256', $password));
    
    /* test data
    $_SESSION['passhash'] = $sqlpassword;
    $_SESSION['username'] = $username;
    $_SESSION['password'] = $password;
    */

    $sql = "SELECT * FROM user_account WHERE username = '$sqlusername' AND '$sqlpassword'";
    $res = mysqli_query($db,$sql);
    $count = mysqli_num_rows($res);

    if(isset($count) && $count == 1){
        $_SESSION['USER'] = $username;
        $_SESSION['LOGGED'] = true;
        header('Location: ../home.php');
        die();
    } else {
        $error = "Invalid username or password";
        $_SESSION['LOGINERROR'] = $error;
        header('Location: ../login.php');
        die();
    }

}

?>