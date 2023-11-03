# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
  time_zones = ['Bogota', 'Sydney', 'Mountain Time (US & Canada)']

  time_zones.each do |time_zone|
    user =  User.find_or_create_by!(time_zone: time_zone)
    puts "User found/created in time zone #{time_zone} with ID: #{user.id}"
  end
