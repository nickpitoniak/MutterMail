<?php

$secretKey = $_REQUEST['secretKey'];
$message = $_REQUEST['message'];
$subject = $_REQUEST['subject'];

if($secretKey == "kjdfb4u7bksSDDF44wlksdnw33j4") {

$message = wordwrap($message,70);
if(mail("iamnickpitoniak@gmail.com", $subject, $message)) {
    echo "success";
} else {
    echo "errorr";
}
 
 
} else {
    echo "errori";
}
?>