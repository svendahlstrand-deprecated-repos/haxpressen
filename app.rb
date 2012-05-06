# encoding: utf-8

require_relative 'lib/haxpressen'

# Simple rack app that shows a RSS feed with a daily summary
# of Hackernytt articles.
class App
  def call(env)
    [200, {'Content-Type' => 'application/rss+xml'}, [xml]]
  end

  private

  # A summary for a specified day. Get the top 5 articles by most points.
  # The summary is a presented in a HTML list.
  def summary_for(day)
    entries = Entry.where(date: day).order_by([:points, :desc]).limit(5)

    if entries.any?
      [
        '<ul>',
          entries.map do |entry|
            "<li><a href=\"#{entry.url}\">#{entry.title}</a> (<a href=\"#{entry.comments_url}\">Kommentarer</a>)</li>"
          end.join(''),
        '</ul>'
      ].join('')
    end
  end

  # Returns an array with the ten last days.
  def last_ten_days
    today = Date.today

    10.times.map do |i|
      today - (i + 1)
    end
  end

  # The xml (RSS feed) for the ten last days.
  def xml
    xml = Builder::XmlMarkup.new(indent: 2)

    xml.instruct! :xml, encoding: 'UTF-8'
    xml.rss version: '2.0' do |rss|
      rss.channel do |channel|
        channel.title 'Haxpressen'

        last_ten_days.each do |day|
          summary = summary_for day

          if summary.present?
            channel.item do |item|
              item.title "Sammanfattning för #{day}"
              item.pubDate day
              item.description summary
            end
          end
        end
      end
    end
  end
end
