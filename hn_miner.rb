require 'open-uri'
require 'nokogiri'

require_relative 'entry'

# Datamining for hackernytt.se
module HNMiner
  ROOT_URL = 'http://hackernytt.se/nya'

  # Store entries from specified day
  def self.store_entries_from(day)
    doc = Nokogiri::HTML open(ROOT_URL).read

    doc.css('article').each do |element|
      date = Date.parse_from_element(element)

      next unless date == day

      Entry.create({
        title: element.css('h1').text,
        date: date,
        url: element.css('h1 a').attribute('href').value,
        comments_url: element.css('.comments-link a').attribute('href').value,
        points: element.css('.totalpoints').text.match(/^\d/)[0].to_i
      })
    end
  end
end

class Date
  # Create a new Date object by parsing from a Nokogiri::XML::Element.
  def self.parse_from_element(element)
    Date.parse element.css('time').attribute('datetime').value
  end
end
