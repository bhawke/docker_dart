** Setup

If running a second time
docker rm -f db
docker rm -f web

docker run -d --name db mongo
docker build -t docker_dart .
docker run -d -p 8080:8080 --name web --link db:mongo docker_dart

http://192.168.59.103:8080
http://192.168.59.103:8080/users/list

* inserted test data
./mongoshell.sh
j = {name: "Rob"}
k = {name: "Bill"}
db.users.insert(j)
db.users.insert(k)

* reload
./reload.sh


* next steps
- figure out how to do this in gcloud yaml

