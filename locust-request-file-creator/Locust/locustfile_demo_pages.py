from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """
        self.login()

    def login(self):
        self.client.post("/dotAdmin", {"username":"admin@dotcms.com", "password":"admin"})

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 2000
    max_wait = 9000

class MobileUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 2000
    max_wait = 9000

class MyTaskSet(TaskSet):

    @task(15)
    def index(self):
        self.client.get("/")

    @task(13)
    def about(self):
        self.client.get("/about-us/our-team")
 
    @task(12)
    def bearmountain(self):
        self.client.get("/bear-mountain")

    @task(11)
    def blogs(self):
        self.client.get("/blogs")

    @task(10)
    def contactus(self):
        self.client.get("/contact-us")

    @task(9)
    def goquest(self):
        self.client.get("/go-quest")

    @task(8)
    def products(self):
        self.client.get("/products")

    @task(19)
    def resources(self):
        self.client.get("/demos/content-geolocation")

    @task(5)
    def services(self):
        self.client.get("/services/wealth-managers")

class MyLocust(HttpLocust):
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000