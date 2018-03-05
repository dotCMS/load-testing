import scrapy


class GetsiteSpider(scrapy.Spider):
    name = "getsite"

    def start_requests(self):
        urls = [
            'http://dotcms-430/products/',
            'http://dotcms-430/resources/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        page = response.url.split("/")
        filename = 'dotcms-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)
