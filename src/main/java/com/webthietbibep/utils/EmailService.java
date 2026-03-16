package com.webthietbibep.utils;

public class EmailService {

    public static void sendVerifyEmail(String toEmail, String token, String username) {
        String verifyLink = "http://localhost:8080/WebThietBiBep_war/verify?token=" + token;

        String content = """
        <div style="
            max-width:600px;
            margin:0 auto;
            font-family:Arial, Helvetica, sans-serif;
            background:#ffffff;
            border-radius:10px;
            box-shadow:0 4px 12px rgba(0,0,0,0.1);
            padding:30px;
        ">

            <h2 style="text-align:center;color:#2c3e50;">
                Xác thực tài khoản
            </h2>

            <p style="font-size:15px;color:#333;">
                Xin chào <strong>%s</strong>,
            </p>

            <p style="font-size:15px;color:#555;line-height:1.6;">
                Cảm ơn bạn đã đăng ký tài khoản tại <strong>Website Thiết Bị Bếp Thông Minh</strong>.
                Vui lòng nhấn vào nút bên dưới để kích hoạt tài khoản của bạn.
            </p>

            <div style="text-align:center;margin:30px 0;">
                <a href="%s"
                   style="
                       background:#27ae60;
                       color:#ffffff;
                       padding:14px 28px;
                       text-decoration:none;
                       border-radius:6px;
                       font-size:16px;
                       font-weight:bold;
                       display:inline-block;
                   ">
                    KÍCH HOẠT TÀI KHOẢN
                </a>
            </div>

            <p style="font-size:13px;color:#888;">
                Nếu nút trên không hoạt động, hãy nhấp vào liên kết sau:
            </p>

            <p style="font-size:13px;word-break:break-all;">
                <a href="%s">%s</a>
            </p>

            <hr style="margin:30px 0;border:none;border-top:1px solid #eee;">

            <p style="font-size:12px;color:#999;text-align:center;">
                © 2026 Website Thiết Bị Bếp Thông Minh
            </p>
        </div>
    """.formatted(username, verifyLink, verifyLink, verifyLink);

        MailUtil.sendHtmlMail(toEmail, "Xác nhận tài khoản", content);
    }
}
