import scrapy

from dotcms.items import NewItem

class GetSite2(scrapy.Spider):
    name = 'getsite2'
    allowed_domains = ["dotcms-430"]
    start_urls = [
        'http://dotcms-430/products', 'http://dotcms-430/bear-mountain',
        'http://dotcms-430/about-us', 'http://dotcms-430/blogs',
        'http://dotcms-430/contact-us', 'http://dotcms-430/go-quest',
        'http://dotcms-430/resources', 'http://dotcms-430/services',
    ]

    def parse(self, response):
        item = NewItem()
        item['main_headline']=response.xpath('//span/text()').extract()
        item['headline']=response.xpath('//title/text()').extract()
        item['url']=response.url
        item['project']=self.settings.get('BOT_NAME')
        item['spider']=self.name

        return item
