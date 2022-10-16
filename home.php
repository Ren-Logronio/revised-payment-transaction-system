<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>MSU Payment System: Home</title>
        <link rel="icon" type="image/png" href="scr/images/icon.png" />
        <link rel="stylesheet" type="text/css" href="src/style/main.css" />
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

        
        Welcome to MSU Payment System, <?php $name = $_SESSION['USER']; echo "$name";?>
    </body>
</html>