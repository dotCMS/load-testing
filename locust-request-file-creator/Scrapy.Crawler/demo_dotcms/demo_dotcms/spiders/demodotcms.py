# -*- coding: utf-8 -*-
import scrapy

class DemodotcmsSpider(scrapy.Spider):
    name = 'demodotcms'
    allowed_domains = ['demo.dotcms.com']
    start_urls = ['http://demo.dotcms.com/products/']

    def parse(self, response):
        products = response.xpath('//table[@class="table table-striped sorted-tables product-listing"]').extract()
        for product in products:
            yield {'Product': product}
