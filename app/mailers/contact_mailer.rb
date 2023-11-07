class ContactMailer < ApplicationMailer
  def send_mail(mail_title, mail_content, group_users, group)#メソッドに対して引数を指定
    @mail_title = mail_title
    @mail_content = mail_content
    @group = group
    mail bcc: group_users.pluck(:email), subject: mail_title
  end
end
