<?php
    //首先导入包含能发送电子邮件类`smtp`的`email.class.php`文件
    require_once "email.class.php";

    class manager{
        function sendEmail($email) {
            //下面开始设置一些信息
    $smtpserver = "smtp.qq.com";//SMTP服务器
    $smtpserverport =25;//SMTP服务器端口
    $smtpusermail = "1261810665@qq.com";//SMTP服务器的用户邮箱
    $smtpemailto =$email;//发送给谁(可以填写任何邮箱地址)
    $smtpuser = "1261810665";//SMTP服务器的用户帐号(即SMTP服务器的用户邮箱@前面的信息)
    $smtppass = "_WEIchuang123";//SMTP服务器的用户密码
    $mailtitle = 'UNeed';//邮件主题
    $mailcontent = "<a href=http://youneed.duapp.com/active.php?user_email=".$email.">点击这里激活账号</a>";//邮件内容
    $mailtype = "HTML";//邮件格式（HTML/TXT）,TXT为文本邮件

    $smtp = new smtp($smtpserver,$smtpserverport,true,$smtpuser,$smtppass);//这里面的一个true是表示使用身份验证,否则不使用身份验证.
    $smtp->debug = false;//是否显示发送的调试信息
    $state = $smtp->sendmail($smtpemailto, $smtpusermail, $mailtitle, $mailcontent, $mailtype);
    }
}
?>