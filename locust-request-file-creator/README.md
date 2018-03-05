#Load tool: 

https://locust.io 

pip install locustio 

venv python3

Scrapy Tool:

https://scrapy.org

venv python3

pip install scrapy 

File 1 

.../spiders/getsite.py

It has crawled the whole html content from dotcms pages (.../products and .../resources) and just saved into 2 .html files!

CMD :
scrapy crawl getsite 


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



