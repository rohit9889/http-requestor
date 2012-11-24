require 'http_requestor'

res = HTTP::Requestor.request("http://en.wikibooks.org", "", "/wiki/Ruby_Programming/Unit_testing#A_Simple_Introduction")
puts res.inspect

uri = "https://www.google.co.in/searchbyimage/upload"
f=File.open("testfile.txt", "w+")
f.syswrite("This is testing")
f.close
data = {:encoded_image => File.open("testfile.txt")}
HTTP::Requestor.multipart_request(uri, "post", data)