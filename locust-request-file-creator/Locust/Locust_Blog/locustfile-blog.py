from locust import HttpLocust, TaskSet, task

class MyTaskSet(TaskSet):

    @task(10)
    def blogs(self):
        self.client.get("/blogs")

    @task(5)
    def bearmountain(self):
        self.client.get("/bear-mountain")

    @task(15)
    def goquest(self):
        self.client.get("/go-quest")

    @task(2)
    def products(self):
        self.client.get("/products")

    
class MyLocust(HttpLocust):
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000