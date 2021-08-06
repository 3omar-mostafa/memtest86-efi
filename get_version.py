#!/usr/bin/python3

# Extract memtest86 latest version info and its changelog

# Usage python3 get_version.py changelog_file version_long_file version_file
# It will grab the info from their website and save it into these three files

from bs4 import BeautifulSoup
import requests
import argparse
import re

def get_command_line_args():
    args = argparse.ArgumentParser()
    args.description = "Extract memtest86 latest version info and its changelog"
    args.add_argument("changelog_file", help="File to save latest version changelog")
    args.add_argument("version_long_file", help="File to save the long version name")
    args.add_argument("version_file", help="File to save version")
    return args.parse_args()


def main():
    args = get_command_line_args()

    src = requests.get("https://www.memtest86.com/whats-new.html").text
    html = BeautifulSoup(src, features="html.parser")

    whats_new_html = html.body.find('div', attrs={'class': 'faq-block whats-new-block'})
    open(args.changelog_file, "w").write(str(whats_new_html))

    version_long = whats_new_html.find('h3').text
    open(args.version_long_file, "w").write(version_long)

    version = re.match(r"Version ([0-9](\.[0-9])*) .*", version_long, flags=re.IGNORECASE).group(1)
    build = ''
    try :
        build = re.match(r"Version.*Build ([0-9]+).*", version_long, flags=re.IGNORECASE).group(1)
        build = f"_b{build}"
    except:
        pass

    open(args.version_file, "w").write(f"v{version}{build}")


if __name__ == "__main__":
    main()
