from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """
        self.login()

    def login_intranet(self):
        self.client.post("/intranet", { "username":"bill@dotcms.com", "password":"bill"})

    def login_dotAdmin(self):
        self.client.post("/dotAdmin", { "username": "admin@dotcms", "password":"admin"})
       
class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 2000
    max_wait = 9000

class MobileUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 2000
    max_wait = 9000

class MyTaskSet(TaskSet):

    @task (15)
    def login_intranet(self):
        self.client.post("/intranet")

    @task(10)
    def login_dotAdmin(self):
        self.client.post("/dotAdmin")

class MyLocust(HttpLocust):
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000