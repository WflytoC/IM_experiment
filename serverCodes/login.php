<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	require_once 'sendEmail.php';
	require_once 'ServerAPI.php';
	$success = array("code"=>"ok");
	$failure = array("code"=>"no");
	$notactive = array("code"=>"notactive");

	if(isset($_GET['user_name']) && isset($_GET['user_password'])){//1

		$user_name = $_GET['user_name'];
		$user_password = $_GET['user_password'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();

		if($link == "no") {//2
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}

		$query = "SELECT * FROM table_user where user_email= '$user_name' and user_password= '$user_password' ";
		$result = mysql_query($query,$link);
		$row = mysql_num_rows($result);


		if($row > 0) {//3
			//进入此代码块，表明用户已注册过
			//下面判断邮箱是否激活
			$again = "SELECT * FROM table_user where user_email= '$user_name' and user_password= '$user_password' and user_active = 1 ";
			$res = mysql_query($again,$link);
			$r = mysql_num_rows($res);
			if ($r > 0) {//4
				//用户账号存在，且已经激活过，检查token是否存在
				$checkToken = "SELECT * FROM table_user where user_email= '$user_name' and user_password= '$user_password' and user_active = 1 and user_token = 'no' ";
				$resu = mysql_query($checkToken,$link);
				$num = mysql_num_rows($resu);

				if ($num > 0) {//5
					//没有token,则向融云请求token
					$p = new ServerAPI('c9kqb3rdkusvj','Wwk7Bk8WE3WV');
					$token = $p->getToken($user_name,$user_name,'http://youneed.duapp.com/images/icon.jpg');
					if (!$token) {//6
						echo json_encode($failure,JSON_UNESCAPED_UNICODE);
						exit();
					}else {//7
						$de_json = json_decode($token,TRUE);
						$realToken = $de_json['token'];
						$tokensql = "UPDATE table_user SET user_token = '$realToken' where user_email = '$user_name' ";
						if (!mysql_query($tokensql,$link)) {//8
							echo json_encode($failure,JSON_UNESCAPED_UNICODE);
							exit();
						}
						$data = array("code"=>"ok","token"=>$realToken);
						echo json_encode($data
							,JSON_UNESCAPED_UNICODE);
					}


				}else {//9
					//有token
					$obtainSql = "SELECT * FROM table_user where user_email= '$user_name' and user_password= '$user_password' and user_active = 1 ";
					$resus = mysql_query($obtainSql,$link);
					$tokens = array("code"=>"ok");
					while($row=mysql_fetch_array($resus)){
						$new = array("token"=>$row['user_token']);
						$tokens = $tokens + $new;
					}
					echo json_encode($tokens,JSON_UNESCAPED_UNICODE);

				}

				
			}else {//10
				echo json_encode($notactive,JSON_UNESCAPED_UNICODE);
				$manager = new manager();
				$manager->sendEmail($user_name);
			}


		}else {//11
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
		}


    }
?>