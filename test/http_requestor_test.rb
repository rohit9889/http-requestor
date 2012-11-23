require "../lib/http_requestor"
require "../lib/http_requestor_multipart"
require "test/unit"
 
class HttpRequestorTest < Test::Unit::TestCase
  def test_should_get_data_when_request_type_not_specified
    assert_equal("200", HTTP::Requestor.request("http://en.wikibooks.org", "", "/wiki/Ruby_Programming/Unit_testing#A_Simple_Introduction").code )
  end
  
  def test_should_post_file_properly
    headers = {"application_api_key" => "bltc5b185cd6884ae87", "application_uid" => "blt2f37284c14b6b453"}
    uri = "http://localhost:3000/files.json"
    f=File.open("testfile.txt", "w+")
    f.syswrite("This is testing")
    f.close
    data = {:object => {:title => "This is from http-requestor", :file1 => File.open("testfile.txt")}}

    assert_equal("201", HTTP::Requestor.multipart_request(uri, "post", data, headers).code)
  end
  
  def test_should_post_file_properly_with_instance_method_used
    http = HTTP::Requestor.new("http://localhost:3000")
    
    headers = {"application_api_key" => "bltc5b185cd6884ae87", "application_uid" => "blt2f37284c14b6b453"}
    path = "/files.json"
    f=File.open("testfile.txt", "w+")
    f.syswrite("This is testing")
    f.close
    data = {:object => {:title => "This is from http-requestor", :file1 => File.open("testfile.txt")}}

    assert_equal("201", http.post_multipart(path, data, headers).code)
  end
  
  def test_should_post_multiple_files
    headers = {"application_api_key" => "bltc5b185cd6884ae87", "application_uid" => "blt2f37284c14b6b453"}
    uri = "http://localhost:3000/multiplefiles.json"
    f=File.open("testfile.txt", "w+")
    f.syswrite("This is testing")
    f.close
    data = {:object => {:title => ["Title 1", "Title 2"], :file => [File.open("testfile.txt"), File.open("testfile.txt")]}}

    assert_equal("201", HTTP::Requestor.multipart_request(uri, "post", data, headers).code)
  end
end