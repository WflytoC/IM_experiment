<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	require_once 'sendEmail.php';
	$success = array("code"=>"ok");
	$failure = array("code"=>"no");
	$repeat = array("code"=>"repeat");
	if(isset($_GET['user_name']) && isset($_GET['user_password'])){
		$user_name = $_GET['user_name'];
		$user_password = $_GET['user_password'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();
		if($link == "no") {
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}
		$query = "SELECT * FROM table_user where user_email= '$user_name' ";
		$result = mysql_query($query,$link);
		$row = mysql_num_rows($result);
		if($row > 0) {
			echo json_encode($repeat,JSON_UNESCAPED_UNICODE);
			exit();
		}
		$sql = "INSERT INTO table_user (user_name,user_password,user_email,user_active) VALUES ('匿名','$user_password','$user_name',0)";
		if (!mysql_query($sql,$link)) {
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}
		$manager = new manager();
		$manager->sendEmail($user_name);
		echo json_encode($success,JSON_UNESCAPED_UNICODE);

    }
?>