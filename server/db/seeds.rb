# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Generates services
# [
#   { name: "Recorrido.cl"},
#   { name: "Arendi"},
#   { name: "Wanted"},
#   { name: "Funko"}
# ].each do |service_params|
#   service = Service.new(service_params)
#   if service.save
#     puts "service created: #{service.name}"
#   else
#     puts service.errors.inspect
#   end
# end

# # Generates users
service = Service.find_by_name("Funko")
# [
#   {
#     name: "tanjiro",
#     email: "tanjiro@funko.com",
#     password: "tanjirofunko",
#     service_id: service.id
#   },
#   {
#     name: "inosuke",
#     email: "inosuke@funko.com",
#     password: "inosukefunko",
#     service_id: service.id
#   },
#   {
#     name: "zenitsu",
#     email: "zenitsu@funko.com",
#     password: "zenitsufunko",
#     service_id: service.id
#   }
# ].each do |user_params|
#   user = User.new(user_params)
#   if user.save
#     puts "user created: #{user.name}"
#   else
#     puts user.errors.inspect
#   end
# end

# Generates workshifts
workshifts_count = 0
(19..23).each do |hour|
  workshift = Workshift.new(
    {
      timestamp: DateTime.new(2022,5,14,hour,0),
      service_id: service.id,
      user_id: User.pluck(:id).sample
    }
  )

  if workshift.save
    workshifts_count += 1
  else
    puts workshift.errors.inspect
  end
end

puts "workshifts created: #{workshifts_count}"


