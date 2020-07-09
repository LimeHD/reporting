#!/usr/bin/env ruby
#
require "http"
require 'pry'

TOKEN = ENV['TOKEN']
ACCOUNT_ID = ENV['ACCOUNT_ID']

def get(url)
  JSON.parse HTTP
    .headers( 'X-TrackerToken' => TOKEN )
    .get(url)
    .body
end

MEMBERS = {}
get("https://www.pivotaltracker.com/services/v5/accounts/#{ACCOUNT_ID}/memberships").each do |member|
  MEMBERS[member['id']]=member['person']['name']
end

PROJECTS = get("https://www.pivotaltracker.com/services/v5/projects").map { |p| p['id'] }

ATTRS = %w(created_at owned_by_id name description)

FILE='report.csv'

month = $ARGV[0] || DateTime.now.prev_month.strftime("%Y-%m")
puts "Скидываю отчёт в report.csv по месяцу #{month}"

require 'csv'
CSV.open("report.csv", "w", { col_sep: "," }) do |csv|
  csv << ['Задача создана', 'Участники', 'Отметки', 'Название', 'Детали']
  PROJECTS.each do |project_id|
    get("https://www.pivotaltracker.com/services/v5/projects/#{project_id}/stories").
      map do |story|
      times = [story['created_at'], story['updated_at'], story['accepted_at']].compact
      if times.find { |time| time.include? month }
        # Удалил детали так как за июнь он портят CSV и она не правращается в Excel
        csv << [story['created_at'], MEMBERS[story['owned_by_id']], story['labels'].map { |l| l['name'] }.join(','), story['name']]
      end
    end
  end
end
