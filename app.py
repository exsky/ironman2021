import argparse
from datetime import datetime
from libs.log import log
from libs.creator import Creator, Mode
from libs.keysetup import gen_mail_ini, gen_aws_credential
from libs.sendmail import MailSender as ms


app_log = log('app')


def get_log_content():
    with open('news/news_quick.txt', 'r') as file:
        data = file.read()
        data += "===== Log =====\n"
    with open('running.log', 'r') as file:
        data += file.read()
        return data


def send_quicknews_to_subscriber():
    now = datetime.now()
    title = '即時風向 - {}'.format(now.strftime('%Y-%m-%d %H:%M'))
    content = get_log_content()
    mail = ms(title, content)
    print('Mail ready ...')
    app_log.info('Mail ready')
    mail.send_mail()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="An Ironman News demo")
    parser.add_argument("-t", "--title", help="Fetch titles only text",
                        action='store_true')
    parser.add_argument("-l", "--link", help="Fetch title and link ext",
                        action='store_true')
    parser.add_argument("-q", "--quick", help="Fetch recommand news",
                        action='store_true')
    parser.add_argument("-c", "--category", help="Create titles only text",
                        dest="category")
    parser.add_argument("-a", "--all", help="All above text files",
                        dest="all", action='store_true', default=False)
    args = parser.parse_args()

    # Entrypoint
    try:
        app_log.info('跑跑跑!!')
        print(args)
        gen_mail_ini()
        if args.title:
            ctr = Creator(Mode.TITLE)
            ctr.gen_file()
        if args.link:
            ctr = Creator(Mode.LINK)
            ctr.gen_file()
        if args.quick:
            ctr = Creator(Mode.QUICK)
            ctr.gen_file()
            send_quicknews_to_subscriber()
        if args.category:
            print(arg.category)
        if True not in [args.title, args.link, args.quick]:
            # Default
            ctr = Creator(Mode.QUICK)
            ctr.gen_file()
            gen_aws_credential()
            send_quicknews_to_subscriber()
        print('Crawling Complete !!')
    except Exception as e:
        print(e)
