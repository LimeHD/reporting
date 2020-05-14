#!/usr/bin/env ruby
#
require "http"

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

puts "Скидываю отчёт в report.csv"

require 'csv'
CSV.open("report.csv", "w") do |csv|
  csv << ['Задача создана', 'Участники', 'Отметки', 'Название', 'Детали']
  PROJECTS.each do |project_id|
    get("https://www.pivotaltracker.com/services/v5/projects/#{project_id}/stories").
      map do |story|
      csv << [story['created_at'], MEMBERS[story['owned_by_id']], story['labels'], story['name'], story['description']]
    end
  end
end
