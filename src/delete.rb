require 'net/http'
require 'rexml/document'
require 'cgi'

address = "high-day-4253.herokuapp.com"

Net::HTTP.start( address ) do |http|
  list_page = http.get("/articles")
  list_page_doc = REXML::Document.new list_page.body
  authenticity_token = ""
  list_page_doc.elements.each('html/head/meta') do |element|
    if element.attribute('name').value == "csrf-token"
      authenticity_token = element.attribute('content').value
    end
  end
  articles_ids = []
  list_page_doc.elements.each('html/body/table/tr/td/a') do |element|
    if element.text == 'Destroy'
      path = element.attribute('href').value
      path =~ /\d+/
      articles_ids << Regexp.last_match.to_s
    end
  end
  articles_ids.each do |id|
    request = Net::HTTP::Post.new("/articles/" + id)
    request.set_form_data({
      :_method => 'delete',
      :authenticity_token => authenticity_token
    }, "&")
    response = http.request(request)
  end

end