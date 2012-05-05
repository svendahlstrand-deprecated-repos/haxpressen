# Datamining for hackernytt.se
module Miner
  ROOT_URL = 'http://hackernytt.se/nya'

  # Store entries from specified day
  def self.store_entries_from(day)
    doc = Nokogiri::HTML open(ROOT_URL).read
    log = Logger.new(STDOUT)

    doc.css('article').each do |element|
      title =  element.css('h1').text
      date = Date.parse_from_element(element)
      url = element.css('h1 a').attribute('href').value

      next unless date == day

      if Entry.where(url: url).first.nil?
        entry = Entry.create({
          title: title,
          date: date,
          url: url,
          comments_url: element.css('.comments-link a').attribute('href').value,
          points: element.css('.totalpoints').text.match(/^\d/)[0].to_i
        })

        log.info "Stored #{title}"
      else
        log.info "Skipped #{title}, already in database"
      end
    end
  end
end

class Date
  # Create a new Date object by parsing from a Nokogiri::XML::Element.
  def self.parse_from_element(element)
    Date.parse element.css('time').attribute('datetime').value
  end
end
