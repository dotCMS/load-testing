from locust import HttpLocust, TaskSet, task

class MyTaskSet(TaskSet):

    @task(15)
    def index(self):
        self.client.get("/")

    @task(2)
    def about(self):
        self.client.get("/about-us")

    @task(5)
    def about_locations(self):
        self.client.get("/about-us/locations")

    @task(10)
    def about_our_team(self):
        self.client.get("/about-us/our-team")

    @task(10)
    def contactus(self):
        self.client.get("/contact-us")

    @task(2)
    def resources(self):
        self.client.get("/resources")

    @task(2)
    def resources_images(self):
        self.client.get("/resources/images")

    @task(10)
    def resources_videos(self):
        self.client.get("/resources/videos")

    @task(2)
    def services_investors(self):
        self.client.get("/services/first-time-investors")

    @task(2)
    def services_retirees(self):
        self.client.get("/services/retirees")

    @task(2)
    def global_investors(self):
        self.client.get("/services/global-investors")

    @task(5)
    def wealth_managers(self):
        self.client.get("/services/wealth-managers")

    @task(10)
    def news(self):
        self.client.get("/news-events/news")

    @task(2)
    def news_events(self):
        self.client.get("/news-events/events")

    @task(2)
    def demos_containers(self):
        self.client.get("/demos/containers")

    @task(2)
    def demos_mobile(self):
        self.client.get("/demos/mobile-apps")

    @task(2)
    def demos_rest(self):
        self.client.get("/demos/rest-content-save")

    @task(2)
    def demo_remote(self):
        self.client.get("/demos/remote-widget")

    @task(10)
    def demo_geolocation(self):
        self.client.get("/demos/content-geolocation")

class MyLocust(HttpLocust):
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000