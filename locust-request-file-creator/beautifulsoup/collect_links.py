#!/usr/local/bin/python3
import sys
import requests
import bs4

if len(sys.argv) == 3:
    # If arguments are satisfied store them in readable variables
    url = 'http://%s' % sys.argv[1]
    file_name = sys.argv[2]

    print('Grabbing the page...')
    # Get url from command line
    response = requests.get(url)
    response.raise_for_status()

    # Retrieve all links on the page
    soup = bs4.BeautifulSoup(response.text, 'html.parser')
    links = soup.find_all('a')

    file = open(file_name, 'wb')
    print('Collecting the links...')
    for link in links:
        href = "{0}\n".format(link.get("href"))
        file.write(href.encode())
    file.close()
    print('Saved to %s' % file_name)
else:
    print('Usage: python3 collect_links.py www.example.com file.txt')
