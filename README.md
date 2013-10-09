## There 4 simple http servers for file serving

almost useless bench on localhost:
```
server             rps
--------------------------
1-5-minute-server: 362.63
2-if-style:        3104.79
3-thread:          2929.07
4-eventmachine:    6379.21
```

```
cd 1-5-minute-server
ruby ws.rb --public /Users/b0oh --port 8081
ab -c 100 -n 10000 "http://localhost:8081/Pictures/1.jpg"
```
```
Server Software:        WEBrick/1.3.1
Server Hostname:        127.0.0.1
Server Port:            8081

Document Path:          /Pictures/1.jpg
Document Length:        57686 bytes

Concurrency Level:      100
Time taken for tests:   27.576 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      579330000 bytes
HTML transferred:       576860000 bytes
Requests per second:    362.63 [#/sec] (mean)
Time per request:       275.759 [ms] (mean)
Time per request:       2.758 [ms] (mean, across all concurrent requests)
Transfer rate:          20516.15 [Kbytes/sec] received
```
```
cd 2-if-style
ruby ws.rb --public /Users/b0oh --port 8082
ab -c 100 -n 10000 "http://localhost:8081/Pictures/1.jpg"
```
```
Server Software:
Server Hostname:        127.0.0.1
Server Port:            8082

Document Path:          /Pictures/1.jpg
Document Length:        57686 bytes

Concurrency Level:      100
Time taken for tests:   3.221 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      577730000 bytes
HTML transferred:       576860000 bytes
Requests per second:    3104.79 [#/sec] (mean)
Time per request:       32.208 [ms] (mean)
Time per request:       0.322 [ms] (mean, across all concurrent requests)
Transfer rate:          175168.80 [Kbytes/sec] received
```
```
cd 3-thread
ruby ws.rb --public /Users/b0oh --port 8083
ab -c 100 -n 10000 "http://127.0.0.1:8081/Pictures/1.jpg"

Server Software:
Server Hostname:        127.0.0.1
Server Port:            8083

Document Path:          /
Document Length:        15 bytes

Concurrency Level:      100
Time taken for tests:   3.414 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Non-2xx responses:      10001
Total transferred:      1060091 bytes
HTML transferred:       150000 bytes
Requests per second:    2929.07 [#/sec] (mean)
Time per request:       34.141 [ms] (mean)
Time per request:       0.341 [ms] (mean, across all concurrent requests)
Transfer rate:          303.23 [Kbytes/sec] received
```
```
cd 4-eventmachine
ruby ws.rb --public /Users/b0oh --port 8084
ab -c 100 -n 10000 "http://127.0.0.1:8081/Pictures/1.jpg"

Server Software:
Server Hostname:        127.0.0.1
Server Port:            8085

Document Path:          /
Document Length:        15 bytes

Concurrency Level:      100
Time taken for tests:   1.568 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Non-2xx responses:      10004
Total transferred:      810324 bytes
HTML transferred:       150060 bytes
Requests per second:    6379.21 [#/sec] (mean)
Time per request:       15.676 [ms] (mean)
Time per request:       0.157 [ms] (mean, across all concurrent requests)
Transfer rate:          504.81 [Kbytes/sec] received
```
