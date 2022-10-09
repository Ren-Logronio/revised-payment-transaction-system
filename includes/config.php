<?php

# CONNECTION MODULE TO DBMS
# USE INCLUDE BEFORE QUERYING

$databaseHost = 'localhost';
$databaseName = 'payment_system';
$databaseUsername = 'root';
$databasePassword = 'pass123';

$con = $mysqli->connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);

if($mysqli->connect_errno())
{
    die("Connection was not established");
}


?>