function conf_mail(text, filename)

send_address = 'matlabnotification@tiscali.it';
receive_address = 'manuel.roveri@gmail.com';
mypassword = 'matlabnotificati';

setpref('Internet','E_mail',send_address);
setpref('Internet','SMTP_Server','smtp.tiscali.it');
setpref('Internet','SMTP_Username',send_address);
setpref('Internet','SMTP_Password',mypassword);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

if isempty(filename)
    sendmail(receive_address, 'Task started', text);
else
    sendmail(receive_address, 'Task completed', ['The program ' text ' has been completed'],filename);
end
