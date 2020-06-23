require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open('fixtures/student-site/index.html')
    doc = Nokogiri::HTML(html)
    
    scraped_students = []
    
    students = doc.css(".student-card")
    students.each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attr("href").text
      hash = {:name => name,
      :location => location,
      :profile_url => profile_url
    }
    scraped_students << hash
  end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    student_profiles = {}
   
    social_link = doc.css(".vitals-container .social-icon-container a")
    
    social_link.each do |element|
      if element.attr("href").include?("twitter")
        student_profiles[:twitter] = element.attr('href')
      elsif element.attr("href").include?("linkedin")
        student_profiles[:linkedin] = element.attr("href")
      elsif element.attr("href").include?("github")
        student_profiles[:github] = element.attr("href")
      elsif element.attr("href").include?("com/")
      student_profiles[:blog] = element.attr("href")
      end
    end
    
    student_profiles[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    student_profiles[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text
    
    student_profiles
  end
end