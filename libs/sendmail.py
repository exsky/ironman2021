import re
import smtplib
from configparser import ConfigParser
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from libs.connector import Connector
from libs.log import log


app_log = log('sendmail')

class SMSSender(Connector):

    def __init__(self):
        super(SMSSender, self).__init__('sns')
        self.sns = self.connect_aws_service()
        self.number = None
        self.content = None

    def send_sms_message(self, num=None, msg=None):
        if not num:
            num = self.number
        if not msg:
            msg = self.content
        try:
            self.sns.publish(PhoneNumber=num, Message=msg)
            app_log.info('Send SMS to {}, MSG: {}'.format(num, msg))
        except Exception as e:
            app_log.exception(e)


class MailSender:

    def __init__(self, title=None, content=None, revicer_addr=None):
        cfg = ConfigParser()
        cfg.read('users/mail.ini')
        self.content = MIMEMultipart()
        # Specific Sender or Default Sender
        self.sender = cfg['DEFAULT']['SenderAddress']
        self.sender_secret = cfg['DEFAULT']['SenderSecret']
        if not revicer_addr:
            receiver_str = cfg['DEFAULT']['ReciverAddress']
        else:
            receiver_str = reciver_addr
        self.receiver = re.findall(r"[\w\+]+@\w+[^,\s]*", receiver_str)
        # Setup receiver(s)
        self.content['from'] = self.sender
        self.content['to'] = ','.join(self.receiver)

        # Load mail title if value
        if title:
            self.content['subject'] = title
        else:
            self.content['subject'] = 'The news crawler mail'

        # Load mail content if value
        if content:
            self.content.attach(MIMEText(content, 'plain', 'utf-8'))

    def set_title(self, title):
        self.title = str(title)

    def set_content(self, mail_content):
        self.content.attach(MIMEText(mail_content, 'plain', 'utf-8'))

    def send_mail(self):
        with smtplib.SMTP(host="smtp.gmail.com", port="587") as smtp:  # ??????SMTP?????????
            try:
                smtp.ehlo()
                smtp.starttls()
                smtp.login(self.sender, self.sender_secret)
                smtp.send_message(self.content)
                print("Send Mail succeed: "+str(self.receiver))
            except Exception as e:
                print("Error message: ", e)
