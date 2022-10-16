<?php

require('includes/session.php');

if(isset($_SESSION['LOGGED']) && $_SESSION['LOGGED'] == true){
    unset($_SESSION['LOGGED']);
} 


if(isset($_SESSION['USER'])) {
    unset($_SESSION['USER']);
}

header('Location: index.php')

?>