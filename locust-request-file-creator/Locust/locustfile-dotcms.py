from locust import HttpLocust, TaskSet, task


class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """
        self.login()

    def login(self):
        self.client.post("/dotAdmin", {"username":"admin@dotcms.com", "password":"admin"})

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000

class MyTaskSet(TaskSet):
    
    @task(10)
    def index(self):
        self.client.get("/")

    @task(10)
    def about(self):
        self.client.get("/about-us")

    @task(10)
    def bearmountain(self):
        self.client.get("/bear-mountain")

    @task(2)
    def blogs(self):
        self.client.get("/blogs")

    @task(5)
    def contactus(self):
        self.client.get("/contact-us")

    @task(2)
    def goquest(self):
        self.client.get("/go-quest")

    @task(2)
    def products(self):
        self.client.get("/products")

    @task(2)
    def resources(self):
        self.client.get("/resources")

    @task(2)
    def services(self):
        self.client.get("/services")


class MyLocust(HttpLocust):
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000