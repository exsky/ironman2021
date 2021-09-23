import argparse
from datetime import datetime
from libs.keysetup import gen_mail_ini, gen_aws_credential
from libs.log import log
from libs.sendmail import MailSender as ms


app_log = log('app')


def get_log_content():
    with open('running.log', 'r') as file:
        data = file.read()
        return data


def send_quicknews_to_subscriber():
    gen_mail_ini()
    now = datetime.now()
    title = 'EXSKY 鐵人賽的 發信程式 - {}'.format(now.strftime('%Y-%m-%d %H:%M'))
    content = get_log_content()
    mail = ms(title, content)
    print('Mail ready ...')
    app_log.info('Mail ready')
    mail.send_mail()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Ironman 2021 demo")
    args = parser.parse_args()

    # Entrypoint
    try:
        app_log.info('跑跑跑!!')
        # mail to maintainer
        send_quicknews_to_subscriber()
        gen_aws_credential()
    except Exception as e:
        app_log.exception(e)
