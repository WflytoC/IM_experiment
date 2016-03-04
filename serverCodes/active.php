<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	if(isset($_GET['user_email'])) {
		$user_email = $_GET['user_email'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();
		if($link == "no") {
			echo "您的邮箱未能激活";
			exit();
		}
		$sql = "UPDATE table_user SET user_active = 1 where user_email = '$user_email' ";
		if (!mysql_query($sql,$link)) {
			echo "您的邮箱未能激活";
			exit();
		}
		echo '您的邮箱已经激活';
	}

?>