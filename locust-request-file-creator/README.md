Load tool: 

https://locust.io


virtualenv -p python3 venv 

source venv/bin/activate --> python3

pip install locustio 

Scrapy Tool:

https://scrapy.org

virtualenv -p python3 venv 

source venv/bin/activate --> python3

virtualenv -p python3 venv 

pip install scrapy 

Case 1 - Fetch html page!

File 1 
.../spiders/getsite.py

It has crawled the whole html content from dotcms pages (.../products and .../resources) and just saved into 2 .html files!

CMD :

scrapy crawl getsite 

Case 2 - Crawl local dotcms installation with spider!

File 2
.../spiders/getsite2.py

It has crawled/extracted the data described in the start_urls session and parsed along with ...dotcms/items.py file using xpath instructions.

CMD :

scrapy crawl getsite2 -o dotcms.csv -t csv

scrapy crawl getsite2 -o dotcms.json -t json

where :
-o = output
-t = type

JSON and/or CSV's files.


Case 3 0 Crawl demo.dotcms with spider!


![Alt text](printscreen.png)

path : load-testing/locust-request-file-creator/Scrapy.Crawler/demo_dotcms/demo_dotcms/

CMD :

scrapy crawl demodotcms

CMD 2 (option to store data) in json file!

scrapy crawl demodotcms -o demodotcms.json -t json


