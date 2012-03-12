require 'net/http'
require 'rexml/document'
require 'cgi'

address = "high-day-4253.herokuapp.com"

Net::HTTP.start( address ) {|http|
  create_page = http.get("/articles/new")
  create_page_doc = REXML::Document.new create_page.body
  authenticity_token = ""
  create_page_doc.elements.each('html/body/form/div/input') do |element|
    if element.attribute('name').to_s == 'authenticity_token'
      authenticity_token = element.attribute('value').to_s
    end
  end
100.times do 
  request = Net::HTTP::Post.new("/articles/")
  request.set_form_data({
    'utf8' => "&#x2713;",
    'authenticity_token' => authenticity_token,
    'article[title]' => "hgoe",
    'article[location]' => "fuga",
    'article[excerpt]' => "foo",
    'article[body]' => "bar",
    'article[published_at(1i)]' => '2012',
    'article[published_at(2i)]' => '4',
    'article[published_at(3i)]' => '2',
    'article[published_at(4i)]' => '03',
    'article[published_at(5i)]' => '03'
    }, "&")
  response = http.request(request)
end
}